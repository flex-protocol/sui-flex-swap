package org.test.suiswapexample.sui.contract.resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.test.suiswapexample.sui.contract.repository.NftFtPoolRepository;

import java.util.List;

@RequestMapping(path = "nftPools", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class NftPoolResource {
    @Autowired
    private NftFtPoolRepository nftPoolRepository;

    @GetMapping(path = "assets")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.NftAssetDto> getAssets(
            @RequestParam String nftType,
            @RequestParam String coinType,
            @RequestParam(required = false) String liquidityTokenObjectId,
            @RequestParam(required = false) String subtypeFieldName,
            @RequestParam(required = false) String subtypeValue) {
        return nftPoolRepository.getAssets(nftType, coinType, liquidityTokenObjectId, subtypeFieldName, subtypeValue);
    }
}
