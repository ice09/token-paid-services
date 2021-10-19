package tech.blockchainers.tps;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import tech.blockchainers.tps.service.CirclesGCTPaidService;


@SpringBootTest
@Slf4j
class TokenPaidServicesApplicationTests {

	@Autowired
	private CirclesGCTPaidService circlesGCTPaidService;

	@Test
	void contextLoads() throws Exception {
		circlesGCTPaidService.prepareTokenTrustGraph();
	}

}
