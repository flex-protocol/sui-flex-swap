package org.test.suiswapexample;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.test.suiswapexample.sui.contract.repository.NftFtPoolRepository;

import java.util.stream.StreamSupport;

@SpringBootTest
public class SuiSwapExampleApplicationTests {
    @Autowired
    private NftFtPoolRepository nftPoolRepository;


    @Test
    @Transactional
    //@Rollback(false)
    public void testNftPoolRepository() {
        String nftType = "0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment";
        String coinType = "0x2::sui::SUI";
        StreamSupport.stream(nftPoolRepository.getPools(nftType, coinType, null, null, null).spliterator(), false)
                .forEach(System.out::println);
    }
}
