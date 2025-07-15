import javax.servlet.http.HttpServletRequest;

public class Spring4ShellVuln2 {
    public void load(HttpServletRequest request) throws Exception {
        String type = request.getParameter("type");
        Object obj = Class.forName(type).newInstance();
        System.out.println(obj);
    }
}
