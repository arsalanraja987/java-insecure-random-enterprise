import java.util.Random;

public class RandomVuln3 {
    public static String generateToken() {
        return String.valueOf(new Random().nextInt(1000));
    }

    public static void main(String[] args) {
        System.out.println("Generated: " + generateToken());
    }
}
