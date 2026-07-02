public class HashGen {
    public static void main(String[] args) {
        String pw = "123456";
        System.out.println(org.mindrot.jbcrypt.BCrypt.hashpw(pw, org.mindrot.jbcrypt.BCrypt.gensalt(12)));
    }
}
