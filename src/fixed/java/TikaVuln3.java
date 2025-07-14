import org.apache.tika.parser.AutoDetectParser;
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());

public class TikaVuln3 {
    public static void parseDoc() {
        AutoDetectParser tika = new AutoDetectParser(new SecureContentHandler()); // Vulnerable
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());
    }
}
