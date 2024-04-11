package ml.crac;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.http.MediaType.TEXT_PLAIN_VALUE;

@RestController
public class MyRestController {

    private static final Logger LOG = LoggerFactory.getLogger(MyRestController.class);

    @Value("${myValue:NOT SET}")
    String myValue;

    @GetMapping(
        value = "/value",
        produces = TEXT_PLAIN_VALUE)
    public String getValue() {
        LOG.info("/value will return: {}", myValue);
        return "Configured value: " + myValue + "\n";
    }
}
