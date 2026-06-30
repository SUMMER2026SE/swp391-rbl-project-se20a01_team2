import java.sql.*;
public class TestLesson {
  public static void main(String[] args) throws Exception {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String url = "jdbc:sqlserver://localhost:1433;databaseName=IELTSFlow;encrypt=true;trustServerCertificate=true;";
    try (Connection c = DriverManager.getConnection(url, "sa", "1234567890");
         Statement s = c.createStatement();
         ResultSet rs = s.executeQuery("SELECT LessonID, Title, VideoUrl, DocumentUrl FROM Lessons")) {
      while (rs.next()) {
        System.out.println("ID=" + rs.getInt(1) + ", Title=" + rs.getString(2) + ", VideoUrl='" + rs.getString(3) + "', DocUrl='" + rs.getString(4) + "'");
      }
    }
  }
}
