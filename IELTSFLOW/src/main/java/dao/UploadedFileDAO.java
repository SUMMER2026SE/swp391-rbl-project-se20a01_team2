package dao;

import model.UploadedFile;
import util.JpaHelper;

public class UploadedFileDAO {

    public UploadedFile save(UploadedFile uploadedFile) {
        try {
            JpaHelper.execute(em -> em.persist(uploadedFile));
            return uploadedFile;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
