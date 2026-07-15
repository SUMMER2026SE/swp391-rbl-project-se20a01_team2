<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đang thi – IELTSFLOW</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
        body { margin: 0; padding: 0; background: #f3f4f6; color: #1f2937; font-family: Arial, Helvetica, sans-serif; }
        .top-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; display: flex; align-items: center; justify-content: space-between; padding: 0.5rem 2rem; background: #fff; border-bottom: 2px solid #e5e7eb; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .exam-title { font-weight: 800; font-size: 1.5rem; color: #dc2626; letter-spacing: -0.5px; }
        .exam-title span { color: #4b5563; font-weight: 500; margin-left: 1rem; font-size: 1rem; letter-spacing: 0; }
        .timer { display: flex; align-items: center; gap: 0.5rem; font-size: 1.25rem; font-weight: 700; font-variant-numeric: tabular-nums; color: #1f2937; background: #f3f4f6; padding: 0.25rem 1rem; border-radius: 20px; }
        .timer.warning { color: #ea580c; }
        .timer.danger { color: #dc2626; animation: blink 1s infinite; }
        @keyframes blink { 0%, 100% { opacity: 1 } 50% { opacity: 0.3 } }
        .violation-bar { display: none; }
        
        .main { margin-top: 65px; margin-bottom: 80px; padding: 0; }
        
        /* SKILLS (Parts) - In real CD IELTS these are at the bottom, but we keep them hidden or as tabs */
        .skill-tabs { display: none; }
        .skill-section { display: none; height: calc(100vh - 145px); }
        .skill-section.active { display: block; }
        
        .split-layout-container { display: flex; width: 100%; height: 100%; }
        .split-left { flex: 1; padding: 2rem; overflow-y: auto; background: #eaecf0; border-right: 4px solid #cbd5e1; margin: 0; box-shadow: none; }
        .split-right { flex: 1; padding: 2rem; overflow-y: auto; background: #eaecf0; margin: 0; box-shadow: none; border-left: 1px solid #cbd5e1; }
        
        .resource-box { font-size: 1.1rem; line-height: 1.8; color: #111827; }
        .resource-box p { margin-bottom: 1rem; }
        .resource-box audio { width: 100%; margin-bottom: 1rem; height: 40px; }
        
        .q-card { padding: 0; margin-bottom: 1.5rem; border: none; background: transparent; }
        .q-card:hover { border-color: transparent; box-shadow: none; }
        .q-num { display: inline-block; background: #fff; color: #111827; border-radius: 0; padding: 0.15rem 0.5rem; font-size: 1rem; font-weight: 700; margin-right: 0.75rem; margin-bottom: 0; min-width: 20px; text-align: center; border: 1px solid #cbd5e1; }
        .q-content { font-size: 1.05rem; font-weight: 400; line-height: 1.6; color: #111827; margin-bottom: 0.75rem; display: inline-block; }
        
        .choices { display: flex; flex-direction: column; gap: 0.5rem; }
        .choice { display: flex; align-items: center; gap: 0.75rem; padding: 0.5rem; border: 1px solid #cbd5e1; border-radius: 2px; cursor: pointer; background: #fff; }
        .choice:hover { background: #eff6ff; border-color: #bfdbfe; }
        .choice input[type=radio] { accent-color: #2563eb; width: 18px; height: 18px; cursor: pointer; }
        .choice .choice-text { font-size: 1rem; color: #1f2937; font-weight: 500; }
        
        .essay-area { width: 100%; min-height: 300px; padding: 1rem; border-radius: 6px; border: 1px solid #d1d5db; font-family: Arial, Helvetica, sans-serif; font-size: 1.05rem; line-height: 1.6; transition: border-color 0.2s; resize: vertical; }
        .essay-area:focus { outline: none; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .word-count { font-size: 0.9rem; color: #6b7280; text-align: right; margin-top: 0.5rem; font-weight: 600; }
        
        .speaking-controls { text-align: center; padding: 2rem 0; }
        .timer-circle { display: flex; align-items: center; justify-content: center; width: 100px; height: 100px; border-radius: 50%; border: 4px solid #3b82f6; font-size: 1.5rem; font-weight: 800; color: #1e3a8a; margin: 0 auto 1.5rem; }
        .rec-btn { padding: 0.75rem 2rem; border-radius: 2rem; border: none; font-weight: 700; font-size: 1rem; cursor: pointer; color: white; transition: transform 0.1s; }
        .rec-btn.start { background: #ef4444; }
        .rec-btn.stop { background: #4b5563; }
        .rec-btn:hover { transform: scale(1.05); }
        .transcript-display { margin-top: 1.5rem; padding: 1rem; background: #f3f4f6; border-radius: 6px; font-style: italic; color: #4b5563; }
        
        /* BOTTOM NAV - CD IELTS Style */
        .bottom-nav { position: fixed; bottom: 0; left: 0; right: 0; background: #fff; border-top: 2px solid #e5e7eb; display: flex; align-items: center; justify-content: space-between; padding: 0; height: 80px; z-index: 1000; box-shadow: 0 -2px 10px rgba(0,0,0,0.05); }
        .bottom-nav-left { display: flex; height: 100%; align-items: center; }
        .bottom-nav-left .skill-tab { height: 100%; background: transparent; border: none; border-right: 1px solid #e5e7eb; padding: 0 2rem; font-size: 1.1rem; font-weight: 700; color: #6b7280; cursor: pointer; }
        .bottom-nav-left .skill-tab.active { color: #dc2626; border-top: 4px solid #dc2626; background: #fef2f2; }
        .bottom-nav-left .skill-tab:hover { background: #f9fafb; }
        
        .nav-panel { position: relative; background: transparent; border: none; padding: 0; width: auto; max-height: none; top: auto; right: auto; margin: 0 1rem; display: flex; align-items: center; }
        .nav-panel h3 { display: none; }
        .nav-grid { display: flex; gap: 4px; overflow-x: auto; padding: 10px; max-width: 600px; }
        .nav-btn { width: 32px; height: 32px; flex-shrink: 0; border: 1px solid #9ca3af; border-radius: 4px; background: #fff; font-weight: 600; display: flex; align-items: center; justify-content: center; cursor: pointer; color: #1f2937; }
        .nav-btn.answered { background: #1f2937; color: #fff; border-color: #1f2937; }
        .nav-btn.flagged { border-radius: 50%; border-color: #d97706; }
        
        .bottom-nav-right { display: flex; align-items: center; padding-right: 2rem; gap: 1rem; }
        .btn-submit-exam { padding: 0.75rem 2rem; background: #dc2626; color: white; font-weight: 700; border: none; border-radius: 4px; font-size: 1.1rem; cursor: pointer; }
        .btn-submit-exam:hover { background: #b91c1c; }
        
        .overlay, .forced-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.9); z-index: 9999; display: none; flex-direction: column; align-items: center; justify-content: center; }
        .overlay.active, .forced-overlay.active { display: flex; }
        .overlay-card { background: #fff; border-radius: 8px; padding: 2.5rem; text-align: center; max-width: 500px; }
        .overlay-card h2 { color: #1f2937; margin-top: 0; }
        .overlay-card p { color: #4b5563; line-height: 1.6; }
        .btn-back-focus { background: #dc2626; color: white; border: none; padding: 1rem 2rem; border-radius: 4px; font-size: 1.1rem; font-weight: 700; cursor: pointer; width: 100%; margin-top: 1rem; }
        .btn-flag { display: none; }
        .btn-flag.active { background: #fef3c7; border-color: #f59e0b; color: #d97706; font-weight: bold; }
        
        /* Overrides */
        .q-skill-badge { display: none; }

        /* IELTS Listening Layout */
        #section-Listening .split-layout-container { flex-direction: column; }
        #section-Listening .split-layout-container { background: #fff; }
        #section-Listening .split-left { border-right: none; border-bottom: 2px solid #e5e7eb; padding: 1rem; flex: 0 0 auto; box-shadow: none; margin: 0; background: #fff; border-left: none; }
        #section-Listening .split-right { margin: 0 auto; width: 100%; max-width: 1000px; padding: 2rem; box-shadow: none; background: #fff; border-left: none; }
        #section-Listening .split-right { margin: 0 auto; width: 100%; max-width: 1000px; padding: 2rem; box-shadow: none; }
        #section-Listening .resource-box { display: flex; justify-content: center; }
        #section-Listening .resource-box audio { width: 50%; }
        #section-Listening h4 { text-align: center; font-size: 1.5rem; margin-bottom: 0.5rem; }
        
        /* Settings Popup */
        .settings-popup { display: none; position: absolute; top: 60px; right: 20px; background: #fff; border: 1px solid #d1d5db; border-radius: 8px; padding: 1.5rem; box-shadow: 0 4px 15px rgba(0,0,0,0.1); z-index: 1001; width: 250px; }
        .settings-popup.active { display: block; }
        .settings-popup h4 { margin-top: 0; margin-bottom: 1rem; color: #1f2937; }
        .volume-control { display: flex; align-items: center; gap: 10px; }
        .volume-control input[type=range] { flex: 1; cursor: pointer; }


        /* IELTS Speaking Custom UI */
        #section-Speaking .split-layout-container { flex-direction: column; background: #f8fafc; align-items: center; justify-content: flex-start; min-height: 100%; padding-top: 4rem; }
        #section-Speaking .split-left { display: none; }
        #section-Speaking .split-right { margin: 0 auto; width: 100%; max-width: 700px; padding: 2rem; box-shadow: 0 4px 15px rgba(0,0,0,0.05); background: #fff; border-radius: 8px; border: 1px solid #e2e8f0; text-align: center; }
        
        .timer-circle { width: 130px; height: 130px; border-radius: 50%; border: 6px solid #3b82f6; font-size: 2rem; font-weight: 800; display: flex; align-items: center; justify-content: center; margin: 0 auto 2.5rem; color: #1e3a8a; transition: all 0.3s; box-shadow: 0 0 15px rgba(59, 130, 246, 0.2); background: #fff; }
        .timer-circle.recording { border-color: #ef4444; color: #ef4444; box-shadow: 0 0 25px rgba(239, 68, 68, 0.4); animation: pulse-red 1.5s infinite; }
        @keyframes pulse-red { 0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.5); } 70% { box-shadow: 0 0 0 25px rgba(239, 68, 68, 0); } 100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); } }
        
        .rec-btn { padding: 1rem 3rem; border-radius: 3rem; border: none; font-weight: 800; font-size: 1.15rem; cursor: pointer; color: white; transition: all 0.2s; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-transform: uppercase; letter-spacing: 1px; }
        .rec-btn.start { background: linear-gradient(135deg, #ef4444, #dc2626); }
        .rec-btn.stop { background: linear-gradient(135deg, #64748b, #475569); }
        .rec-btn:hover { transform: translateY(-2px); box-shadow: 0 6px 12px rgba(0,0,0,0.15); }
        .transcript-display { margin-top: 2rem; padding: 1.5rem; background: #f1f5f9; border-radius: 8px; font-style: italic; color: #334155; font-size: 1.1rem; border-left: 4px solid #3b82f6; text-align: left; min-height: 80px; }

</style>
            </head>

            <body>

                <!-- TOP BAR -->
                <div class="top-bar">
                    <div class="exam-title">
                        IELTS <span>${exam.title} - ${exam.skillFocus}</span>
                    </div>
                    <div class="timer" id="timer">00:00:00</div>
                    <div style="position: relative;">
                        <button type="button" id="btn-settings" style="background: transparent; border: none; font-size: 1.5rem; cursor: pointer; color: #4b5563;">⚙️</button>
                        <div class="settings-popup" id="settings-popup">
                            <h4>Settings</h4>
                            <label style="display:block; margin-bottom:0.5rem; color:#4b5563; font-size:0.9rem;">Master Volume</label>
                            <div class="volume-control">
                                <span>🔈</span>
                                <input type="range" id="master-volume" min="0" max="1" step="0.05" value="1">
                                <span>🔊</span>
                            </div>
                        </div>
                    </div>
                </div>
<!-- VIOLATION WARNING OVERLAY -->
                <div class="overlay" id="violation-overlay">
                    <div class="overlay-card">
                        <h2>⚠️ Cảnh báo vi phạm!</h2>
                        <p id="violation-msg">Bạn đã thoát toàn màn hình hoặc chuyển tab.<br>Vi phạm lần: <strong
                                id="vio-count">1</strong> / 3.<br>Nếu vi phạm đủ 3 lần, bài thi sẽ tự động nộp.</p>
                        <button class="btn-back-focus" id="btn-back-focus">🔒 Quay lại thi</button>
                    </div>
                </div>

                <!-- FORCED SUBMIT OVERLAY -->
                <div class="forced-overlay" id="forced-overlay">
                    <h1>🚫 Bài thi đã kết thúc</h1>
                    <p>Bạn đã vi phạm quy định thi quá 3 lần. Bài làm được tự động nộp và đánh dấu vi phạm.</p>
                    <div style="color:#94a3b8;font-size:.9rem;">Đang nộp bài...</div>
                </div>

                <!-- START EXAM OVERLAY -->
                <div class="overlay active" id="start-overlay">
                    <div class="overlay-card accent" style="max-width:520px;">
                        <h2>🔒 PHÒNG THI BẢO MẬT</h2>
                        <div
                            style="color:#94a3b8;font-size:.9rem;text-align:left;line-height:1.8;margin-bottom:1.75rem;">
                            <p>Chào mừng bạn đến với phòng thi <strong>IELTSFlow</strong>.</p>
                            <p>Hệ thống đã kích hoạt chế độ <strong>Giám sát trực tuyến (Online Proctoring)</strong>.
                            </p>
                            <div
                                style="margin-top:1rem;background:rgba(239,68,68,.08);border-left:4px solid #ef4444;padding:.75rem;border-radius:.4rem;color:#fca5a5;">
                                <strong>⚠️ QUY ĐỊNH PHÒNG THI:</strong><br>
                                1. Hệ thống sẽ khóa toàn màn hình. Không được tự ý thoát.<br>
                                2. Tuyệt đối không được chuyển tab hoặc ẩn trình duyệt.<br>
                                3. Vi phạm quá <strong>3 lần</strong>, hệ thống sẽ <strong>tự động nộp bài lập
                                    tức</strong>.
                            </div>
                            <p style="margin-top:1rem;font-style:italic;text-align:center;">Vui lòng chuẩn bị sẵn sàng
                                và bấm nút bên dưới để mở toàn màn hình &amp; bắt đầu tính giờ làm bài.</p>
                        </div>
                        <button class="btn-back-focus" id="btn-start-exam"
                            style="width:100%;background:linear-gradient(135deg,#6366f1,#8b5cf6);border-radius:.75rem;padding:.85rem;font-size:1.05rem;letter-spacing:.02em;">
                            🔓 KÍCH HOẠT BẢO MẬT &amp; BẮT ĐẦU LÀM BÀI
                        </button>
                    </div>
                </div>

                <!-- MAIN CONTENT -->
                <div class="main">
<c:set var="skills" value="${['Listening','Reading','Writing','Speaking']}" />
                    <form method="post" action="${pageContext.request.contextPath}/candidate/mock-test?action=submit" id="exam-form" style="height: 100%;">
                        <input type="hidden" name="action" value="submit">
                        <input type="hidden" name="submissionId" value="${submissionId}">

                        <c:forEach var="sk" items="${skills}" varStatus="skSt">
                            <div class="skill-section ${skSt.first ? 'active' : ''}" id="section-${sk}">
                                <c:set var="qNum" value="${0}" />
                                <c:set var="firstSec" value="true" />
                                <c:forEach var="sec" items="${sections}">
                                    <c:if test="${sec.skill == sk}">
                                        <div class="exam-section-part" id="exam-sec-${sec.sectionId}" style="display: ${firstSec ? 'block' : 'none'}; height: 100%;">
                                        <div class="split-layout-container">
                                            <!-- LEFT PANE: Resource -->
                                            <div class="split-left">
                                                <h4>${sec.sectionName}</h4>
                                                
                                                <c:if test="${sk == 'Writing'}">
                                                    <!-- Special layout for Writing: Show all question prompts here, toggled by JS -->
                                                    <c:forEach var="xQ" items="${sec.examQuestions}" varStatus="ws">
                                                        <div class="writing-prompt-box" id="prompt_${xQ.question.questionId}" style="display: ${ws.first ? 'block' : 'none'}; font-size: 1.05rem; line-height: 1.6; color: #111827; margin-top: 1.5rem;">
                                                            ${xQ.question.content}
                                                        </div>
                                                    </c:forEach>
                                                </c:if>
                                                
                                                <c:if test="${sk != 'Writing'}">
                                                    <!-- Find the shared resource from the first question -->
                                                    <c:set var="sharedAudio" value="" />
                                                    <c:set var="sharedText" value="" />
                                                    <c:forEach var="xQ" items="${sec.examQuestions}">
                                                        <c:if test="${not empty xQ.question.resourceAudioUrl and empty sharedAudio}">
                                                            <c:set var="sharedAudio" value="${xQ.question.resourceAudioUrl}" />
                                                        </c:if>
                                                        <c:if test="${not empty xQ.question.resourceText and empty sharedText}">
                                                            <c:set var="sharedText" value="${xQ.question.resourceText}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    
                                                    <c:if test="${not empty sharedText || not empty sharedAudio}">
                                                        <div class="resource-box">
                                                            <c:if test="${not empty sharedAudio}">
                                                                <audio controls src="${sharedAudio}"></audio>
                                                            </c:if>
                                                            <c:if test="${not empty sharedText}">
                                                                ${sharedText}
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${empty sharedText && empty sharedAudio}">
                                                        <div style="color: #9ca3af; font-style: italic; text-align: center; margin-top: 2rem;">Read the questions on the right carefully.</div>
                                                    </c:if>
                                                </c:if>
                                            </div>
                                            
                                            <!-- RIGHT PANE: Questions -->
                                            <div class="split-right">
                                                <c:forEach var="examQ" items="${sec.examQuestions}">
                                                    <c:set var="q" value="${examQ.question}"/>
                                                    <c:set var="qNum" value="${qNum + 1}" />
            
                                                    
            
                                                    <div class="q-card" id="qcard_${q.questionId}" data-qid="${q.questionId}" data-qtype="${q.questionType}">
                                                        <c:if test="${sk != 'Writing' && sk != 'Speaking'}">
                                                            <div style="display: flex; align-items: flex-start;">
                                                                <span class="q-num">${qNum}</span>
                                                                <div class="q-content">${q.content}</div>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${sk == 'Speaking'}">
                                                            <div style="margin-bottom: 2rem; text-align: left; font-size: 1.15rem; font-weight: 500; color: #1e293b; line-height: 1.6; background: #f8fafc; padding: 1.5rem; border-radius: 6px; border: 1px solid #e2e8f0;">
                                                                ${q.content}
                                                            </div>
                                                        </c:if>
                                                        
                                                        <!-- Input fields -->
                                                        <c:choose>
                                                            <c:when test="${q.questionType == 'Multiple_Choice'}">
                                                                <div class="choices">
                                                                    <c:set var="correctCount" value="0" />
                                                                    <c:forEach var="ans" items="${q.answers}">
                                                                        <c:if test="${ans.correct}">
                                                                            <c:set var="correctCount" value="${correctCount + 1}" />
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <c:set var="inputType" value="${correctCount > 1 ? 'checkbox' : 'radio'}" />
                                                                    <c:forEach var="ans" items="${q.answers}">
                                                                        <label class="choice" for="ans_${ans.answerId}">
                                                                            <input type="${inputType}" name="q_${q.questionId}" id="ans_${ans.answerId}" value="${ans.answerId}">
                                                                            <span class="choice-text">${ans.content}</span>
                                                                        </label>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${q.questionType == 'Essay' || q.questionType == 'Writing' || sk == 'Writing'}">
                                                                <textarea class="essay-area" style="height: calc(100vh - 280px); width: 100%; border: 1px solid #94a3b8; border-radius: 2px; padding: 1rem; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05); font-family: Arial; font-size: 1.05rem; resize: none; background: #fff;" name="q_${q.questionId}" id="essay_${q.questionId}" placeholder="" oninput="countWords(this, 'wc_${q.questionId}')"></textarea>
                                                                <div class="word-count" id="wc_${q.questionId}" style="text-align: left; margin-top: 0.5rem; font-weight: 700; color: #4b5563;">Word count: 0</div>
                                                            </c:when>
                                                            <c:when test="${q.questionType == 'Speaking'}">
                                                                <div class="speaking-controls">
                                                                    <div class="timer-circle" id="rec-timer-${q.questionId}">00:00</div>
                                                                    <div>
                                                                        <button type="button" class="rec-btn start" onclick="startRecording(${q.questionId})" id="btn-rec-${q.questionId}">Start Recording</button>
                                                                        <button type="button" class="rec-btn stop" onclick="stopRecording(${q.questionId})" id="btn-stop-${q.questionId}" style="display:none">Stop Recording</button>
                                                                    </div>
                                                                    <div class="transcript-display" id="transcript-${q.questionId}">Status: Not recorded</div>
                                                                    <input type="hidden" name="transcript_${q.questionId}" id="hidden-transcript-${q.questionId}">
                                                                    <input type="hidden" name="azure_${q.questionId}" id="hidden-azure-${q.questionId}" value="0">
                                                                    <input type="hidden" name="q_${q.questionId}" value="">
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${q.questionType == 'FillInBlanks' || q.questionType == 'FillBlank'}">
                                                                <!-- Inputs are rendered inline in the q-content via Javascript -->
                                                                <input type="hidden" name="q_${q.questionId}" id="hidden_fib_${q.questionId}" value="">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="text" name="q_${q.questionId}" placeholder="Enter your answer" style="width:100%;padding:0.75rem;border-radius:4px;border:1px solid #d1d5db;font-size:1rem;font-family:inherit;">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        </div>
                                        <c:set var="firstSec" value="false" />
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:forEach>

                        <!-- BOTTOM NAV -->
                        <div class="bottom-nav">
                            <div class="bottom-nav-left">
                                <c:forEach var="sk" items="${skills}" varStatus="st">
                                    <button class="skill-tab ${st.first ? 'active' : ''}" onclick="switchSkill('${sk}')" id="tab-${sk}" type="button">${sk}</button>
                                </c:forEach>
                            </div>
                            
                            <div class="nav-panel" id="nav-panel">
                                <h3>Questions</h3>
                                <div class="nav-grid" id="nav-grid">
                                    <!-- JS will populate buttons here -->
                                </div>
                            </div>
                            
                            <div class="bottom-nav-right">
                                <button type="submit" class="btn-submit-exam" id="btn-submit-exam" onclick="return confirmSubmit()">
                                    Submit
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <script>
                    // ── COUNTDOWN TIMER ──────────────────────────────────────────────
                    const TOTAL_SECONDS = ${ exam.duration } * 60;
                    let secondsLeft = TOTAL_SECONDS;
                    const timerEl = document.getElementById('timer');
                    let isExamStarted = false;

                    function formatTime(s) {
                        const h = Math.floor(s / 3600).toString().padStart(2, '0');
                        const m = Math.floor((s % 3600) / 60).toString().padStart(2, '0');
                        const sec = (s % 60).toString().padStart(2, '0');
                        return h + ':' + m + ':' + sec;
                    }
                    const countdown = setInterval(() => {
                        if (!isExamStarted) return;
                        secondsLeft--;
                        timerEl.textContent = formatTime(secondsLeft);
                        if (secondsLeft <= 300) timerEl.classList.add('warning');
                        if (secondsLeft <= 60) { timerEl.classList.remove('warning'); timerEl.classList.add('danger'); }
                        if (secondsLeft <= 0) { clearInterval(countdown); isExamStarted = false; document.getElementById('exam-form').submit(); }
                    }, 1000);

                    // ── FOCUS MODE — Fullscreen + Tab detection ───────────────────────
                    let violationCount = 0;
                    const MAX_VIOLATIONS = ${ maxViolations };
                    const submissionId = ${ submissionId };

                    function requestFullscreen() {
                        const el = document.documentElement;
                        if (el.requestFullscreen) el.requestFullscreen();
                        else if (el.webkitRequestFullscreen) el.webkitRequestFullscreen();
                    }
                    function isFullscreen() {
                        return !!(document.fullscreenElement || document.webkitFullscreenElement);
                    }

                    document.getElementById('btn-start-exam').addEventListener('click', () => {
                        requestFullscreen();
                        isExamStarted = true;
                        document.getElementById('start-overlay').classList.remove('active');
                        timerEl.textContent = formatTime(secondsLeft);
                    });

                    document.addEventListener('visibilitychange', () => {
                        if (!isExamStarted) return;
                        if (document.hidden) triggerViolation('tab');
                    });
                    document.addEventListener('fullscreenchange', () => {
                        if (!isExamStarted) return;
                        if (!isFullscreen()) triggerViolation('fullscreen');
                    });

                    function triggerViolation(type) {
                        if (violationCount >= MAX_VIOLATIONS) return;
                        fetch('${pageContext.request.contextPath}/candidate/mock-test?action=violation', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'action=violation&submissionId=' + submissionId
                        })
                            .then(r => r.json())
                            .then(data => {
                                violationCount = data.violations;
                                // updateViolationDots(violationCount);
                                document.getElementById('vio-count').textContent = violationCount;
                                if (data.cheated) {
                                    isExamStarted = false;
                                    document.getElementById('forced-overlay').classList.add('active');
                                    document.getElementById('exam-form').submit();
                                } else {
                                    document.getElementById('violation-overlay').classList.add('active');
                                }
                            })
                            .catch(() => { });
                    }

                    
                    document.getElementById('btn-back-focus').addEventListener('click', () => {
                        document.getElementById('violation-overlay').classList.remove('active');
                        requestFullscreen();
                    });

                    // ── SKILL TABS ────────────────────────────────────────────────────
                    function switchSkill(skill) {
                        document.querySelectorAll('.skill-tab').forEach(t => t.classList.remove('active'));
                        document.querySelectorAll('.skill-section').forEach(s => s.classList.remove('active'));
                        document.getElementById('tab-' + skill).classList.add('active');
                        document.getElementById('section-' + skill).classList.add('active');
                        buildNavigator(skill);
                    }

                    // ── QUESTION NAVIGATOR ────────────────────────────────────────────
                    function switchPart(skill, secId) {
                        const section = document.getElementById('section-' + skill);
                        if (!section) return;
                        
                        const parts = section.querySelectorAll('.exam-section-part');
                        parts.forEach(p => {
                            p.style.display = 'none';
                        });
                        
                        const target = document.getElementById('exam-sec-' + secId);
                        if (target) {
                            target.style.display = 'block';
                        }
                        
                        buildNavigator(skill);
                    }

                    function buildNavigator(skill) {
                        const grid = document.getElementById('nav-grid');
                        grid.innerHTML = '';
                        const section = document.getElementById('section-' + skill);
                        if (!section) return;
                        
                        const parts = section.querySelectorAll('.exam-section-part');
                        parts.forEach((part, partIndex) => {
                            const secId = part.id.replace('exam-sec-', '');
                            
                            const partGroup = document.createElement('div');
                            partGroup.className = 'nav-part-group';
                            partGroup.style.display = 'flex';
                            partGroup.style.alignItems = 'center';
                            partGroup.style.marginRight = '1rem';
                            partGroup.style.borderRight = '1px solid #e5e7eb';
                            partGroup.style.paddingRight = '1rem';
                            
                            const partLabel = document.createElement('button');
                            partLabel.type = 'button';
                            partLabel.className = 'nav-part-label';
                            partLabel.innerText = 'Part ' + (partIndex + 1);
                            partLabel.style.marginRight = '10px';
                            partLabel.style.fontWeight = 'bold';
                            partLabel.style.background = 'transparent';
                            partLabel.style.border = 'none';
                            partLabel.style.cursor = 'pointer';
                            if (part.style.display !== 'none') {
                                partLabel.style.color = '#dc2626';
                                partLabel.style.borderBottom = '2px solid #dc2626';
                            } else {
                                partLabel.style.color = '#6b7280';
                            }
                            
                            partLabel.onclick = () => {
                                switchPart(skill, secId);
                            };
                            partGroup.appendChild(partLabel);
                            
                            const qGrid = document.createElement('div');
                            qGrid.style.display = 'flex';
                            qGrid.style.gap = '4px';
                            
                            const qCards = part.querySelectorAll('.q-card');
                            qCards.forEach((card, index) => {
                                let numStr = (index + 1).toString();
                                const numEl = card.querySelector('.q-num');
                                if (numEl) {
                                    numStr = numEl.innerText.replace(/[^0-9]/g, '');
                                }
                                const qId = card.getAttribute('data-qid');
                                
                                const btn = document.createElement('div');
                                btn.className = 'nav-btn';
                                btn.id = 'navbtn_' + qId;
                                btn.innerText = numStr;
                                
                                if (card.classList.contains('flagged')) btn.classList.add('flagged');
                                if (checkIfAnswered(card)) btn.classList.add('answered');
                                
                                btn.onclick = () => {
                                    if (part.style.display === 'none') {
                                        switchPart(skill, secId);
                                    }
                                    setTimeout(() => {
                                        card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                        card.style.borderColor = '#6366f1';
                                        setTimeout(() => card.style.borderColor = '', 1500);
                                    }, 100);
                                };
                                qGrid.appendChild(btn);
                            });
                            
                            partGroup.appendChild(qGrid);
                            grid.appendChild(partGroup);
                        });
                    }

                    function checkIfAnswered(card) {
                        const inputs = card.querySelectorAll('input[type="radio"]:checked, input[type="checkbox"]:checked, input[type="text"], textarea');
                        let answered = false;
                        inputs.forEach(inp => {
                            if (inp.type === 'radio' && inp.checked) answered = true;
                            else if (inp.type === 'checkbox' && inp.checked) answered = true;
                            else if (inp.type === 'text' && inp.value.trim().length > 0) answered = true;
                            else if (inp.tagName === 'TEXTAREA' && inp.value.trim().length > 0) answered = true;
                        });
                        const hiddenRec = card.querySelector('input[type="hidden"][name^="transcript_"]');
                        if (hiddenRec && hiddenRec.value.trim().length > 0) answered = true;
                        return answered;
                    }

                    function updateNavStatus() {
                        document.querySelectorAll('.q-card').forEach(card => {
                            const qId = card.getAttribute('data-qid');
                            const btn = document.getElementById('navbtn_' + qId);
                            if (btn) {
                                if (checkIfAnswered(card)) btn.classList.add('answered');
                                else btn.classList.remove('answered');
                            }
                        });
                    }

                    document.addEventListener('input', (e) => {
                        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') updateNavStatus();
                    });
                    document.addEventListener('change', (e) => {
                        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') updateNavStatus();
                    });

                    function toggleFlag(qId) {
                        const card = document.getElementById('qcard_' + qId);
                        const btn = card.querySelector('.btn-flag');
                        const navBtn = document.getElementById('navbtn_' + qId);
                        card.classList.toggle('flagged');
                        btn.classList.toggle('active');
                        if (navBtn) navBtn.classList.toggle('flagged');
                    }

                    setTimeout(() => {
                        const activeTab = document.querySelector('.skill-tab.active');
                        if (activeTab) switchSkill(activeTab.innerText.trim());
                    }, 100);

                    // ── FILL IN BLANKS LOGIC ──────────────────────────────────────────
                    document.querySelectorAll('.q-card[data-qtype="FillInBlanks"], .q-card[data-qtype="FillBlank"]').forEach(card => {
                        const qId = card.getAttribute('data-qid');
                        const contentDiv = card.querySelector('.q-content');
                        if (contentDiv) {
                            // Replace (1), (2), etc. with inline text inputs
                            contentDiv.innerHTML = contentDiv.innerHTML.replace(/\((\d+)\)/g, function(match, number) {
                                return '<input type="text" class="fib-input" data-qid="' + qId + '" data-blank-id="' + number + '" style="width: 100px; padding: 2px 5px; border: 1px solid #d1d5db; border-radius: 4px; margin: 0 4px; display: inline-block;">';
                            });
                        }
                    });

                    document.getElementById('exam-form').addEventListener('submit', function() {
                        const fibCards = document.querySelectorAll('.q-card[data-qtype="FillInBlanks"], .q-card[data-qtype="FillBlank"]');
                        fibCards.forEach(card => {
                            const qId = card.getAttribute('data-qid');
                            const inputs = card.querySelectorAll('.fib-input');
                            if (inputs.length > 0) {
                                const ansObj = {};
                                inputs.forEach(inp => {
                                    ansObj[inp.getAttribute('data-blank-id')] = inp.value.trim();
                                });
                                let hiddenInput = document.getElementById('hidden_fib_' + qId);
                                if (hiddenInput) {
                                    hiddenInput.value = JSON.stringify(ansObj);
                                }
                            }
                        });
                    });

                    // ── WORD COUNT (Writing) ──────────────────────────────────────────
                    function countWords(textarea, counterId) {
                        const words = textarea.value.trim().split(/\s+/).filter(w => w.length > 0);
                        document.getElementById(counterId).textContent = words.length + ' từ';
                    }

                    // ── SPEAKING — MediaRecorder & STT via Azure ────────────────────
                    const mediaRecorders = {};
                    const audioChunksMap = {};
                    const recTimers = {};

                    async function startRecording(qId) {
                        try {
                            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
                            const mediaRecorder = new MediaRecorder(stream);
                            audioChunksMap[qId] = [];

                            mediaRecorder.ondataavailable = event => {
                                if (event.data.size > 0) {
                                    audioChunksMap[qId].push(event.data);
                                }
                            };

                            mediaRecorder.onstop = async () => {
                                document.getElementById('transcript-' + qId).textContent = 'Trạng thái: Đang xử lý âm thanh với hệ thống...';
                                const rawBlob = new Blob(audioChunksMap[qId], { type: 'audio/webm' });
                                
                                try {
                                    const audioBlob = await convertBlobToWav(rawBlob);

                                    const formData = new FormData();
                                    formData.append('audioFile', audioBlob, 'speaking.wav');
                                    formData.append('isUnscripted', 'true');

                                    fetch('${pageContext.request.contextPath}/api/speech/assess', {
                                        method: 'POST',
                                        body: formData
                                    })
                                    .then(r => r.json())
                                    .then(data => {
                                        if(data.success && data.data) {
                                            document.getElementById('hidden-transcript-' + qId).value = data.data.recognizedText || '';
                                            document.getElementById('hidden-azure-' + qId).value = data.data.pronunciationScore || 0;
                                            document.getElementById('transcript-' + qId).textContent = 'Trạng thái: Đã ghi âm và xử lý xong.';
                                            updateNavStatus();
                                        } else {
                                            document.getElementById('transcript-' + qId).textContent = 'Trạng thái: Lỗi xử lý âm thanh (' + (data.error || 'Unknown') + ')';
                                        }
                                    })
                                    .catch(err => {
                                        console.error(err);
                                        document.getElementById('transcript-' + qId).textContent = 'Trạng thái: Lỗi kết nối đến máy chủ!';
                                    });
                                } catch(e) {
                                    console.error('Lỗi khi convert sang WAV:', e);
                                    document.getElementById('transcript-' + qId).textContent = 'Trạng thái: Lỗi convert âm thanh!';
                                }

                                // Dọn dẹp stream
                                stream.getTracks().forEach(track => track.stop());
                            };

                            mediaRecorder.start();
                            mediaRecorders[qId] = mediaRecorder;
                            
                            document.querySelector('[name="q_' + qId + '"]').value = 'recorded';
                            document.getElementById('transcript-' + qId).textContent = 'Đang ghi âm... (Vui lòng nói rõ ràng)';
                            document.getElementById('btn-rec-' + qId).style.display = 'none';
                            document.getElementById('btn-stop-' + qId).style.display = '';

                            let secs = 0;
                            document.getElementById('rec-timer-' + qId).textContent = '00:00';
                            recTimers[qId] = setInterval(() => {
                                secs++;
                                const m = Math.floor(secs/60).toString().padStart(2,'0');
                                const s = (secs%60).toString().padStart(2,'0');
                                document.getElementById('rec-timer-' + qId).textContent = m + ':' + s;
                            }, 1000);
                            
                        } catch (e) {
                            alert('Có lỗi xảy ra khi bắt đầu thu âm (Mic access denied?): ' + e.message);
                        }
                    }

                    function stopRecording(qId) {
                        if (mediaRecorders[qId]) { 
                            mediaRecorders[qId].stop(); 
                            delete mediaRecorders[qId]; 
                        }
                        clearInterval(recTimers[qId]);
                        document.getElementById('btn-rec-' + qId).style.display = '';
                        document.getElementById('btn-stop-' + qId).style.display = 'none';
                    }

                    // ── SUBMIT CONFIRM ─────────────────────────────────────────────────
                    function confirmSubmit() {
                        const ok = confirm('Bạn có chắc chắn muốn nộp bài? Hành động này không thể hoàn tác.');
                        if (ok) isExamStarted = false;
                        return ok;
                    }

                    // ── AUDIO CONVERT TO WAV ───────────────────────────────────────────
                    async function convertBlobToWav(blob) {
                        const arrayBuffer = await blob.arrayBuffer();
                        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
                        const audioBuffer = await audioContext.decodeAudioData(arrayBuffer);
                        return audioBufferToWav(audioBuffer);
                    }

                    function audioBufferToWav(buffer) {
                        const numOfChan = buffer.numberOfChannels,
                            length = buffer.length * numOfChan * 2 + 44,
                            bufferWav = new ArrayBuffer(length),
                            view = new DataView(bufferWav),
                            channels = [],
                            sampleRate = buffer.sampleRate;
                        let offset = 0, pos = 0;

                        setUint32(0x46464952);                         // "RIFF"
                        setUint32(length - 8);                         // file length - 8
                        setUint32(0x45564157);                         // "WAVE"
                        setUint32(0x20746d66);                         // "fmt " chunk
                        setUint32(16);                                 // length = 16
                        setUint16(1);                                  // PCM
                        setUint16(numOfChan);
                        setUint32(sampleRate);
                        setUint32(sampleRate * 2 * numOfChan);         // avg. bytes/sec
                        setUint16(numOfChan * 2);                      // block-align
                        setUint16(16);                                 // 16-bit
                        setUint32(0x61746164);                         // "data" - chunk
                        setUint32(length - pos - 4);                   // chunk length

                        for (let i = 0; i < buffer.numberOfChannels; i++)
                            channels.push(buffer.getChannelData(i));

                        while (pos < length) {
                            for (let i = 0; i < numOfChan; i++) {
                                let sample = Math.max(-1, Math.min(1, channels[i][offset]));
                                sample = (0.5 + sample < 0 ? sample * 32768 : sample * 32767) | 0;
                                view.setInt16(pos, sample, true);
                                pos += 2;
                            }
                            offset++;
                        }

                        return new Blob([bufferWav], { type: "audio/wav" });

                        function setUint16(data) { view.setUint16(pos, data, true); pos += 2; }
                        function setUint32(data) { view.setUint32(pos, data, true); pos += 4; }
                    }
                
                    // ── SETTINGS & VOLUME ─────────────────────────────────────────────
                    const btnSettings = document.getElementById('btn-settings');
                    const popupSettings = document.getElementById('settings-popup');
                    const masterVolume = document.getElementById('master-volume');
                    
                    if(btnSettings && popupSettings) {
                        btnSettings.addEventListener('click', () => {
                            popupSettings.classList.toggle('active');
                        });
                        
                        // Close popup when clicking outside
                        document.addEventListener('click', (e) => {
                            if (!btnSettings.contains(e.target) && !popupSettings.contains(e.target)) {
                                popupSettings.classList.remove('active');
                            }
                        });
                        
                        masterVolume.addEventListener('input', (e) => {
                            const vol = e.target.value;
                            document.querySelectorAll('audio').forEach(audio => {
                                audio.volume = vol;
                            });
                        });
                    }

                    // ── WRITING PROMPT SWITCHER ───────────────────────────────────────
                    const writingObserver = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                const qId = entry.target.getAttribute('data-qid');
                                const allPrompts = document.querySelectorAll('.writing-prompt-box');
                                if (allPrompts.length > 0) {
                                    allPrompts.forEach(p => p.style.display = 'none');
                                    const targetPrompt = document.getElementById('prompt_' + qId);
                                    if (targetPrompt) targetPrompt.style.display = 'block';
                                }
                            }
                        });
                    }, { root: null, threshold: 0.5 });

                    // We need to wait for DOM to be ready, but this script is at the bottom anyway
                    setTimeout(() => {
                        document.querySelectorAll('#section-Writing .q-card').forEach(card => {
                            writingObserver.observe(card);
                        });
                    }, 500);

                </script>
                <script src="${pageContext.request.contextPath}/js/api.js?v=<%= System.currentTimeMillis() %>"></script>
</body>

            </html>



