import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SpringAccessVuln1 {

    @GetMapping("/admin")
    @Secured("ROLE_USER") // ❌ Incorrect: should be ROLE_ADMIN
    public String adminEndpoint() {
        return "You are in the admin panel!";
    }
}
