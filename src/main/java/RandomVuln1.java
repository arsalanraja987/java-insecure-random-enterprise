import java.util.Random;

public class RandomVuln1 {
    public static void main(String[] args) {
        Random random = new Random();
        System.out.println("Token: " + random.nextInt());
    }
}
