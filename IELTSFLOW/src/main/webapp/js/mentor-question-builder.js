document.addEventListener('DOMContentLoaded', function() {
    
    // 1. Re-implement the Add Answer logic
    let answerIndex = parseInt(document.getElementById('answerCount').value);
    
    document.getElementById('btnAddAnswer').addEventListener('click', function() {
        addAnswerRow();
    });

    function addAnswerRow() {
        const container = document.getElementById('answers-container');
        const html = `
            <div class="answer-item glass-panel mb-3 p-3 position-relative" style="background: rgba(255,255,255,0.4);">
                <button type="button" class="btn btn-sm btn-outline-danger position-absolute top-0 end-0 m-2 btn-remove-answer"><i class="fa-solid fa-xmark"></i></button>
                <div class="row g-3">
                    <div class="col-md-8 answer-content-col">
                        <label class="form-label fw-bold">Nội dung đáp án</label>
                        <input type="text" name="answerContent_${answerIndex}" class="form-control answer-content-input" required>
                    </div>
                    <div class="col-md-4 d-flex align-items-end answer-correct-col">
                        <div class="form-check form-switch mb-2">
                            <input class="form-check-input answer-correct-checkbox" type="checkbox" name="answerIsCorrect_${answerIndex}" value="true" id="correct_${answerIndex}">
                            <label class="form-check-label fw-bold text-success" for="correct_${answerIndex}">Là đáp án đúng?</label>
                        </div>
                    </div>
                    <div class="col-md-12 answer-json-col">
                        <label class="form-label fw-bold">Dữ liệu mở rộng đáp án (JSON)</label>
                        <div class="dynamicAnsJsonBuilder mb-2 p-2 bg-light rounded border" data-index="${answerIndex}">
                        </div>
                        <textarea name="answerContentJson_${answerIndex}" id="ansJson_${answerIndex}" class="form-control ansJsonRaw" rows="5" style="display: none;">{}</textarea>
                        <div class="form-check form-switch mt-2">
                            <input class="form-check-input toggleRawAnsJson" type="checkbox" data-index="${answerIndex}" id="toggleRawAnsJson_${answerIndex}">
                            <label class="form-check-label text-muted" style="font-size: 0.85rem;" for="toggleRawAnsJson_${answerIndex}">Mã JSON thô</label>
                        </div>
                    </div>
                </div>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', html);
        
        // Attach events to new elements
        const newItem = container.lastElementChild;
        newItem.querySelector('.btn-remove-answer').addEventListener('click', function() {
            newItem.remove();
            updateAnswerCount();
        });
        newItem.querySelector('.toggleRawAnsJson').addEventListener('change', function() {
            const idx = this.getAttribute('data-index');
            const textarea = document.getElementById('ansJson_' + idx);
            const builder = newItem.querySelector('.dynamicAnsJsonBuilder');
            if (this.checked) {
                textarea.style.display = 'block';
                builder.style.display = 'none';
            } else {
                textarea.style.display = 'none';
                builder.style.display = 'block';
                applyQuestionTypeLogic(); // re-sync from raw
            }
        });
        
        answerIndex++;
        updateAnswerCount();
        
        // Re-apply logic in case we need to build UI for this new row
        applyQuestionTypeLogic();
    }
    
    function updateAnswerCount() {
        document.getElementById('answerCount').value = answerIndex;
    }
    
    // Attach remove event to existing answers
    document.querySelectorAll('.btn-remove-answer').forEach(btn => {
        btn.addEventListener('click', function() {
            btn.closest('.answer-item').remove();
            updateAnswerCount();
        });
    });

    // Toggle Raw View for Content JSON
    document.getElementById('toggleRawContentJson').addEventListener('change', function() {
        const textarea = document.getElementById('contentJson');
        const builder = document.getElementById('dynamicContentJsonBuilder');
        if (this.checked) {
            textarea.style.display = 'block';
            builder.style.display = 'none';
        } else {
            textarea.style.display = 'none';
            builder.style.display = 'block';
            applyQuestionTypeLogic(); // re-sync
        }
    });

    // Toggle Raw View for existing Ans JSONs
    document.querySelectorAll('.toggleRawAnsJson').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const idx = this.getAttribute('data-index');
            const textarea = document.getElementById('ansJson_' + idx);
            const builder = document.querySelector(`.dynamicAnsJsonBuilder[data-index="${idx}"]`);
            if (this.checked) {
                textarea.style.display = 'block';
                builder.style.display = 'none';
            } else {
                textarea.style.display = 'none';
                builder.style.display = 'block';
                applyQuestionTypeLogic();
            }
        });
    });

    // 2. Main Logic to switch UI
    const questionTypeSelect = document.querySelector('select[name=questionType]');
    questionTypeSelect.addEventListener('change', applyQuestionTypeLogic);
    
    function applyQuestionTypeLogic() {
        const qType = questionTypeSelect.value;
        const contentJsonContainer = document.getElementById('dynamicContentJsonBuilder').parentElement;
        const btnAddAnswer = document.getElementById('btnAddAnswer');
        
        // Ensure at least one answer row exists for Matching/FillInBlanks
        if (qType !== 'MultipleChoice') {
            const items = document.querySelectorAll('.answer-item');
            if (items.length === 0) {
                addAnswerRow();
            }
        }
        
        if (qType === 'MultipleChoice') {
            contentJsonContainer.style.display = 'none';
            btnAddAnswer.style.display = 'inline-block';
            
            document.querySelectorAll('.answer-item').forEach(item => {
                item.style.display = 'block';
                item.querySelector('.answer-content-col').style.display = 'block';
                item.querySelector('.answer-correct-col').style.display = 'block';
                item.querySelector('.answer-json-col').style.display = 'none';
                item.querySelector('.btn-remove-answer').style.display = 'block';
            });
        } else if (qType === 'Matching') {
            contentJsonContainer.style.display = 'block';
            btnAddAnswer.style.display = 'none';
            
            buildMatchingContentUI();
            
            document.querySelectorAll('.answer-item').forEach((item, index) => {
                if (index === 0) {
                    item.style.display = 'block';
                    item.querySelector('.answer-content-col').style.display = 'none';
                    item.querySelector('.answer-correct-col').style.display = 'none';
                    item.querySelector('.answer-json-col').style.display = 'block';
                    item.querySelector('.btn-remove-answer').style.display = 'none';
                    
                    item.querySelector('.answer-content-input').value = 'Matching Answer Map';
                    item.querySelector('.answer-correct-checkbox').checked = true;
                    
                    buildMatchingAnswerUI(item);
                } else {
                    item.style.display = 'none';
                }
            });
        } else if (qType === 'FillInBlanks') {
            contentJsonContainer.style.display = 'block';
            btnAddAnswer.style.display = 'none';
            
            buildFillInBlanksContentUI();
            
            document.querySelectorAll('.answer-item').forEach((item, index) => {
                if (index === 0) {
                    item.style.display = 'block';
                    item.querySelector('.answer-content-col').style.display = 'none';
                    item.querySelector('.answer-correct-col').style.display = 'none';
                    item.querySelector('.answer-json-col').style.display = 'block';
                    item.querySelector('.btn-remove-answer').style.display = 'none';
                    
                    item.querySelector('.answer-content-input').value = 'FillInBlanks Answer Map';
                    item.querySelector('.answer-correct-checkbox').checked = true;
                    
                    buildFillInBlanksAnswerUI(item);
                } else {
                    item.style.display = 'none';
                }
            });
        }
    }

    // ==========================================
    // MATCHING UI LOGIC
    // ==========================================
    function getJsonSafely(textareaId) {
        try {
            return JSON.parse(document.getElementById(textareaId).value || '{}');
        } catch(e) {
            return {};
        }
    }

    function buildMatchingContentUI() {
        const builder = document.getElementById('dynamicContentJsonBuilder');
        const data = getJsonSafely('contentJson');
        const leftSide = data.left_side || [];
        const rightSide = data.right_side || [];
        
        let html = `
            <div class="row">
                <div class="col-md-6 border-end">
                    <h6 class="fw-bold text-primary">Bên Trái (Vế Cố Định)</h6>
                    <div id="matchingLeftContainer"></div>
                    <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addMatchingItem('left')"><i class="fa-solid fa-plus"></i> Thêm mục</button>
                </div>
                <div class="col-md-6">
                    <h6 class="fw-bold text-success">Bên Phải (Vế Cần Nối)</h6>
                    <div id="matchingRightContainer"></div>
                    <button type="button" class="btn btn-sm btn-outline-success mt-2" onclick="addMatchingItem('right')"><i class="fa-solid fa-plus"></i> Thêm mục</button>
                </div>
            </div>
        `;
        builder.innerHTML = html;
        
        leftSide.forEach(item => appendMatchingItemRow('left', item.id, item.text));
        rightSide.forEach(item => appendMatchingItemRow('right', item.id, item.text));
        
        // Initialize Sortable for Matching Left
        new Sortable(document.getElementById('matchingLeftContainer'), {
            handle: '.drag-handle',
            animation: 150,
            onEnd: function() { syncMatchingContent(); }
        });
        
        // Initialize Sortable for Matching Right
        new Sortable(document.getElementById('matchingRightContainer'), {
            handle: '.drag-handle',
            animation: 150,
            onEnd: function() { syncMatchingContent(); }
        });
        
        // Expose global functions for onclick
        window.addMatchingItem = function(side) {
            appendMatchingItemRow(side, '', '');
            syncMatchingContent();
        };
        window.removeMatchingItem = function(btn) {
            btn.closest('.matching-item-row').remove();
            syncMatchingContent();
        };
        window.syncMatchingContent = function() {
            const res = { left_side: [], right_side: [] };
            document.querySelectorAll('#matchingLeftContainer .matching-item-row').forEach(row => {
                res.left_side.push({
                    id: row.querySelector('.item-id').value.trim(),
                    text: row.querySelector('.item-text').value.trim()
                });
            });
            document.querySelectorAll('#matchingRightContainer .matching-item-row').forEach(row => {
                res.right_side.push({
                    id: row.querySelector('.item-id').value.trim(),
                    text: row.querySelector('.item-text').value.trim()
                });
            });
            document.getElementById('contentJson').value = JSON.stringify(res, null, 2);
            // Re-render answer UI to update dropdowns
            const answerItem = document.querySelector('.answer-item');
            if(answerItem && answerItem.style.display !== 'none') {
                 buildMatchingAnswerUI(answerItem, true); // preserve answers if possible
            }
        };
    }
    
    function appendMatchingItemRow(side, id, text) {
        const container = side === 'left' ? document.getElementById('matchingLeftContainer') : document.getElementById('matchingRightContainer');
        const row = document.createElement('div');
        row.className = 'row g-1 mb-2 matching-item-row align-items-center';
        row.innerHTML = `
            <div class="col-auto d-flex align-items-center">
                <i class="fa-solid fa-bars text-muted drag-handle px-2" style="cursor: grab;"></i>
            </div>
            <div class="col-3">
                <input type="text" class="form-control form-control-sm item-id" placeholder="ID (vd: 1, a)" value="${id.replace(/"/g, '&quot;')}" onchange="syncMatchingContent()">
            </div>
            <div class="col-7">
                <input type="text" class="form-control form-control-sm item-text" placeholder="Nội dung" value="${text.replace(/"/g, '&quot;')}" onchange="syncMatchingContent()">
            </div>
            <div class="col-1 text-end">
                <button type="button" class="btn btn-sm btn-outline-danger p-1" onclick="removeMatchingItem(this)"><i class="fa-solid fa-trash"></i></button>
            </div>
        `;
        container.appendChild(row);
    }

    function buildMatchingAnswerUI(answerItem, preserveData = false) {
        const builder = answerItem.querySelector('.dynamicAnsJsonBuilder');
        const textarea = answerItem.querySelector('.ansJsonRaw');
        let data = {};
        try { data = JSON.parse(textarea.value || '{}'); } catch(e) {}
        
        // Fetch current left/right from contentJson
        const contentData = getJsonSafely('contentJson');
        const leftSide = contentData.left_side || [];
        const rightSide = contentData.right_side || [];
        
        let html = `<h6 class="fw-bold">Nối Đáp Án</h6>`;
        if (leftSide.length === 0) {
            html += `<p class="text-muted small">Vui lòng thêm các mục "Bên Trái" và "Bên Phải" ở phần câu hỏi trước.</p>`;
        } else {
            html += `<div class="matching-answer-rows">`;
            leftSide.forEach(leftItem => {
                const selectedRightId = data[leftItem.id] || '';
                html += `
                    <div class="row g-2 mb-2 align-items-center matching-ans-row">
                        <div class="col-5">
                            <input type="hidden" class="left-id" value="${leftItem.id.replace(/"/g, '&quot;')}">
                            <span class="badge bg-primary">ID: ${leftItem.id}</span> ${leftItem.text}
                        </div>
                        <div class="col-2 text-center text-muted"><i class="fa-solid fa-arrow-right"></i></div>
                        <div class="col-5">
                            <select class="form-select form-select-sm right-id" onchange="syncMatchingAnswer('${textarea.id}', this)">
                                <option value="">-- Chọn đáp án đúng --</option>
                                ${rightSide.map(r => `<option value="${r.id.replace(/"/g, '&quot;')}" ${selectedRightId == r.id ? 'selected' : ''}>[ID: ${r.id}] ${r.text}</option>`).join('')}
                            </select>
                        </div>
                    </div>
                `;
            });
            html += `</div>`;
        }
        builder.innerHTML = html;
        
        window.syncMatchingAnswer = function(targetId, el) {
            const container = el.closest('.dynamicAnsJsonBuilder');
            const res = {};
            container.querySelectorAll('.matching-ans-row').forEach(row => {
                const lid = row.querySelector('.left-id').value;
                const rid = row.querySelector('.right-id').value;
                if(lid && rid) {
                    res[lid] = rid;
                }
            });
            document.getElementById(targetId).value = JSON.stringify(res, null, 2);
        };
    }

    // ==========================================
    // FILL IN BLANKS UI LOGIC
    // ==========================================
    function buildFillInBlanksContentUI() {
        const builder = document.getElementById('dynamicContentJsonBuilder');
        const data = getJsonSafely('contentJson');
        const blanks = data.blanks || {};
        
        let html = `
            <h6 class="fw-bold text-primary">Danh Sách Ô Trống (Blanks)</h6>
            <div id="blanksContainer"></div>
            <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addBlankItem()"><i class="fa-solid fa-plus"></i> Thêm ô trống</button>
        `;
        builder.innerHTML = html;
        
        for (const [id, config] of Object.entries(blanks)) {
            appendBlankRow(id, config);
        }
        
        // Initialize Sortable for Blanks
        new Sortable(document.getElementById('blanksContainer'), {
            handle: '.drag-handle',
            animation: 150,
            onEnd: function() {
                const rows = document.querySelectorAll('#blanksContainer .blank-row');
                const newIdMap = {};
                
                rows.forEach((row, index) => {
                    const idInput = row.querySelector('.blank-id');
                    const oldId = idInput.dataset.oldId || idInput.value;
                    const newId = String(index + 1);
                    
                    idInput.value = newId;
                    idInput.dataset.oldId = newId;
                    newIdMap[oldId] = newId;
                });
                
                syncBlanksContent();
                
                // Remap answer JSON safely
                const answerItem = document.querySelector('.answer-item');
                if (answerItem && answerItem.style.display !== 'none') {
                    const textarea = answerItem.querySelector('.ansJsonRaw');
                    let oldAns = {};
                    try { oldAns = JSON.parse(textarea.value || '{}'); } catch(e) {}
                    
                    let newAns = {};
                    for (const [oldId, ansArr] of Object.entries(oldAns)) {
                        if (newIdMap[oldId]) {
                            newAns[newIdMap[oldId]] = ansArr;
                        }
                    }
                    textarea.value = JSON.stringify(newAns, null, 2);
                    buildFillInBlanksAnswerUI(answerItem);
                }
            }
        });
        
        window.addBlankItem = function() {
            // Find next ID
            const currentRows = document.querySelectorAll('#blanksContainer .blank-row .blank-id');
            let maxId = 0;
            currentRows.forEach(input => {
                const val = parseInt(input.value);
                if (!isNaN(val) && val > maxId) maxId = val;
            });
            appendBlankRow(String(maxId + 1), { type: 'text', placeholder: '' });
            syncBlanksContent();
        };
        
        window.removeBlankItem = function(btn) {
            btn.closest('.blank-row').remove();
            syncBlanksContent();
        };
        
        window.toggleBlankType = function(sel) {
            const row = sel.closest('.blank-row');
            if (sel.value === 'text') {
                row.querySelector('.blank-placeholder-container').style.display = 'block';
                row.querySelector('.blank-options-container').style.display = 'none';
            } else {
                row.querySelector('.blank-placeholder-container').style.display = 'none';
                row.querySelector('.blank-options-container').style.display = 'block';
                // Add at least one empty option if there are none
                if (row.querySelectorAll('.blank-option-input').length === 0) {
                    addBlankOption(row.querySelector('.blank-options-container button'));
                }
            }
            syncBlanksContent();
        };
        
        window.syncBlanksContent = function() {
            const res = { blanks: {} };
            document.querySelectorAll('#blanksContainer .blank-row').forEach(row => {
                const id = row.querySelector('.blank-id').value.trim();
                const type = row.querySelector('.blank-type').value;
                if (!id) return;
                
                if (type === 'text') {
                    res.blanks[id] = {
                        type: 'text',
                        placeholder: row.querySelector('.blank-placeholder').value.trim()
                    };
                } else {
                    const opts = [];
                    row.querySelectorAll('.blank-option-input').forEach(inp => {
                        const val = inp.value.trim();
                        if (val) opts.push(val);
                    });
                    res.blanks[id] = {
                        type: 'dropdown',
                        options: opts
                    };
                }
            });
            document.getElementById('contentJson').value = JSON.stringify(res, null, 2);
            
            const answerItem = document.querySelector('.answer-item');
            if(answerItem && answerItem.style.display !== 'none') {
                 buildFillInBlanksAnswerUI(answerItem);
            }
        };
        
        window.addBlankOption = function(btn) {
            const list = btn.previousElementSibling;
            const row = document.createElement('div');
            row.className = 'd-flex mb-1 gap-1 option-row';
            const inp = document.createElement('input');
            inp.type = 'text';
            inp.className = 'form-control form-control-sm blank-option-input';
            inp.placeholder = 'Option...';
            inp.style.cssText = 'width: 90px; min-width: 70px; max-width: 400px; box-sizing: content-box;';
            inp.addEventListener('input', function() { autoFitInput(this); });
            inp.addEventListener('change', syncBlanksContent);
            const delBtn = document.createElement('button');
            delBtn.type = 'button';
            delBtn.className = 'btn btn-sm btn-outline-danger';
            delBtn.tabIndex = -1;
            delBtn.innerHTML = '<i class="fa-solid fa-times"></i>';
            delBtn.onclick = function() { removeBlankOption(this); };
            row.appendChild(inp);
            row.appendChild(delBtn);
            list.appendChild(row);
            syncBlanksContent();
        };
        
        window.removeBlankOption = function(btn) {
            btn.closest('.option-row').remove();
            syncBlanksContent();
        };
    }
    
    function appendBlankRow(id, config) {
        const container = document.getElementById('blanksContainer');
        const row = document.createElement('div');
        row.className = 'row g-2 mb-2 blank-row align-items-center p-2 border rounded bg-white';
        
        const isText = config.type !== 'dropdown';
        const placeholder = config.placeholder || '';
        const optionsArr = config.options || [];
        
        row.innerHTML = `
            <div class="col-auto d-flex align-items-center">
                <i class="fa-solid fa-bars text-muted drag-handle px-2" style="cursor: grab;"></i>
            </div>
            <div class="col-md-1 d-flex flex-column align-items-center justify-content-center">
                <label class="small text-muted mb-1">ID</label>
                <input type="text" class="form-control form-control-sm blank-id text-center fw-bold text-primary bg-light" value="${id.replace(/"/g, '&quot;')}" data-old-id="${id.replace(/"/g, '&quot;')}" style="width: 60px; min-width: 40px;" readonly>
            </div>
            <div class="col-md-3">
                <label class="small text-muted">Loại (Type)</label>
                <select class="form-select form-select-sm blank-type w-auto" onchange="toggleBlankType(this)">
                    <option value="text" ${isText ? 'selected' : ''}>Text Input</option>
                    <option value="dropdown" ${!isText ? 'selected' : ''}>Dropdown</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="small text-muted">Cấu hình</label>
                <div class="blank-placeholder-container" style="display: ${isText ? 'block' : 'none'};">
                    <input type="text" class="form-control form-control-sm blank-placeholder" placeholder="Placeholder (gợi ý nhập)" value="${placeholder.replace(/"/g, '&quot;')}" style="width: 220px; min-width: 120px; max-width: 400px;" oninput="autoFitInput(this)" onchange="syncBlanksContent()">
                </div>
                <div class="blank-options-container" style="display: ${!isText ? 'block' : 'none'};">
                    <div class="options-list">
                        ${optionsArr.map(o => `
                            <div class="d-flex mb-1 gap-1 option-row">
                                <input type="text" class="form-control form-control-sm blank-option-input" value="${o.replace(/"/g, '&quot;')}" style="width: ${Math.max(o.length * 9 + 20, 80)}px; min-width: 70px; max-width: 400px;" oninput="autoFitInput(this)" onchange="syncBlanksContent()">
                                <button type="button" class="btn btn-sm btn-outline-danger" tabindex="-1" onclick="removeBlankOption(this)"><i class="fa-solid fa-times"></i></button>
                            </div>
                        `).join('')}
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-secondary py-0 mt-1" style="font-size: 12px;" onclick="addBlankOption(this)"><i class="fa-solid fa-plus"></i> Thêm option</button>
                </div>
            </div>
            <div class="col-md-1 text-end mt-4">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeBlankItem(this)"><i class="fa-solid fa-trash"></i></button>
            </div>
        `;
        container.appendChild(row);
    }
    
    function buildFillInBlanksAnswerUI(answerItem) {
        const builder = answerItem.querySelector('.dynamicAnsJsonBuilder');
        const textarea = answerItem.querySelector('.ansJsonRaw');
        let data = {};
        try { data = JSON.parse(textarea.value || '{}'); } catch(e) {}
        
        const contentData = getJsonSafely('contentJson');
        const blanks = contentData.blanks || {};
        
        let html = `<h6 class="fw-bold">Thiết Lập Đáp Án</h6>`;
        if (Object.keys(blanks).length === 0) {
            html += `<p class="text-muted small">Vui lòng thêm các ô trống ở phần câu hỏi trước.</p>`;
        } else {
            html += `<div class="blanks-answer-rows">`;
            for (const id of Object.keys(blanks)) {
                const config = blanks[id];
                let ansArray = data[id] || [];
                if (!Array.isArray(ansArray)) ansArray = [ansArray];
                
                let answerInputHtml = '';
                if (config.type === 'dropdown') {
                    const opts = config.options || [];
                    const selectedOpt = ansArray[0] || '';
                    answerInputHtml = `
                        <select class="form-select form-select-sm blank-answers-input" onchange="syncBlanksAnswer('${textarea.id}', this)">
                            <option value="">-- Chọn đáp án đúng --</option>
                            ${opts.map(o => `<option value="${o.replace(/"/g, '&quot;')}" ${o === selectedOpt ? 'selected' : ''}>${o}</option>`).join('')}
                        </select>
                    `;
                } else {
                    const ansStr = ansArray.join(', ');
                    answerInputHtml = `<input type="text" class="form-control form-control-sm blank-answers-input" placeholder="Nhập các đáp án đúng, phân cách bằng dấu phẩy (,)" value="${ansStr.replace(/"/g, '&quot;')}" onchange="syncBlanksAnswer('${textarea.id}', this)">`;
                }
                
                html += `
                    <div class="row g-2 mb-2 align-items-center blanks-ans-row">
                        <div class="col-2">
                            <input type="hidden" class="blank-id" value="${id.replace(/"/g, '&quot;')}">
                            <span class="badge bg-primary">Ô ${id}</span>
                        </div>
                        <div class="col-10">
                            ${answerInputHtml}
                        </div>
                    </div>
                `;
            }
            html += `</div>`;
        }
        builder.innerHTML = html;
        
        window.syncBlanksAnswer = function(targetId, el) {
            const container = el.closest('.dynamicAnsJsonBuilder');
            const res = {};
            container.querySelectorAll('.blanks-ans-row').forEach(row => {
                const bid = row.querySelector('.blank-id').value;
                const ansInputEl = row.querySelector('.blank-answers-input');
                const ansInput = ansInputEl.value;
                if(bid && ansInput) {
                    if (ansInputEl.tagName === 'SELECT') {
                        res[bid] = [ansInput];
                    } else {
                        res[bid] = ansInput.split(',').map(s => s.trim()).filter(s => s);
                    }
                }
            });
            document.getElementById(targetId).value = JSON.stringify(res, null, 2);
        };
    }

    // Trigger initial logic
    applyQuestionTypeLogic();
});

