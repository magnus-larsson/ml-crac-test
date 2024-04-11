package ml.crac;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CracApplication {

	private static final Logger LOG = LoggerFactory.getLogger(CracApplication.class);
	private static final int APP_VERSION = 1;

	public static void main(String[] args) {
		LOG.info("App version v{} starting...", APP_VERSION);
		SpringApplication.run(CracApplication.class, args);
		LOG.info("App version v{} started!", APP_VERSION);

	}

}
