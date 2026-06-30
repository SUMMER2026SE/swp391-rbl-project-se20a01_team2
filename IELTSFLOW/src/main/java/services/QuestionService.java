package services;

import dao.QuestionDAO;
import model.Answer;
import model.Question;
import java.util.List;
import util.PaginatedList;
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

    public List<Question> getQuestionsBySkill(String skill) {
        return questionDAO.findBySkill(skill);
    }

    public List<Question> searchQuestions(String keyword, String skill) {
        return questionDAO.searchByKeywordAndSkill(keyword, skill);
    }

    public List<Question> searchQuestions(String keyword, String skill, Integer resourceId) {
        return questionDAO.searchByKeywordSkillAndResource(keyword, skill, resourceId);
    }

    public PaginatedList<Question> searchQuestions(String keyword, String skill, String difficulty, String type, int page, int pageSize) {
        return questionDAO.searchQuestions(keyword, skill, difficulty, type, page, pageSize);
    }

    public void createQuestion(Question question, List<Answer> answers, List<Integer> tagIds) throws Exception {
        validate(question);
        if (answers == null || answers.isEmpty())
            throw new Exception("Câu hỏi phải có ít nhất một đáp án");
        question.setAnswers(answers);
        question.setDeleted(false);
        questionDAO.save(question);
        if (tagIds != null && !tagIds.isEmpty()) {
            for (Integer tagId : tagIds) {
                questionDAO.addTag(question.getQuestionId(), tagId);
            }
        }
    }

    public void updateQuestion(Question question, List<Answer> answers, List<Integer> tagIds) throws Exception {
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

        // Update tags
        questionDAO.removeAllTags(existing.getQuestionId());
        if (tagIds != null && !tagIds.isEmpty()) {
            for (Integer tagId : tagIds) {
                questionDAO.addTag(existing.getQuestionId(), tagId);
            }
        }
    }

    public void deleteQuestion(int id) throws Exception {
        Question existing = questionDAO.findById(id);
        if (existing == null)
            throw new Exception("Không tìm thấy câu hỏi #" + id);
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

    public void addTagToQuestion(int questionId, int tagId) throws Exception {
        Question q = questionDAO.findById(questionId);
        if (q == null) throw new Exception("Không tìm thấy câu hỏi #" + questionId);
        if (tagDAO.findById(tagId) == null)
            throw new Exception("Không tìm thấy tag #" + tagId);
        questionDAO.addTag(questionId, tagId);
    }

    public void removeTagFromQuestion(int questionId, int tagId) throws Exception {
        Question q = questionDAO.findById(questionId);
        if (q == null) throw new Exception("Không tìm thấy câu hỏi #" + questionId);
        questionDAO.removeTag(questionId, tagId);
    }
}
