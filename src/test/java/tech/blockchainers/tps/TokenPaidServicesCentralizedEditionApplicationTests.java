package tech.blockchainers.tps;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import tech.blockchainers.tps.service.CirclesGCTCentralizedEditionPaidService;


@SpringBootTest
@Slf4j
class TokenPaidServicesCentralizedEditionApplicationTests {

	@Autowired
	private CirclesGCTCentralizedEditionPaidService circlesGCTCentralizedEditionPaidService;

	@Test
	void contextLoads() throws Exception {
		circlesGCTCentralizedEditionPaidService.prepareTokenTrustGraph();
	}

}
