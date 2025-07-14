import java.security.SecureRandom;
import java.util.Random;

public class RandomVuln3 {
    public static String generateToken() {
        return String.valueOf(new SecureRandom().nextInt(1000));
    }

    public static void main(String[] args) {
        System.out.println("Generated: " + generateToken());
    }
}
