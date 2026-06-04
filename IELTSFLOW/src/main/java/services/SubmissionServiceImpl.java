package services;

import dao.SubmissionDetailsDAO;

public class SubmissionServiceImpl implements SubmissionService {

    private final SubmissionDetailsDAO submissionDetailsDAO;

    public SubmissionServiceImpl() {
        this.submissionDetailsDAO = new SubmissionDetailsDAO();
    }

    @Override
    public boolean updateSpeakingEvaluation(int detailId, String transcript, double azureScore) {
        return submissionDetailsDAO.updateSpeakingEvaluation(detailId, transcript, azureScore);
    }
    
    @Override
    public String getQuestionContentByDetailId(int detailId) {
        return submissionDetailsDAO.getQuestionContentByDetailId(detailId);
    }
}
