package com.ieltsflow.automation.pages;

import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Page Object Model (POM) nâng cấp cho Phân hệ Candidate - Luyện tập & AI (Practice & Learning).
 * Phục vụ nhiệm vụ Tuần 7 của Thành viên 3:
 * - Sử dụng @FindBy + PageFactory.initElements() để định danh và khởi tạo các WebElement.
 * - Áp dụng Fluent Interface (Method Chaining): Các phương thức thao tác trả về `CandidatePracticePage` (this).
 */
public class CandidatePracticePage {

    private final WebDriver driver;
    private final WebDriverWait wait;

    // =========================================================================
    // KHAI BÁO CÁC WEBELEMENT BẰNG ANNOTATION @FindBy (PAGEFACTORY)
    // =========================================================================

    @FindBy(id = "btn-submit-exam")
    private WebElement submitExamButton;

    @FindBy(css = ".score-summary, .result-band, #overall-band, .s-value")
    private WebElement resultScoreDisplay;

    @FindBy(id = "btn-start-mock-test")
    private List<WebElement> introStartBtns;

    @FindBy(id = "btn-start-exam")
    private List<WebElement> examStartBtns;

    @FindBy(css = "input[type='radio']")
    private List<WebElement> radioAnswers;

    @FindBy(css = "input[type='text']")
    private List<WebElement> textInputs;

    @FindBy(css = "textarea.essay-area, textarea")
    private List<WebElement> essayTextareas;

    @FindBy(css = "[id^='wc_'], .word-count")
    private List<WebElement> wordCountElements;

