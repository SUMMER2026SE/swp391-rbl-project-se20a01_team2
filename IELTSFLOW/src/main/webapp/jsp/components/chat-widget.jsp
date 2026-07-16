<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Link CSS if not already linked in the parent page -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat-widget.css?v=${System.currentTimeMillis()}">

<div id="ai-chat-widget" class="ai-chat-widget">
    <!-- Chat Toggle Button -->
    <button id="ai-chat-toggle" class="ai-chat-toggle">
        <i class="fas fa-comment-dots" style="font-family: Arial, sans-serif;">💬</i>
    </button>

    <!-- Chat Window -->
    <div class="ai-chat-window">
        <div class="ai-chat-header">
            <div class="ai-avatar">✨</div>
            <div class="ai-chat-header-info">
                <h3>IELTSFLOW AI</h3>
                <p>Trợ lý học tập thông minh</p>
            </div>
            <button id="ai-chat-close-mobile" class="ai-chat-close-mobile">×</button>
        </div>

        <div id="ai-chat-messages" class="ai-chat-messages">
            <div class="ai-message bot">
                <p>Chào bạn! Mình là trợ lý AI của IELTSFLOW.</p>
                <p>Bạn có câu hỏi gì về tiếng Anh hay phương pháp học/dạy IELTS không?</p>
            </div>
            
            <div id="ai-typing-indicator" class="ai-typing-indicator">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>

        <div class="ai-chat-input-area">
            <textarea id="ai-chat-input" class="ai-chat-input" placeholder="Nhập tin nhắn..." rows="1"></textarea>
            <button id="ai-chat-send" class="ai-chat-send" disabled>
                <span style="font-size: 18px;">➤</span>
            </button>
        </div>
    </div>
</div>

<!-- Load Script -->
<script src="${pageContext.request.contextPath}/js/chat-widget.js?v=${System.currentTimeMillis()}"></script>
