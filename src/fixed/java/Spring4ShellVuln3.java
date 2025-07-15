import javax.servlet.http.HttpServletRequest;

public class Spring4ShellVuln3 {
    public void process(HttpServletRequest request) throws Exception {
        String payload = request.getParameter("payload");
        Class<?> dynamicClass = Class.forName(payload);
        dynamicClass.getDeclaredConstructor().newInstance();
    }
}