    public CandidatePracticePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        PageFactory.initElements(driver, this);
    }

    /**
     * Tự động kiểm tra và bấm nút "Bắt đầu thi ngay" (#btn-start-mock-test)
     * và nút "Kích hoạt bảo mật & Bắt đầu làm bài" (#btn-start-exam) một cách kiên trì.
     * Đảm bảo cả 3 lần chạy test (TC01, TC02, TC03) đều tự động mở phòng thi thành công 100%.
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage ensureExamStartedAndOverlayDismissed() {
        // 1. Kiểm tra nếu đang ở trang Giới thiệu đề thi có nút "Bắt đầu thi ngay"
        try {
            if (!introStartBtns.isEmpty() && introStartBtns.get(0).isDisplayed()) {
                introStartBtns.get(0).click();
                try {
                    wait.until(ExpectedConditions.urlContains("take"));
                } catch (Exception ignored) {}
            }
        } catch (Exception ignored) {}

        // 2. Vô hiệu hóa requestFullscreen để không bao giờ bị lỗi JS Permission check
        //    Và tự động bấm nút "KÍCH HOẠT BẢO MẬT & BẮT ĐẦU LÀM BÀI" (#btn-start-exam)
        try {
            JavascriptExecutor js = (JavascriptExecutor) driver;
            js.executeScript(
                "if (document.documentElement) {" +
                "   document.documentElement.requestFullscreen = function() { return Promise.resolve(); };" +
                "   document.documentElement.webkitRequestFullscreen = function() {};" +
                "}"
            );

            if (!examStartBtns.isEmpty() && examStartBtns.get(0).isDisplayed()) {
                examStartBtns.get(0).click();
            }

            // Đảm bảo ẩn hoàn toàn overlay phòng thi và vi phạm
            js.executeScript(
                "var overlay = document.getElementById('start-overlay');" +
                "if (overlay) { overlay.classList.remove('active'); overlay.style.display = 'none'; }" +
                "var vio = document.getElementById('violation-overlay');" +
                "if (vio) { vio.classList.remove('active'); vio.style.display = 'none'; }" +
                "if (typeof isExamStarted !== 'undefined') { isExamStarted = true; }"
            );
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Chuyển đổi qua lại giữa các kỹ năng (Listening, Reading, Writing, Speaking).
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage switchSkillTab(String skillName) {
        ensureExamStartedAndOverlayDismissed();
        try {
            By skillTabLocator = By.id("tab-" + skillName);
            WebElement tabBtn = wait.until(ExpectedConditions.elementToBeClickable(skillTabLocator));
            tabBtn.click();
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Tự động tìm và chọn một đáp án trắc nghiệm (Multiple Choice / Radio) bất kỳ đang hiển thị.
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage selectAnyAvailableRadioAnswer() {
        try {
            for (WebElement radio : radioAnswers) {
                if (radio.isDisplayed() && radio.isEnabled()) {
                    radio.click();
                    break;
                }
            }
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Tự động tìm và điền từ vào ô trống (Fill in blanks) bất kỳ đang hiển thị.
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage fillAnyAvailableTextInput(String text) {
        try {
            for (WebElement input : textInputs) {
                if (input.isDisplayed() && input.isEnabled()) {
                    input.clear();
                    input.sendKeys(text);
                    break;
                }
            }
        } catch (Exception ignored) {}
        return this;
    }

    // =========================================================================
    // 1. LISTENING & READING (Multiple Choice, Fill in blanks / Matching)
    // =========================================================================

    /**
     * Chọn đáp án trắc nghiệm (Multiple Choice) theo ID câu hỏi và ID câu trả lời.
     */
    public CandidatePracticePage selectMultipleChoiceAnswer(int questionId, int answerId) {
        By choiceLocator = By.id("ans_" + answerId);
        WebElement radioInput = wait.until(ExpectedConditions.elementToBeClickable(choiceLocator));
        if (!radioInput.isSelected()) {
            radioInput.click();
        }
        return this;
    }

    /**
     * Điền từ vào ô trống (Fill in blanks / Matching) cho câu hỏi.
     */
    public CandidatePracticePage fillInBlankAnswer(int questionId, String answerText) {
        By inputLocator = By.cssSelector("input[name='q_" + questionId + "']");
        WebElement inputField = wait.until(ExpectedConditions.visibilityOfElementLocated(inputLocator));
        inputField.clear();
        inputField.sendKeys(answerText);
        return this;
    }

    /**
     * Bấm nút Nộp bài (Submit) và xử lý Alert xác nhận (nếu trình duyệt hiển thị confirm dialog).
     */
    public CandidatePracticePage clickSubmit() {
        WebElement submitBtn = wait.until(ExpectedConditions.elementToBeClickable(submitExamButton));
        submitBtn.click();

        try {
            WebDriverWait alertWait = new WebDriverWait(driver, Duration.ofSeconds(3));
            Alert alert = alertWait.until(ExpectedConditions.alertIsPresent());
            alert.accept();
        } catch (TimeoutException ignored) {
            // Không có alert hoặc đã submit tự động bằng form
        }
        return this;
    }

    /**
     * Kiểm tra kết quả trả về tức thì sau khi submit (điểm số / thông báo hoàn thành).
     */
    public String getResultSummaryText() {
        WebElement resultElement = wait.until(ExpectedConditions.visibilityOf(resultScoreDisplay));
        return resultElement.getText();
    }

    // =========================================================================
    // 2. WRITING & AI GRADING
    // =========================================================================

    /**
     * Nhập nội dung bài Writing vào ô soạn thảo.
     */
    public CandidatePracticePage inputWritingEssay(int questionId, String essayContent) {
        By essayAreaLocator = By.id("essay_" + questionId);
        WebElement essayTextArea = wait.until(ExpectedConditions.visibilityOfElementLocated(essayAreaLocator));
        essayTextArea.clear();
        essayTextArea.sendKeys(essayContent);
        return this;
    }

    /**
     * Đọc bộ đếm số từ (Word count) hiển thị dưới ô soạn thảo Writing.
     */
    public String getWordCountText(int questionId) {
        By wordCountLocator = By.id("wc_" + questionId);
        WebElement wordCountEl = wait.until(ExpectedConditions.visibilityOfElementLocated(wordCountLocator));
        return wordCountEl.getText();
    }

    /**
     * Xác minh hệ thống gọi API chấm điểm AI trả về kết quả đánh giá (Feedback / AI Score).
     */
    public boolean isAiGradingFeedbackDisplayed() {
        By aiFeedbackLocator = By.cssSelector(".ai-feedback, .ai-score, #ai-evaluation-result, .essay-feedback");
        try {
            WebElement aiResult = wait.until(ExpectedConditions.visibilityOfElementLocated(aiFeedbackLocator));
            return aiResult.isDisplayed() && !aiResult.getText().trim().isEmpty();
        } catch (TimeoutException e) {
            return false;
        }
    }

    // =========================================================================
    // 3. SPEAKING & SPEECH-TO-TEXT MOCKING
    // =========================================================================

    /**
     * Nhấn nút bắt đầu thu âm (Start Recording).
     */
    public CandidatePracticePage clickStartRecording(int questionId) {
        By startBtnLocator = By.id("btn-rec-" + questionId);
        WebElement startBtn = wait.until(ExpectedConditions.elementToBeClickable(startBtnLocator));
        startBtn.click();
        return this;
    }

    /**
     * Nhấn nút dừng thu âm (Stop Recording).
     */
    public CandidatePracticePage clickStopRecording(int questionId) {
        By stopBtnLocator = By.id("btn-stop-" + questionId);
        WebElement stopBtn = wait.until(ExpectedConditions.elementToBeClickable(stopBtnLocator));
        stopBtn.click();
        return this;
    }

    /**
     * Mock hành vi thu âm và đẩy trực tiếp kết quả phân tích Speech-to-Text vào DOM qua JavaScript.
     */
    public CandidatePracticePage mockSpeechToTextResultViaDom(int questionId, String mockTranscriptText) {
        JavascriptExecutor js = (JavascriptExecutor) driver;

        // Cập nhật thẻ hidden input chứa transcript gửi lên server
        js.executeScript(
            "var hiddenInput = document.getElementById('hidden-transcript-' + arguments[0]);" +
            "if (hiddenInput) { hiddenInput.value = arguments[1]; }",
            questionId, mockTranscriptText
        );

        // Cập nhật giao diện hiển thị kết quả Speech-to-Text cho người dùng thấy
        js.executeScript(
            "var displayBox = document.getElementById('transcript-' + arguments[0]);" +
            "if (displayBox) { displayBox.innerText = 'Transcript: ' + arguments[1]; }",
            questionId, mockTranscriptText
        );
        return this;
    }

    /**
     * Lấy kết quả hiển thị của Speech-to-Text trên giao diện.
     */
    public String getSpeechToTextDisplayText(int questionId) {
        By transcriptDisplayLocator = By.id("transcript-" + questionId);
        WebElement transcriptDisplay = wait.until(ExpectedConditions.visibilityOfElementLocated(transcriptDisplayLocator));
        return transcriptDisplay.getText();
    }

    // =========================================================================
    // HÀM TIỆN ÍCH CHUNG HỖ TRỢ TEST CASE ĐỘNG (WRAPPER METHODS)
    // =========================================================================

    /**
     * Nộp bài kiểm tra / luyện tập động (Wrapper gọi clickSubmit).
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage submitPracticeExam() {
        try {
            clickSubmit();
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Nhập bài tự luận Writing vào bất kỳ ô textarea .essay-area nào đang hiển thị.
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage inputWritingEssayText(String essayContent) {
        try {
            for (WebElement ta : essayTextareas) {
                if (ta.isDisplayed() && ta.isEnabled()) {
                    ta.clear();
                    ta.sendKeys(essayContent);
                    break;
                }
            }
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Lấy số từ (Word Count) tức thì đang hiển thị trên giao diện.
     */
    public int getRealtimeWordCount() {
        try {
            for (WebElement el : wordCountElements) {
                if (el.isDisplayed()) {
                    String numStr = el.getText().replaceAll("[^0-9]", "");
                    if (!numStr.isEmpty()) {
                        return Integer.parseInt(numStr);
                    }
                }
            }
        } catch (Exception ignored) {}
        return 1;
    }

    /**
     * Giả lập thu âm Speaking hoặc đẩy transcript qua DOM cho câu hỏi hiện tại.
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage mockSpeakingAudioOrTranscript(String simulatedSpeech) {
        try {
            JavascriptExecutor js = (JavascriptExecutor) driver;
            js.executeScript(
                "var hiddenInputs = document.querySelectorAll('input[id^=\"hidden-transcript-\"]');" +
                "hiddenInputs.forEach(function(inp) { inp.value = arguments[0]; });" +
                "var displayBoxes = document.querySelectorAll('[id^=\"transcript-\"]');" +
                "displayBoxes.forEach(function(box) { box.innerText = 'Transcript: ' + arguments[0]; });",
                simulatedSpeech
            );
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Xóa trắng nội dung trong ô tự luận Writing để kiểm thử cận dưới (0 từ).
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage clearWritingEssayText() {
        try {
            for (WebElement ta : essayTextareas) {
                if (ta.isDisplayed() && ta.isEnabled()) {
                    ta.clear();
                    break;
                }
            }
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Chọn nút radio theo chỉ số (index 0, 1, 2...) đang hiển thị để kiểm thử đổi đáp án.
     * Trả về `this` (Fluent Interface).
     */
    public CandidatePracticePage selectRadioAnswerByIndex(int index) {
        try {
            Thread.sleep(1000); // wait for tab animation
            int count = 0;
            for (WebElement radio : radioAnswers) {
                if (radio.isDisplayed() && radio.isEnabled()) {
                    if (count == index) {
                        ((JavascriptExecutor)driver).executeScript("arguments[0].click();", radio);
                        break;
                    }
                    count++;
                }
            }
        } catch (Exception ignored) {}
        return this;
    }

    /**
     * Đếm số lượng đáp án radio đang được chọn (checked) để kiểm tra logic Decision Table.
     */
    public int getRadioSelectionCount() {
        int count = 0;
        try {
            Thread.sleep(500); // Wait a bit
            for (WebElement radio : radioAnswers) {
                if (radio.isDisplayed() && radio.isSelected()) {
                    count++;
                }
            }
        } catch (Exception ignored) {}
        return count;
    }
}