// ==========================================
// PREVIEW LOGIC
// ==========================================
window.showPreviewModal = function() {
    const qType = document.querySelector('select[name=questionType]').value;
    const content = document.querySelector('textarea[name=content]').value;
    const container = document.getElementById('previewContainer');
    
    let resourceId = document.getElementById('resourceId').value;
    let resourceTextHtml = '';
    if (resourceId) {
        let resDiv = document.getElementById('res_text_' + resourceId);
        if (resDiv) {
            resourceTextHtml = `<div class="resource-panel mb-4 p-3 border rounded bg-white shadow-sm" style="max-height: 300px; overflow-y: auto;">` + resDiv.innerHTML + `</div>`;
        }
    }
    
    let html = resourceTextHtml + `<div class="q-content mb-4">${content.replace(/\n/g, '<br>')}</div>`;
    
    if (qType === 'MultipleChoice') {
        html += `<div class="choices d-flex flex-column gap-2">`;
        document.querySelectorAll('.answer-item').forEach((item, i) => {
            if (item.style.display !== 'none') {
                const text = item.querySelector('.answer-content-input').value;
                html += `
                    <label class="choice border p-2 rounded d-flex align-items-center gap-2" style="cursor: pointer;">
                        <input type="radio" name="preview_mc">
                        <span class="choice-text">${text}</span>
                    </label>
                `;
            }
        });
        html += `</div>`;
    } else if (qType === 'Matching') {
        const dataStr = document.getElementById('contentJson').value;
        let data = {};
        try { data = JSON.parse(dataStr || '{}'); } catch(e) {}
        const leftSide = data.left_side || [];
        const rightSide = data.right_side || [];
        
        html += `<div class="matching-preview row">`;
        html += `<div class="col-md-8">`;
        leftSide.forEach(item => {
            html += `
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-secondary">${item.id}</span>
                    <span>${item.text}</span>
                    <select class="form-select form-select-sm" style="width: auto;">
                        <option value="">-- Chọn --</option>
                        ${rightSide.map(r => `<option value="${r.id}">${r.id}</option>`).join('')}
                    </select>
                </div>
            `;
        });
        html += `</div>`;
        html += `<div class="col-md-4 border-start">`;
        html += `<h6 class="fw-bold">Lựa chọn:</h6>`;
        html += `<ul class="list-unstyled">`;
        rightSide.forEach(r => {
            html += `<li class="mb-1"><span class="badge bg-light text-dark border">${r.id}</span> ${r.text}</li>`;
        });
        html += `</ul>`;
        html += `</div>`;
        html += `</div>`;
    } else if (qType === 'FillInBlanks') {
        const dataStr = document.getElementById('contentJson').value;
        let data = {};
        try { data = JSON.parse(dataStr || '{}'); } catch(e) {}
        const blanks = data.blanks || {};
        
        // Build preview by replacing (ID) in content with actual inputs
        let previewContentHtml = content.replace(/\n/g, '<br>');
        let previewResourceHtml = resourceTextHtml; // Make a copy we can modify
        let warnings = [];
        
        for (const [id, config] of Object.entries(blanks)) {
            let blankHtml = '';
            if (config.type === 'text') {
                blankHtml = `<input type="text" data-blank-id="${id}" class="form-control form-control-sm d-inline-block mx-1 preview-auto-fit" placeholder="${config.placeholder || ''}" style="width: 100px; min-width: 60px;" oninput="autoFitInput(this)">`;
            } else {
                const opts = config.options || [];
                blankHtml = `<select data-blank-id="${id}" class="form-select form-select-sm d-inline-block w-auto mx-1">`;
                blankHtml += `<option value="">-- Chọn --</option>`;
                opts.forEach(o => {
                    blankHtml += `<option value="${o}">${o}</option>`;
                });
                blankHtml += `</select>`;
            }
            
            // Safe replace logic for exactly (id)
            const regex = new RegExp(`\\(${id}\\)`, 'g');
            
            let foundInText = false;
            if (previewContentHtml.match(regex)) {
                previewContentHtml = previewContentHtml.replace(regex, blankHtml);
                foundInText = true;
            }
            if (previewResourceHtml && previewResourceHtml.match(regex)) {
                previewResourceHtml = previewResourceHtml.replace(regex, blankHtml);
                foundInText = true;
            }
            
            if (!foundInText) {
                // If not found in text, emit a warning
                warnings.push(`Cảnh báo: Không tìm thấy đánh dấu <strong>(${id})</strong> trong bài đọc hoặc nội dung câu hỏi!`);
            }
        }
        
        let warningHtml = '';
        if (warnings.length > 0) {
            warningHtml = warnings.map(w => `<div class="alert alert-warning py-2 mb-2"><i class="fa-solid fa-triangle-exclamation"></i> ${w}</div>`).join('');
        }
        
        html = warningHtml + previewResourceHtml + `<div class="q-content mb-4">${previewContentHtml}</div>`;
    }
    
    container.innerHTML = html;
    
    // Auto-fit preview inputs
    container.querySelectorAll('.preview-auto-fit').forEach(inp => autoFitInput(inp));
    
    const modal = new bootstrap.Modal(document.getElementById('previewModal'));
    modal.show();
};

