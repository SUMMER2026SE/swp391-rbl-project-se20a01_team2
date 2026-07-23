package controller;

import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SubscriptionPackage;
import model.Transaction;
import model.User;
import org.junit.jupiter.api.*;
import util.JpaHelper;

import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class PaymentIntegrationTest {

    private CheckoutServlet checkoutServlet;
    private SePayWebhookServlet sepayServlet;

    private User testUser;
    private SubscriptionPackage testPackage;

    @BeforeAll
    public void setupAll() {
        // Cấu hình để JpaHelper dùng H2 database thay vì SQL Server
        System.setProperty("PERSISTENCE_UNIT", "IELTSFLOW_TEST");
        System.setProperty("DB_URL", "jdbc:h2:mem:ieltsflow_test;DB_CLOSE_DELAY=-1");
        System.setProperty("DB_USER", "sa");
        System.setProperty("DB_PASSWORD", "");
    }

    @BeforeEach
    public void setup() throws Exception {
        checkoutServlet = new CheckoutServlet();
        checkoutServlet.init();

        sepayServlet = new SePayWebhookServlet();
        sepayServlet.init();

        // Xóa sạch database trước mỗi test
        JpaHelper.execute(em -> {
            em.createQuery("DELETE FROM SystemLog").executeUpdate();
            em.createQuery("DELETE FROM Transaction").executeUpdate();
            em.createQuery("DELETE FROM SubscriptionPackage").executeUpdate();
            em.createQuery("DELETE FROM User").executeUpdate();
        });

        // Seed dữ liệu mẫu cho bài test
        JpaHelper.execute(em -> {
            testUser = new User();
            testUser.setFullName("Test User");
            testUser.setEmail("test@ieltsflow.com");
            testUser.setPasswordHash("hashed");
            testUser.setStatus("Active");
            testUser.setRoleId(3); // Candidate
            em.persist(testUser);

            testPackage = new SubscriptionPackage();
            testPackage.setName("Premium 1 Month");
            testPackage.setPrice(new BigDecimal("100000"));
            testPackage.setDurationMonths(1);
            testPackage.setDeleted(false);
            em.persist(testPackage);
        });
    }

    // TEST 1: Kiểm tra luồng tạo Transaction thành công (CheckoutServlet)
    @Test
    public void testCheckout_Success_ShouldCreateTransaction() throws Exception {
        // Arrange
        HttpServletRequest req = mock(HttpServletRequest.class);
        HttpServletResponse resp = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(testUser.getUserId());
        when(req.getParameter("packageId")).thenReturn(String.valueOf(testPackage.getPackageId()));
        when(req.getContextPath()).thenReturn("/ieltsflow");

        // Act
        checkoutServlet.doPost(req, resp);

        // Assert
        // Xác minh response đã gọi sendRedirect tới checkout kèm transaction ID
        verify(resp, atLeastOnce()).sendRedirect(argThat(url -> url.startsWith("/ieltsflow/checkout?id=")));

        // Truy vấn DB kiểm tra giao dịch đã được tạo
        Transaction createdTx = JpaHelper.query(em -> 
            em.createQuery("SELECT t FROM Transaction t WHERE t.userId = :uid", Transaction.class)
              .setParameter("uid", testUser.getUserId())
              .getSingleResult()
        );

        assertNotNull(createdTx);
        assertEquals("Pending", createdTx.getStatus());
        assertEquals(0, createdTx.getAmount().compareTo(new BigDecimal("100000")));
    }

    // TEST 2: Kiểm tra luồng Webhook nạp đúng số tiền (SePayWebhookServlet)
    @Test
    public void testWebhook_ExactAmount_ShouldUpdateToSuccess() throws Exception {
        // Arrange: Tạo giao dịch Pending trong DB
        Transaction tx = new Transaction();
        JpaHelper.execute(em -> {
            tx.setUserId(testUser.getUserId());
            tx.setSubscriptionPackage(testPackage);
            tx.setAmount(new BigDecimal("100000"));
            tx.setPaymentMethod("VietQR - SePay");
            tx.setStatus("Pending");
            em.persist(tx);
        });

        HttpServletRequest req = mock(HttpServletRequest.class);
        HttpServletResponse resp = mock(HttpServletResponse.class);

        // Giả lập payload JSON từ SePay gửi qua webhook
        String jsonPayload = String.format(
            "{\"gateway\": \"SePay\", \"transferType\": \"in\", \"transferAmount\": 100000, \"content\": \"IF%d\", \"code\": \"IF%d\", \"id\": \"SEPAY_123\"}",
            tx.getTransactionId(), tx.getTransactionId()
        );
        
        BufferedReader reader = new BufferedReader(new StringReader(jsonPayload));
        when(req.getReader()).thenReturn(reader);

        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(resp.getWriter()).thenReturn(writer);

        // Act
        sepayServlet.doPost(req, resp);

        // Assert
        assertTrue(stringWriter.toString().contains("\"success\": true"));

        Transaction updatedTx = JpaHelper.query(em -> em.find(Transaction.class, tx.getTransactionId()));
        assertEquals("Success", updatedTx.getStatus(), "Transaction should be marked as Success");
        
        // Kiểm tra UserSubscription đã được tạo mới
        model.UserSubscription userSub = JpaHelper.query(em -> 
            em.createQuery("SELECT us FROM UserSubscription us WHERE us.userId = :uid AND us.status = 'Active'", model.UserSubscription.class)
              .setParameter("uid", testUser.getUserId())
              .getSingleResult()
        );
        assertNotNull(userSub, "A new UserSubscription should be created");
        assertEquals(testPackage.getPackageId(), userSub.getSubscriptionPackage().getPackageId(), "Subscription should map to correct package");
    }

    // TEST 3: Kiểm tra luồng Webhook nạp thiếu tiền (SePayWebhookServlet)
    @Test
    public void testWebhook_Underpaid_ShouldUpdateToFailedAndLog() throws Exception {
        // Arrange: Tạo giao dịch Pending 100k
        Transaction tx = new Transaction();
        JpaHelper.execute(em -> {
            tx.setUserId(testUser.getUserId());
            tx.setSubscriptionPackage(testPackage);
            tx.setAmount(new BigDecimal("100000"));
            tx.setPaymentMethod("VietQR - SePay");
            tx.setStatus("Pending");
            em.persist(tx);
        });

        HttpServletRequest req = mock(HttpServletRequest.class);
        HttpServletResponse resp = mock(HttpServletResponse.class);

        // Giả lập webhook gửi vào chỉ nạp 50k (Thiếu tiền)
        String jsonPayload = String.format(
            "{\"gateway\": \"SePay\", \"transferType\": \"in\", \"transferAmount\": 50000, \"content\": \"IF%d\", \"code\": \"IF%d\", \"id\": \"SEPAY_999\"}",
            tx.getTransactionId(), tx.getTransactionId()
        );
        
        BufferedReader reader = new BufferedReader(new StringReader(jsonPayload));
        when(req.getReader()).thenReturn(reader);

        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(resp.getWriter()).thenReturn(writer);

        // Act
        sepayServlet.doPost(req, resp);

        // Assert
        Transaction updatedTx = JpaHelper.query(em -> em.find(Transaction.class, tx.getTransactionId()));
        assertEquals("Failed", updatedTx.getStatus(), "Transaction should be marked as Failed because of underpayment");

        // Kiểm tra SystemLog đã ghi lại lỗi nạp thiếu
        long logCount = JpaHelper.query(em -> 
            em.createQuery("SELECT COUNT(s) FROM SystemLog s WHERE s.userId = :uid AND s.action = 'Invalid Transaction'", Long.class)
              .setParameter("uid", testUser.getUserId())
              .getSingleResult()
        );
        assertTrue(logCount > 0, "A system log should have been created for the invalid transaction");
    }
}
