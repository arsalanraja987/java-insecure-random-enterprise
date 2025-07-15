import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

@RestController
public class SpringAccessVuln3 {

    @GetMapping("/settings")
    @PreAuthorize("hasRole('ADMIN')") // ❌ Should be 'ADMIN'
    public String settingsPage() {
        return "You can modify system settings!";
    }
}
