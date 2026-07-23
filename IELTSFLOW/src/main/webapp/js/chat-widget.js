document.addEventListener('DOMContentLoaded', () => {
    const widget = document.getElementById('ai-chat-widget');
    if (!widget) return;

    const toggleBtn = document.getElementById('ai-chat-toggle');
    const closeMobileBtn = document.getElementById('ai-chat-close-mobile');
    const inputField = document.getElementById('ai-chat-input');
    const sendBtn = document.getElementById('ai-chat-send');
    const messagesContainer = document.getElementById('ai-chat-messages');
    const typingIndicator = document.getElementById('ai-typing-indicator');

    // Toggle widget
    toggleBtn.addEventListener('click', () => {
        widget.classList.toggle('open');
        if (widget.classList.contains('open')) {
            setTimeout(() => inputField.focus(), 300);
        }
    });

    if (closeMobileBtn) {
        closeMobileBtn.addEventListener('click', () => {
            widget.classList.remove('open');
        });
    }

    // Auto resize input
    inputField.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
        sendBtn.disabled = this.value.trim().length === 0;
    });

    // Handle Enter key (Shift+Enter for new line)
    inputField.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });

    sendBtn.addEventListener('click', sendMessage);

    function formatMarkdown(text) {
        if (!text) return '';
        
        // Escape HTML
        let html = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        
        // Bold
        html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        
        // Italic (using * but avoiding list items)
        html = html.replace(/\*(.*?)\*/g, (match, p1) => {
            if (p1.trim() === '') return match;
            return `<em>${p1}</em>`;
        });
        
        // Code block inline
        html = html.replace(/`(.*?)`/g, '<code style="background:rgba(0,0,0,0.05);padding:2px 5px;border-radius:4px;color:#d97706;font-family:monospace;font-size:0.9em;">$1</code>');
        
        let lines = html.split('\n');
        let formattedLines = [];
        
        for (let line of lines) {
            // Headers
            if (/^###\s+(.*)/.test(line)) {
                line = line.replace(/^###\s+(.*)/, '<h4 style="margin:10px 0 4px;font-size:1.05em;font-weight:700;color:var(--accent-blue);">▍ $1</h4>');
            } else if (/^##\s+(.*)/.test(line)) {
                line = line.replace(/^##\s+(.*)/, '<h3 style="margin:12px 0 6px;font-size:1.15em;font-weight:800;color:var(--accent-blue);border-bottom:1px solid #e5e7eb;padding-bottom:4px;">$1</h3>');
            }
            // Unordered list
            else if (/^(\s*)[-*]\s+(.*)/.test(line)) {
                line = line.replace(/^(\s*)[-*]\s+(.*)/, '<div style="margin-left: 12px; margin-bottom: 6px; position: relative;"><span style="position: absolute; left: -12px; color: var(--accent-blue);">•</span>$2</div>');
            } 
            // Ordered list
            else if (/^(\s*)(\d+)\.\s+(.*)/.test(line)) {
                line = line.replace(/^(\s*)(\d+)\.\s+(.*)/, '<div style="margin-left: 16px; margin-bottom: 6px; position: relative;"><span style="position: absolute; left: -16px; font-weight: 600; color: var(--accent-blue);">$2.</span>$3</div>');
            }
            
            formattedLines.push(line);
        }
        
        html = formattedLines.join('<br>');
        
        // Clean up <br> after block elements (h3, h4, div)
        html = html.replace(/<\/h4><br>/g, '</h4>');
        html = html.replace(/<\/h3><br>/g, '</h3>');
        html = html.replace(/<\/div><br>/g, '</div>');
        
        // Remove extra consecutive breaks
        html = html.replace(/(<br>\s*){3,}/g, '<br><br>');
        
        return html;
    }

    function appendMessage(text, sender) {
        const msgDiv = document.createElement('div');
        msgDiv.className = `ai-message ${sender}`;
        
        if (sender === 'bot') {
            msgDiv.innerHTML = formatMarkdown(text);
        } else {
            msgDiv.textContent = text;
        }

        messagesContainer.insertBefore(msgDiv, typingIndicator);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    async function sendMessage() {
        const message = inputField.value.trim();
        if (!message) return;

        // Clear input
        inputField.value = '';
        inputField.style.height = 'auto';
        sendBtn.disabled = true;

        // Show user message
        appendMessage(message, 'user');

        // Show typing indicator
        typingIndicator.classList.add('active');
        messagesContainer.scrollTop = messagesContainer.scrollHeight;

        try {
            const response = await fetch((window.contextPath || '') + '/api/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ message: message })
            });

            if (!response.ok) {
                throw new Error('Server error');
            }

            // Hide typing indicator as we start receiving stream
            typingIndicator.classList.remove('active');
            
            const reader = response.body.getReader();
            const decoder = new TextDecoder("utf-8");
            
            // Create empty bot message div
            const botMsgDiv = document.createElement('div');
            botMsgDiv.className = 'ai-message bot';
            messagesContainer.insertBefore(botMsgDiv, typingIndicator);
            
            let accumulatedText = "";
            let buffer = "";

            while (true) {
                const { done, value } = await reader.read();
                if (done) break;
                
                buffer += decoder.decode(value, { stream: true });
                const lines = buffer.split("\n");
                buffer = lines.pop(); // keep the incomplete last line
                
                for (const line of lines) {
                    if (line.startsWith("data: ")) {
                        const dataStr = line.substring(6).trim();
                        if (dataStr === "[DONE]") {
                            break;
                        }
                        if (!dataStr) continue;
                        
                        try {
                            const dataObj = JSON.parse(dataStr);
                            if (dataObj.error) {
                                accumulatedText += "\n\n*Lỗi: " + dataObj.error + "*";
                                botMsgDiv.innerHTML = formatMarkdown(accumulatedText);
                                break;
                            }
                            if (dataObj.text) {
                                accumulatedText += dataObj.text;
                                botMsgDiv.innerHTML = formatMarkdown(accumulatedText);
                                messagesContainer.scrollTop = messagesContainer.scrollHeight;
                            }
                        } catch (e) {
                            console.error("Failed to parse SSE data", dataStr, e);
                        }
                    }
                }
            }

            if (!accumulatedText) {
                botMsgDiv.innerHTML = formatMarkdown("Xin lỗi, tôi không thể trả lời lúc này.");
            }
        } catch (error) {
            console.error('Chat error:', error);
            typingIndicator.classList.remove('active');
            appendMessage('Đã có lỗi xảy ra. Vui lòng thử lại sau.', 'bot');
        }
    }
});
