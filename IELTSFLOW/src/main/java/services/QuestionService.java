package services;

import dao.QuestionDAO;
import model.Answer;
import model.Question;
import java.util.List;
import dao.TagDAO;
import model.Tag;

public class QuestionService {

    private final QuestionDAO questionDAO = new QuestionDAO();

    public List<Question> getAllQuestions() {
        return questionDAO.findAll();
    }

    public List<Question> getQuestionsByMentor(int mentorId) {
        return questionDAO.findByMentor(mentorId);
    }

    public Question getQuestionById(int id) {
        return questionDAO.findById(id);
    }

    public List<Question> searchQuestions(String keyword, String skill) {
        return questionDAO.searchByKeywordAndSkill(keyword, skill);
    }

    public void createQuestion(Question question, List<Answer> answers) throws Exception {
        validate(question);
        if (answers == null || answers.isEmpty())
            throw new Exception("Câu hỏi phải có ít nhất một đáp án");
        question.setAnswers(answers);
        question.setDeleted(false);
        questionDAO.save(question);
    }

    public void updateQuestion(Question question, List<Answer> answers) throws Exception {
        Question existing = questionDAO.findById(question.getQuestionId());
        if (existing == null)
            throw new Exception("Không tìm thấy câu hỏi #" + question.getQuestionId());
        validate(question);
        if (answers == null || answers.isEmpty())
            throw new Exception("Câu hỏi phải có ít nhất một đáp án");

        existing.setContent(question.getContent());
        existing.setQuestionType(question.getQuestionType());
        existing.setSkill(question.getSkill());
        existing.setDifficulty(question.getDifficulty());
        existing.setExplanation(question.getExplanation());
        existing.setOrderInResource(question.getOrderInResource());
        existing.setContentJson(question.getContentJson());
        existing.setResourceId(question.getResourceId());
        existing.getAnswers().clear();
        existing.getAnswers().addAll(answers);
        questionDAO.update(existing);
    }

    public void deleteQuestion(int id, int mentorId) throws Exception {
        Question existing = questionDAO.findById(id);
        if (existing == null)
            throw new Exception("Không tìm thấy câu hỏi #" + id);
        if (!existing.getCreatedBy().equals(mentorId))
            throw new Exception("Bạn không có quyền xóa câu hỏi này");
        questionDAO.softDelete(id);
    }

    private void validate(Question q) throws Exception {
        if (q.getContent() == null || q.getContent().isBlank())
            throw new Exception("Nội dung câu hỏi không được để trống");
        if (q.getQuestionType() == null || q.getQuestionType().isBlank())
            throw new Exception("Loại câu hỏi không được để trống");
        if (q.getSkill() == null || q.getSkill().isBlank())
            throw new Exception("Kỹ năng không được để trống");
        if (q.getContentJson() == null || q.getContentJson().isBlank())
            q.setContentJson("{}");
    }

    private final TagDAO tagDAO = new TagDAO();

    public Question getQuestionWithTags(int id) throws Exception {
        Question q = questionDAO.findByIdWithTags(id);
        if (q == null) throw new Exception("Không tìm thấy câu hỏi #" + id);
        return q;
    }

    public List<Tag> getAllTags() {
        return tagDAO.findAll();
    }

    public void addTagToQuestion(int questionId, int tagId, int mentorId) throws Exception {
        Question q = questionDAO.findById(questionId);
        if (q == null) throw new Exception("Không tìm thấy câu hỏi #" + questionId);
        if (!q.getCreatedBy().equals(mentorId))
            throw new Exception("Bạn không có quyền gắn tag cho câu hỏi này");
        if (tagDAO.findById(tagId) == null)
            throw new Exception("Không tìm thấy tag #" + tagId);
        questionDAO.addTag(questionId, tagId);
    }

    public void removeTagFromQuestion(int questionId, int tagId, int mentorId) throws Exception {
        Question q = questionDAO.findById(questionId);
        if (q == null) throw new Exception("Không tìm thấy câu hỏi #" + questionId);
        if (!q.getCreatedBy().equals(mentorId))
            throw new Exception("Bạn không có quyền xóa tag của câu hỏi này");
        questionDAO.removeTag(questionId, tagId);
    }
}