window.checkPreviewAnswers = function() {
    const qType = document.querySelector('select[name=questionType]').value;
    const container = document.getElementById('previewContainer');
    let allCorrect = true;
    let checkedAtLeastOne = false;

    if (qType === 'MultipleChoice') {
        const radios = container.querySelectorAll('input[type="radio"]');
        let selectedIndex = -1;
        radios.forEach((r, i) => { if (r.checked) selectedIndex = i; });
        
        if (selectedIndex === -1) {
            Swal.fire('Chưa trả lời', 'Vui lòng chọn một đáp án!', 'warning');
            return;
        }
        
        let correctIndex = -1;
        let count = 0;
        document.querySelectorAll('.answer-item').forEach(item => {
            if (item.style.display !== 'none') {
                if (item.querySelector('.answer-correct-checkbox').checked) correctIndex = count;
                count++;
            }
        });
        
        if (selectedIndex === correctIndex) {
            Swal.fire('Chính xác!', 'Bạn đã chọn đúng đáp án.', 'success');
        } else {
            Swal.fire('Sai rồi!', 'Đáp án chưa chính xác.', 'error');
        }
    } else if (qType === 'Matching') {
        const selects = container.querySelectorAll('.matching-preview select');
        if (selects.length === 0) return;
        
        const ansJsonTextarea = document.querySelector('.answer-item .ansJsonRaw');
        let correctMapping = {};
        try { correctMapping = JSON.parse(ansJsonTextarea.value || '{}'); } catch(e) {}
        
        let correctCount = 0;
        selects.forEach(sel => {
            const leftId = sel.closest('div').querySelector('.badge').innerText;
            const rightId = sel.value;
            if (rightId && correctMapping[leftId] == rightId) {
                correctCount++;
                sel.style.borderColor = 'green';
                sel.style.backgroundColor = '#e8f5e9';
            } else {
                allCorrect = false;
                if (rightId) {
                    sel.style.borderColor = 'red';
                    sel.style.backgroundColor = '#ffebee';
                }
            }
            if (rightId) checkedAtLeastOne = true;
        });
        
        if (!checkedAtLeastOne) {
            Swal.fire('Chưa trả lời', 'Vui lòng nối ít nhất 1 đáp án.', 'warning');
            return;
        }
        
        if (allCorrect) {
            Swal.fire('Chính xác!', 'Bạn đã nối đúng tất cả!', 'success');
        } else {
            Swal.fire('Chưa chính xác!', `Bạn đã đúng ${correctCount}/${selects.length} mục.`, 'error');
        }
    } else if (qType === 'FillInBlanks') {
        const inputs = container.querySelectorAll('input.preview-auto-fit, select.form-select');
        if (inputs.length === 0) return;
        
        const ansJsonTextarea = document.querySelector('.answer-item .ansJsonRaw');
        let correctAnswers = {};
        try { correctAnswers = JSON.parse(ansJsonTextarea.value || '{}'); } catch(e) {}
        
        let correctCount = 0;
        inputs.forEach(inp => {
            const val = inp.value.trim().toLowerCase();
            const id = inp.getAttribute('data-blank-id');
            if (val) checkedAtLeastOne = true;
            
            let isCorrect = false;
            let validOpts = correctAnswers[id] || [];
            if (!Array.isArray(validOpts)) validOpts = [validOpts];
            
            validOpts = validOpts.map(v => String(v).trim().toLowerCase());
            
            if (val && validOpts.includes(val)) {
                isCorrect = true;
                correctCount++;
            }
            
            if (isCorrect) {
                inp.style.borderColor = 'green';
                inp.style.backgroundColor = '#e8f5e9';
            } else if (val) {
                inp.style.borderColor = 'red';
                inp.style.backgroundColor = '#ffebee';
                allCorrect = false;
            } else {
                allCorrect = false;
            }
        });
        
        if (!checkedAtLeastOne) {
            Swal.fire('Chưa trả lời', 'Vui lòng điền ít nhất 1 ô trống.', 'warning');
            return;
        }
        
        if (allCorrect) {
            Swal.fire('Chính xác!', 'Bạn đã điền đúng tất cả!', 'success');
        } else {
            Swal.fire('Chưa chính xác!', `Bạn đã đúng ${correctCount}/${inputs.length} mục.`, 'error');
        }
    }
};

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

document.addEventListener('DOMContentLoaded', function() {
    // Auto-fit already-rendered inputs on load
    document.querySelectorAll('.blank-option-input, .blank-placeholder').forEach(function(inp) {
        autoFitInput(inp);
    });
});

// Measure text width accurately with canvas, then set input width
function autoFitInput(inp) {
    const canvas = autoFitInput._canvas || (autoFitInput._canvas = document.createElement('canvas'));
    const ctx = canvas.getContext('2d');
    const style = window.getComputedStyle(inp);
    ctx.font = style.fontSize + ' ' + style.fontFamily;
    const text = inp.value || inp.placeholder || '';
    const measured = ctx.measureText(text).width;
    const newWidth = Math.max(measured + 24, 70); // 24px padding, 70px min
    inp.style.width = Math.min(newWidth, 400) + 'px';
}

