public class RandomVuln2 {
    public static void main(String[] args) {
        double token = secureRandom.nextDouble();
        System.out.println("Token: " + token);
    }
}
