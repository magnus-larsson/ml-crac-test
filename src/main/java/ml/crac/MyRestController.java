package ml.crac;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.http.MediaType.TEXT_PLAIN_VALUE;

@RestController
public class MyRestController {

    @Value("${myValue:NOT SET}")
    String myValue;

    @GetMapping(
        value = "/value",
        produces = TEXT_PLAIN_VALUE)
    public String getValue() {
        return "Configured value: " + myValue + "\n";
    }
}
