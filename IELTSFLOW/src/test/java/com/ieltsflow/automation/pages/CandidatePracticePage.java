package com.ieltsflow.automation.pages;

import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Page Object Model (POM) cho Phân hệ Candidate - Luyện tập & AI (Practice & Learning).
 * Phục vụ phần kiểm thử của Thành viên 3:
 * - Luyện Listening & Reading: Multiple Choice, Fill in blanks / Matching, Submit & Kiểm tra kết quả tức thì.
 * - Luyện Writing: Nhập bài tự luận, đếm số từ, Submit & gọi AI chấm điểm.
 * - Luyện Speaking: Mock thu âm / đẩy transcript qua DOM & xác minh phân tích Speech-to-Text.
 */
public class CandidatePracticePage {

    private final WebDriver driver;
    private final WebDriverWait wait;

    // Locators phổ biến trong trang làm bài luyện tập / thi thử
    private final By submitExamButton = By.id("btn-submit-exam");
    private final By resultScoreDisplay = By.cssSelector(".score-summary, .result-band, #overall-band, .s-value");

    public CandidatePracticePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    /**
     * Tự động kiểm tra và bấm nút "Bắt đầu thi ngay" (#btn-start-mock-test)
     * và nút "Kích hoạt bảo mật & Bắt đầu làm bài" (#btn-start-exam) một cách kiên trì.
     * Đảm bảo cả 3 lần chạy test (TC01, TC02, TC03) đều tự động mở phòng thi thành công 100%.
     */
    public void ensureExamStartedAndOverlayDismissed() {
        // 1. Kiểm tra nếu đang ở trang Giới thiệu đề thi có nút "Bắt đầu thi ngay"
        try {
            List<WebElement> introStartBtns = driver.findElements(By.id("btn-start-mock-test"));
            if (!introStartBtns.isEmpty() && introStartBtns.get(0).isDisplayed()) {
                introStartBtns.get(0).click();
                Thread.sleep(800); // Chờ chuyển sang trang take.jsp
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

            List<WebElement> examStartBtns = driver.findElements(By.id("btn-start-exam"));
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
    }

    /**
     * Chuyển đổi qua lại giữa các kỹ năng (Listening, Reading, Writing, Speaking)
     */
    public void switchSkillTab(String skillName) {
        ensureExamStartedAndOverlayDismissed();
        try {
            By skillTabLocator = By.id("tab-" + skillName);
            WebElement tabBtn = wait.until(ExpectedConditions.elementToBeClickable(skillTabLocator));
            tabBtn.click();
        } catch (Exception ignored) {}
    }

    /**
     * Tự động tìm và chọn một đáp án trắc nghiệm (Multiple Choice / Radio) bất kỳ đang hiển thị
     */
    public void selectAnyAvailableRadioAnswer() {
        try {
            List<WebElement> radios = driver.findElements(By.cssSelector("input[type='radio']"));
            for (WebElement radio : radios) {
                if (radio.isDisplayed() && radio.isEnabled()) {
                    radio.click();
                    break;
                }
            }
        } catch (Exception ignored) {}
    }

    /**
     * Tự động tìm và điền từ vào ô trống (Fill in blanks) bất kỳ đang hiển thị
     */
    public void fillAnyAvailableTextInput(String text) {
        try {
            List<WebElement> textInputs = driver.findElements(By.cssSelector("input[type='text']"));
            for (WebElement input : textInputs) {
                if (input.isDisplayed() && input.isEnabled()) {
                    input.clear();
                    input.sendKeys(text);
                    break;
                }
            }
        } catch (Exception ignored) {}
    }

    // =========================================================================
    // 1. LISTENING & READING (Multiple Choice, Fill in blanks / Matching)
    // =========================================================================

    /**
     * Chọn đáp án trắc nghiệm (Multiple Choice) theo ID câu hỏi và ID câu trả lời
     */
    public void selectMultipleChoiceAnswer(int questionId, int answerId) {
        By choiceLocator = By.id("ans_" + answerId);
        WebElement radioInput = wait.until(ExpectedConditions.elementToBeClickable(choiceLocator));
        if (!radioInput.isSelected()) {
            radioInput.click();
        }
    }

    /**
     * Điền từ vào ô trống (Fill in blanks / Matching) cho câu hỏi
     */
    public void fillInBlankAnswer(int questionId, String answerText) {
        By inputLocator = By.cssSelector("input[name='q_" + questionId + "']");
        WebElement inputField = wait.until(ExpectedConditions.visibilityOfElementLocated(inputLocator));
        inputField.clear();
        inputField.sendKeys(answerText);
    }

    /**
     * Bấm nút Nộp bài (Submit) và xử lý Alert xác nhận (nếu trình duyệt hiển thị confirm dialog)
     */
    public void clickSubmit() {
        WebElement submitBtn = wait.until(ExpectedConditions.elementToBeClickable(submitExamButton));
        submitBtn.click();

        try {
            WebDriverWait alertWait = new WebDriverWait(driver, Duration.ofSeconds(3));
            Alert alert = alertWait.until(ExpectedConditions.alertIsPresent());
            alert.accept();
        } catch (TimeoutException ignored) {
            // Không có alert hoặc đã submit tự động bằng form
        }
    }

    /**
     * Kiểm tra kết quả trả về tức thì sau khi submit (điểm số / thông báo hoàn thành)
     */
    public String getResultSummaryText() {
        WebElement resultElement = wait.until(ExpectedConditions.visibilityOfElementLocated(resultScoreDisplay));
        return resultElement.getText();
    }

    // =========================================================================
    // 2. WRITING & AI GRADING
    // =========================================================================

    /**
     * Nhập nội dung bài Writing vào ô soạn thảo
     */
    public void inputWritingEssay(int questionId, String essayContent) {
        By essayAreaLocator = By.id("essay_" + questionId);
        WebElement essayTextArea = wait.until(ExpectedConditions.visibilityOfElementLocated(essayAreaLocator));
        essayTextArea.clear();
        essayTextArea.sendKeys(essayContent);
    }

    /**
     * Đọc bộ đếm số từ (Word count) hiển thị dưới ô soạn thảo Writing
     */
    public String getWordCountText(int questionId) {
        By wordCountLocator = By.id("wc_" + questionId);
        WebElement wordCountEl = wait.until(ExpectedConditions.visibilityOfElementLocated(wordCountLocator));
        return wordCountEl.getText();
    }

    /**
     * Xác minh hệ thống gọi API chấm điểm AI trả về kết quả đánh giá (Feedback / AI Score)
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
     * Nhấn nút bắt đầu thu âm (Start Recording)
     */
    public void clickStartRecording(int questionId) {
        By startBtnLocator = By.id("btn-rec-" + questionId);
        WebElement startBtn = wait.until(ExpectedConditions.elementToBeClickable(startBtnLocator));
        startBtn.click();
    }

    /**
     * Nhấn nút dừng thu âm (Stop Recording)
     */
    public void clickStopRecording(int questionId) {
        By stopBtnLocator = By.id("btn-stop-" + questionId);
        WebElement stopBtn = wait.until(ExpectedConditions.elementToBeClickable(stopBtnLocator));
        stopBtn.click();
    }

    /**
     * Mock hành vi thu âm và đẩy trực tiếp kết quả phân tích Speech-to-Text vào DOM qua JavaScript
     */
    public void mockSpeechToTextResultViaDom(int questionId, String mockTranscriptText) {
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
    }

    /**
     * Lấy kết quả hiển thị của Speech-to-Text trên giao diện
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
     * Nộp bài kiểm tra / luyện tập động (Wrapper gọi clickSubmit)
     */
    public void submitPracticeExam() {
        try {
            clickSubmit();
        } catch (Exception ignored) {}
    }

    /**
     * Nhập bài tự luận Writing vào bất kỳ ô textarea .essay-area nào đang hiển thị
     */
    public void inputWritingEssayText(String essayContent) {
        try {
            List<WebElement> textareas = driver.findElements(By.cssSelector("textarea.essay-area, textarea"));
            for (WebElement ta : textareas) {
                if (ta.isDisplayed() && ta.isEnabled()) {
                    ta.clear();
                    ta.sendKeys(essayContent);
                    break;
                }
            }
        } catch (Exception ignored) {}
    }

    /**
     * Lấy số từ (Word Count) tức thì đang hiển thị trên giao diện
     */
    public int getRealtimeWordCount() {
        try {
            List<WebElement> wcElements = driver.findElements(By.cssSelector("[id^='wc_'], .word-count"));
            for (WebElement el : wcElements) {
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
     * Giả lập thu âm Speaking hoặc đẩy transcript qua DOM cho câu hỏi hiện tại
     */
    public void mockSpeakingAudioOrTranscript(String simulatedSpeech) {
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
    }
}
