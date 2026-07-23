(function() {
    function showErrorBanner(msg, source, lineno, colno, error) {
        // Prevent recursive errors
        if (msg && msg.toString().includes('ResizeObserver')) return;
        
        if (document.getElementById('global-error-banner')) {
            document.getElementById('global-error-banner-msg').innerText = msg + '\n' + (error && error.stack ? error.stack : '');
            return;
        }
        const banner = document.createElement('div');
        banner.id = 'global-error-banner';
        banner.style.position = 'fixed';
        banner.style.top = '0';
        banner.style.left = '0';
        banner.style.width = '100%';
        banner.style.backgroundColor = '#ff4d4f';
        banner.style.color = '#fff';
        banner.style.padding = '15px';
        banner.style.zIndex = '999999';
        banner.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
        banner.style.fontFamily = 'monospace';
        banner.style.fontSize = '14px';
        banner.style.maxHeight = '300px';
        banner.style.overflowY = 'auto';
        
        banner.innerHTML = `
            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 10px;">
                <strong style="font-size: 16px;">🚨 JavaScript Error:</strong>
                <button onclick="this.parentElement.parentElement.remove()" style="background:transparent; border:none; color:white; font-size:16px; cursor:pointer;">✖</button>
            </div>
            <pre id="global-error-banner-msg" style="margin:0; white-space:pre-wrap; word-wrap:break-word;">${msg}\n${error && error.stack ? error.stack : ''}</pre>
        `;
        if (document.body) {
            document.body.appendChild(banner);
        } else {
            document.addEventListener('DOMContentLoaded', () => document.body.appendChild(banner));
        }
    }

    window.addEventListener('error', function(e) {
        showErrorBanner(e.message, e.filename, e.lineno, e.colno, e.error);
    });

    window.addEventListener('unhandledrejection', function(e) {
        showErrorBanner(e.reason ? e.reason.toString() : 'Unhandled Promise Rejection', null, null, null, e.reason);
    });
})();
