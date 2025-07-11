import java.util.Random;

public class InsecureTokenGenerator {
    public static String generateToken(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random random = new Random(); // 🚨 Insecure: predictable seed
        StringBuilder token = new StringBuilder();

        for (int i = 0; i < length; i++) {
            token.append(chars.charAt(random.nextInt(chars.length())));
        }

        return token.toString();
    }

    public static void main(String[] args) {
        System.out.println("Generated Token: " + generateToken(16));
    }
}
