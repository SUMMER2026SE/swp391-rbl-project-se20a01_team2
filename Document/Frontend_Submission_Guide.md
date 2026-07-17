# Hướng Dẫn Frontend Submit Đáp Án (Hệ thống IELTS)

Tài liệu này hướng dẫn cách Frontend cấu trúc HTML Form (hoặc JavaScript FormData) để gửi đáp án của người dùng lên Backend, đặc biệt là với các câu hỏi có **nhiều đáp án** (như "Fill in the Blanks" có nhiều ô trống, hoặc "Multiple Choice" yêu cầu chọn nhiều phương án).

---

## 1. Cơ chế hoạt động của Backend

Backend hiện tại đã được nâng cấp để hỗ trợ chấm điểm nhiều đáp án cho một `QuestionID`. 
- Backend có thể nhận 1 đáp án đơn lẻ (Ví dụ: `apple`).
- Backend cũng có thể nhận 1 mảng JSON chứa nhiều đáp án (Ví dụ: `["apple", "banana", "orange"]`).
- Nếu nhận được nhiều giá trị có cùng một khoá (key) từ phía Frontend, Backend sẽ **tự động gộp chúng lại** thành một mảng JSON để chấm điểm.

---

## 2. Cách thiết kế Form trên Frontend

Frontend có thể thực hiện theo **1 trong 2 cách** dưới đây. Cả 2 cách đều tương thích 100% với Backend hiện tại.

### Cách 1: Gửi trùng `name` (Khuyên dùng - Đơn giản nhất)
Bạn không cần dùng JS để ghép mảng. Bạn chỉ cần đặt thuộc tính `name` của tất cả các ô input/select thuộc về cùng 1 câu hỏi giống hệt nhau theo format `name="q_{questionId}"`.

**Ví dụ với Fill in the Blanks (3 ô trống cho câu hỏi ID 15):**
```html
<p>
  I like to eat <input type="text" name="q_15"> and <input type="text" name="q_15">. 
  But I hate <input type="text" name="q_15">.
</p>
```
Khi form submit, trình duyệt sẽ tự động gom các value này và gửi lên thành danh sách. Backend sẽ tự động dùng hàm `req.getParameterValues("q_15")` và gộp chúng thành mảng JSON `["apple", "banana", "orange"]` trước khi chấm điểm.

**Ví dụ với Multiple Choice nhiều đáp án (chọn 2 đáp án cho câu hỏi ID 22):**
```html
<p>Chọn 2 màu bạn thích:</p>
<input type="checkbox" name="q_22" value="234"> Đỏ <br>
<input type="checkbox" name="q_22" value="235"> Xanh <br>
<input type="checkbox" name="q_22" value="236"> Vàng <br>
<input type="checkbox" name="q_22" value="237"> Đen <br>
```
*(Với Multiple Choice, `value` được gửi lên là `AnswerID` của phương án. Tương tự, Backend tự động gom các ID được check thành mảng).*

---

### Cách 2: Tự tạo JSON Array bằng JavaScript (Thích hợp cho SPA / React / Vue)

Nếu Frontend của bạn xử lý toàn bộ bằng JavaScript và gọi API thông qua `fetch` hoặc `axios`, bạn có thể chủ động gom các đáp án vào một mảng, biến nó thành chuỗi JSON và gửi lên.

**Quy trình:**
1. Khi người dùng nhập liệu, gom các đáp án của cùng 1 câu hỏi vào 1 mảng: `let answers = ["apple", "banana", "orange"];`
2. Chuyển mảng đó thành chuỗi JSON: `let jsonString = JSON.stringify(answers);` // Kết quả: `'["apple","banana","orange"]'`
3. Gửi chuỗi này lên Backend với key là `q_{questionId}`.

**Ví dụ đính kèm vào Form ẩn trước khi Submit:**
```javascript
let question15Answers = ["apple", "banana", "orange"];
let hiddenInput = document.createElement("input");
hiddenInput.type = "hidden";
hiddenInput.name = "q_15";
hiddenInput.value = JSON.stringify(question15Answers); 
form.appendChild(hiddenInput);
form.submit();
```

---

## 3. Lưu ý quan trọng
- **Thứ tự đáp án (với Fill in the Blanks):** Backend hiện tại đang kiểm tra từng đáp án trong mảng của Frontend so khớp với danh sách các phương án đúng. Nếu bài tập có thứ tự các ô cố định, bạn cần đảm bảo các thẻ `<input>` được render theo đúng thứ tự từ trên xuống dưới, trái qua phải để mảng JSON được hình thành theo đúng trật tự.
- **Câu hỏi thông thường (1 đáp án):** Cứ render `<input type="radio" name="q_10" value="45">` bình thường. Backend tự biết đây là đáp án đơn và xử lý chính xác, không cần mảng.
