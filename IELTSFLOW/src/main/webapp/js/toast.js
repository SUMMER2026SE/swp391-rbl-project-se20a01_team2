function showToast(message, type = 'success', duration = 3500) {
    let toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        toastContainer.style.zIndex = '9999';
        document.body.appendChild(toastContainer);
    }

    const toastId = 'toast-' + Date.now();
    const color = type === 'success' ? 'text-bg-success' : 'text-bg-danger';
    const icon = type === 'success' ? '<i class="fa-solid fa-check-circle me-2"></i>' : '<i class="fa-solid fa-triangle-exclamation me-2"></i>';
    
    const toastHtml = `
        <div id="${toastId}" class="toast align-items-center ${color} border-0 show" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-bold">
                    ${icon} ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    const toastElement = document.getElementById(toastId);
    
    setTimeout(() => {
        if (toastElement) {
            toastElement.classList.remove('show');
            setTimeout(() => toastElement.remove(), 300);
        }
    }, duration);
}
