import org.mindrot.jbcrypt.BCrypt;
public class TestHash {
    public static void main(String[] args) {
        String hash = BCrypt.hashpw("123456", BCrypt.gensalt(12));
        System.out.println("HASH=" + hash);
        System.out.println("CHECK=" + BCrypt.checkpw("123456", hash));
    }
}
