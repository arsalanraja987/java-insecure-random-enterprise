import org.apache.tika.parser.AutoDetectParser;
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());

public class TikaVuln2 {
    public void parseXml() throws Exception {
        AutoDetectParser parser = new AutoDetectParser(new SecureContentHandler());
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());
        // No EntityResolver
    }
}
