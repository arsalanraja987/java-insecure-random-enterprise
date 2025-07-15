import javax.servlet.http.HttpServletRequest;

public class Spring4ShellVuln1 {
    public void handleRequest(HttpServletRequest request) throws Exception {
        String className = request.getParameter("class");
        Class<?> clazz = Class.forName(className);
        Object instance = clazz.getDeclaredConstructor().newInstance();
        System.out.println("Instantiated class: " + instance.getClass());
    }
}
