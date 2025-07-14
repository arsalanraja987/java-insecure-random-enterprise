import org.apache.tika.parser.AutoDetectParser;
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());
import java.io.File;

public class TikaVuln1 {
    public static void main(String[] args) throws Exception {
        AutoDetectParser parser = new AutoDetectParser(new SecureContentHandler());
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());
        parser.parse(new File("input.xml"), null);
    }
}
