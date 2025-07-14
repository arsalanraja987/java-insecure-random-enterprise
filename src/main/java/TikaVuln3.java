import org.apache.tika.parser.AutoDetectParser;

public class TikaVuln3 {
    public static void parseDoc() {
        AutoDetectParser tika = new AutoDetectParser(); // Vulnerable
    }
}
