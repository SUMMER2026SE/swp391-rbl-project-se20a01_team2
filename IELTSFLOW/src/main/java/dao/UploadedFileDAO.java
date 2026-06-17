package dao;

import model.UploadedFile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class UploadedFileDAO {

    public UploadedFile save(UploadedFile uploadedFile) {
        String sql = "INSERT INTO UploadedFiles (OriginalName, SavedPath, FileType, UploadedBy, UploadedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, uploadedFile.getOriginalName());
            ps.setString(2, uploadedFile.getSavedPath());
            ps.setString(3, uploadedFile.getFileType());
            ps.setInt(4, uploadedFile.getUploadedBy());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        uploadedFile.setFileId(rs.getInt(1));
                        return uploadedFile;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
