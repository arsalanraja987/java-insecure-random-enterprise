import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SpringAccessVuln2 {

    @GetMapping("/secure-data")
    public String getSecureData() {
        // ❌ No access control at all
        return "Sensitive admin-only information";
    }
}
