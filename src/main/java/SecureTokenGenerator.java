import java.security.SecureRandom;

public class SecureTokenGenerator {
    public static String generateToken(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        SecureRandom secureRandom = new SecureRandom();
        StringBuilder token = new StringBuilder();

        for (int i = 0; i < length; i++) {
            token.append(chars.charAt(secureRandom.nextInt(chars.length())));
        }

        return token.toString();
    }

    public static void main(String[] args) {
        System.out.println("Generated Secure Token: " + generateToken(16));
    }
}
