# API Test Assertions

Tài liệu này cung cấp các đoạn test script assertion (cú pháp của **Postman / Newman**) cho các endpoint được định nghĩa trong `API_Endpoints.md`. Các đoạn script này dùng để kiểm tra tính hợp lệ của HTTP Status Code, thời gian phản hồi, và cấu trúc dữ liệu trả về.

---

## 1. Authentication Endpoints (Xác thực & Quản lý Tài khoản)

### 1.1. Login (`/api/auth/login` hoặc `/login`)
**Mô tả:** Kiểm tra đăng nhập với email và mật khẩu.

**Postman Test Script:**
```javascript
pm.test("Status code is 200 (Thành công)", function () {
    pm.response.to.have.status(200);
});

pm.test("Response time is acceptable (< 800ms)", function () {
    pm.expect(pm.response.responseTime).to.be.below(800);
});

pm.test("Response contains session or token", function () {
    // Nếu trả về JSON:
    try {
        var jsonData = pm.response.json();
        pm.expect(jsonData).to.have.property("status");
        if(jsonData.status === "success") {
            pm.expect(jsonData).to.have.property("data"); 
            // pm.expect(jsonData.data).to.have.property("token");
        }
    } catch(e) {
        // Nếu dùng Cookie-based (JSP/Servlet truyền thống):
        pm.expect(pm.cookies.has("JSESSIONID")).to.be.true;
    }
});
```

### 1.2. Register (`/register`)
**Mô tả:** Đăng ký tài khoản học viên mới.

**Postman Test Script:**
```javascript
pm.test("Status code is 201 Created or 200 OK", function () {
    pm.expect(pm.response.code).to.be.oneOf([200, 201]);
});

pm.test("Response message indicates success", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("message");
    // Thay đổi text tuỳ theo thông điệp thực tế trả về
    pm.expect(jsonData.message).to.include("success");
});
```

### 1.3. Google Auth (`/auth/google`, `/api/auth/google`)
**Mô tả:** Đăng nhập/Đăng ký qua tài khoản Google.

**Postman Test Script:**
```javascript
pm.test("Status code is 200 or 302 Redirect", function () {
    pm.expect(pm.response.code).to.be.oneOf([200, 302]);
});

pm.test("Should redirect to Google OAuth URL (if 302)", function () {
    if (pm.response.code === 302) {
        pm.response.to.have.header("Location");
        pm.expect(pm.response.headers.get("Location")).to.include("accounts.google.com");
    }
});
```

### 1.4. Logout (`/api/auth/logout`, `/logout`)
**Mô tả:** Đăng xuất và xoá Session.

**Postman Test Script:**
```javascript
pm.test("Status code is 200 OK or 302 Redirect (to login)", function () {
    pm.expect(pm.response.code).to.be.oneOf([200, 302]);
});

pm.test("JSESSIONID Cookie is cleared or expired", function () {
    // Thường cookie được xoá bằng cách trả về header Set-Cookie với thời hạn trong quá khứ
    let setCookieHeader = pm.response.headers.get("Set-Cookie");
    if (setCookieHeader && setCookieHeader.includes("JSESSIONID")) {
        pm.expect(setCookieHeader).to.match(/Max-Age=0|Expires=.*1970/);
    }
});
```

### 1.5. Forgot Password (`/forgot-password`)
**Mô tả:** Yêu cầu gửi email khôi phục mật khẩu.

**Postman Test Script:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response confirms email sent", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("message");
    pm.expect(jsonData.message.toLowerCase()).to.include("email");
});
```

### 1.6. Change Password (`/change-password`)
**Mô tả:** Đổi mật khẩu. Bắt buộc user phải có session / token trước khi gọi (cần setup token ở Auth tab).

**Postman Test Script:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response confirms password changed", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("status");
    pm.expect(jsonData.status).to.eql("success");
});
```

### 1.7. Verify Email (`/verify-email`)
**Mô tả:** Xác thực tài khoản sau khi đăng ký bằng query parameter (VD: `?token=abc...`).

**Postman Test Script:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Returns success page or message", function () {
    try {
        var jsonData = pm.response.json();
        pm.expect(jsonData.status).to.eql("success");
    } catch(e) {
        // Trường hợp API trả về giao diện HTML (JSP)
        pm.expect(pm.response.text()).to.include("thành công");
    }
});
```

### 1.8. Auth Middleware Catch (`/auth`)
**Mô tả:** Xử lý điều hướng hoặc lỗi chung. Nếu không có token/session gọi API bảo mật, mong đợi trả về lỗi 401.

**Postman Test Script (khi gọi API không kèm Session/Token):**
```javascript
pm.test("Status code is 401 Unauthorized or 403 Forbidden", function () {
    pm.expect(pm.response.code).to.be.oneOf([401, 403]);
});

pm.test("Error message is descriptive", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property("error");
});
```
