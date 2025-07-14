import org.apache.tika.parser.AutoDetectParser;
import java.io.File;

public class TikaVuln1 {
    public static void main(String[] args) throws Exception {
        AutoDetectParser parser = new AutoDetectParser();
        parser.parse(new File("input.xml"), null);
    }
}
