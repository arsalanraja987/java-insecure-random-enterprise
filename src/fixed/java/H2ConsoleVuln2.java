import java.sql.Connection;
import java.sql.DriverManager;

public class H2ConsoleVuln2 {
    public void openDb() throws Exception {
        String dbUrl = "jdbc:h2:mem:test;TRACE_LEVEL_SYSTEM_OUT=3
        Connection conn = DriverManager.getConnection(dbUrl, "sa", "");
        conn.close();
    }
}
