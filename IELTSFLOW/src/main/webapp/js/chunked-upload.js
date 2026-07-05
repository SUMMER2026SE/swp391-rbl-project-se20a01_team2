/**
 * chunked-upload.js
 * Handles resumable, concurrent chunked uploads for files > 10MB.
 */

const CHUNK_SIZE = 10 * 1024 * 1024; // 10MB
const MAX_CONCURRENT = 3;
const MAX_RETRIES = 3;

// Generate deterministic upload ID based on file metadata
async function generateDeterministicUploadId(file) {
    const rawData = file.name + '|' + file.size + '|' + file.lastModified;
    const msgUint8 = new TextEncoder().encode(rawData);
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgUint8);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

async function uploadFileChunked(file, type, progressCallback) {
    const uploadId = await generateDeterministicUploadId(file);
    const totalChunks = Math.ceil(file.size / CHUNK_SIZE);
    
    // 1. Get status (which chunks are already uploaded)
    let uploadedChunks = new Set();
    try {
        const res = await fetch(window.contextPath + `/api/upload?action=status&uploadId=${uploadId}`);
        if (res.ok) {
            const data = await res.json();
            if (data.receivedChunks) {
                uploadedChunks = new Set(data.receivedChunks);
            }
        }
    } catch (e) {
        console.warn("Failed to check status, starting fresh.", e);
    }

    // 2. Prepare chunks to upload
    const pendingChunks = [];
    for (let i = 0; i < totalChunks; i++) {
        if (!uploadedChunks.has(i)) {
            pendingChunks.push(i);
        }
    }

    let completedChunksCount = uploadedChunks.size;
    if (progressCallback) {
        progressCallback(Math.floor((completedChunksCount / totalChunks) * 100));
    }

    // Helper to upload a single chunk with retry
    async function uploadSingleChunk(chunkIndex, attempt = 1) {
        const start = chunkIndex * CHUNK_SIZE;
        const end = Math.min(start + CHUNK_SIZE, file.size);
        const chunk = file.slice(start, end);

        const formData = new FormData();
        formData.append('type', type);
        formData.append('action', 'upload');
        formData.append('uploadId', uploadId);
        formData.append('chunkIndex', chunkIndex);
        formData.append('totalChunks', totalChunks);
        formData.append('fileName', file.name);
        formData.append('file', chunk);

        try {
            const response = await fetch(window.contextPath + '/api/upload', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                throw new Error(`Chunk ${chunkIndex} upload failed with status ${response.status}`);
            }
            
            completedChunksCount++;
            if (progressCallback) {
                progressCallback(Math.floor((completedChunksCount / totalChunks) * 100));
            }
        } catch (err) {
            console.error(err);
            if (attempt < MAX_RETRIES) {
                console.log(`Retrying chunk ${chunkIndex} (attempt ${attempt + 1})...`);
                await new Promise(r => setTimeout(r, 1000 * attempt)); // exponential backoff
                await uploadSingleChunk(chunkIndex, attempt + 1);
            } else {
                throw new Error(`Failed to upload chunk ${chunkIndex} after ${MAX_RETRIES} attempts.`);
            }
        }
    }

    // 3. Upload chunks concurrently
    const activeUploads = new Set();
    let pendingIndex = 0;

    await new Promise((resolve, reject) => {
        if (pendingChunks.length === 0) {
            resolve();
            return;
        }

        function spawn() {
            while (activeUploads.size < MAX_CONCURRENT && pendingIndex < pendingChunks.length) {
                const chunkIndex = pendingChunks[pendingIndex++];
                const p = uploadSingleChunk(chunkIndex)
                    .then(() => {
                        activeUploads.delete(p);
                        if (pendingIndex >= pendingChunks.length && activeUploads.size === 0) {
                            resolve();
                        } else {
                            spawn();
                        }
                    })
                    .catch(err => {
                        reject(err);
                    });
                activeUploads.add(p);
            }
        }
        spawn();
    });

    // 4. Merge
    if (progressCallback) progressCallback(100, "Đang xử lý file...");

    const mergeFormData = new FormData();
    mergeFormData.append('type', type);
    mergeFormData.append('action', 'merge');
    mergeFormData.append('uploadId', uploadId);
    
    const mergeRes = await fetch(window.contextPath + '/api/upload', {
        method: 'POST',
        body: mergeFormData
    });

    const mergeData = await mergeRes.json();
    if (!mergeRes.ok) {
        throw new Error(mergeData.error || 'Failed to merge chunks');
    }

    return mergeData;
}
