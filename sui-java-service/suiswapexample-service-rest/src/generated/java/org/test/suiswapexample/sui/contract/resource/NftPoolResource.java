package org.test.suiswapexample.sui.contract.resource;

import com.github.wubuku.sui.bean.*;
import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.test.suiswapexample.domain.nftcollection.NftCollectionState;
import org.test.suiswapexample.domain.nftcollection.NftCollectionStateRepository;
import org.test.suiswapexample.domain.tradepool.TradePoolState;
import org.test.suiswapexample.domain.tradepool.TradePoolStateQueryRepository;
import org.test.suiswapexample.sui.contract.ContractConstants;
import org.test.suiswapexample.sui.contract.SuiPackage;
import org.test.suiswapexample.sui.contract.TradePool;
import org.test.suiswapexample.sui.contract.repository.NftFtPoolRepository;
import org.test.suiswapexample.sui.contract.repository.SuiPackageRepository;

import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RequestMapping(path = "nftPools", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class NftPoolResource {
    @Autowired
    private NftFtPoolRepository nftPoolRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private NftCollectionStateRepository nftCollectionStateRepository;

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private TradePoolStateQueryRepository tradePoolStateQueryRepository;

    @GetMapping(path = "assets")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.NftAssetDto> getAssets(
            @RequestParam String nftType,
            @RequestParam String coinType,
            @RequestParam(required = false) String liquidityTokenObjectId,
            @RequestParam(required = false) String subtypeFieldName,
            @RequestParam(required = false) String subtypeValue,
            @RequestParam(required = false) Boolean buyable) {
        return nftPoolRepository.getAssets(nftType, coinType, liquidityTokenObjectId, subtypeFieldName, subtypeValue, buyable);
    }

    @GetMapping(path = "ownedAssets")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.NftAssetDto> getOwnedAssets(
            @RequestParam String nftType,
            @RequestParam String address) {
        List<String> assetObjIds = getOwnedObjectIds(nftType, address);

        return assetObjIds.stream().map(objectId -> {
            String[] amountAndSubtype = getAssetAmountAndSubtype(objectId, nftType);
            return new NftFtPoolRepository.NftAssetDto(objectId, amountAndSubtype[0], amountAndSubtype[1],
                    null, null, null, nftType, null);
        }).collect(Collectors.toList());
    }

    @GetMapping(path = "ownedPools")
    public List<TradePool> getOwnedPools(
            @RequestParam String address
    ) {
        String liquidityTokenPackageId = getDefaultSuiPackageId();
        List<String> liquidityTokenObjIds = getOwnedObjectIds(
                liquidityTokenPackageId + "::liquidity_token::LiquidityToken", address);
        List<String> poolObjIds = liquidityTokenObjIds.stream().map(i -> getPoolIdByLiquidityTokenId(i))
                .filter(i -> i != null)
                .collect(Collectors.toList());
        return poolObjIds.stream().map(objectId -> {
            SuiMoveObjectResponse<TradePool> suiObjectResponse = suiJsonRpcClient.getMoveObject(objectId,
                    new SuiObjectDataOptions(
                            true,
                            true,
                            true,
                            true,
                            true,
                            false,
                            false
                    ),
                    TradePool.class
            );
            return suiObjectResponse.getData().getContent().getFields();
        }).collect(Collectors.toList());
    }

    private String getPoolIdByLiquidityTokenId(String liquidityTokenId) {
        List<java.util.Map.Entry<String, Object>> filter = new ArrayList<>();
        filter.add(new AbstractMap.SimpleEntry<>("liquidityTokenId", liquidityTokenId));
        TradePoolState pool = tradePoolStateQueryRepository.getFirst(filter, null);
        return pool == null ? null : pool.getId();
    }

    private String[] getAssetAmountAndSubtype(String objectId, String nftType) {
        NftCollectionState c = nftCollectionStateRepository.get(nftType, true);
        if (c == null) {
            return new String[]{null, null};
        }
        String amountFieldName = c.getAmountFieldName();
        String subtypeFieldName = c.getSubtypeFieldName();
        SuiObjectResponse suiObjectResponse = suiJsonRpcClient.getObject(objectId,
                new SuiObjectDataOptions(
                        true,
                        true,
                        true,
                        true,
                        true,
                        false,
                        false
                )
        );
        if (suiObjectResponse.getData().getContent() instanceof SuiParsedData.MoveObject) {
            SuiParsedData.MoveObject moveObject = (SuiParsedData.MoveObject) suiObjectResponse.getData().getContent();
            String amount = String.valueOf(moveObject.getFields().get(amountFieldName));
            String subtype = String.valueOf(moveObject.getFields().get(subtypeFieldName));
            return new String[]{amount, subtype};
        } else {
            return new String[]{null, null};
        }
    }

    private List<String> getOwnedObjectIds(String objectType, String address) {
        SuiObjectDataFilter filter = new SuiObjectDataFilter.StructType(objectType);
        SuiObjectResponseQuery query = new SuiObjectResponseQuery(filter, null);
        String cursor = null;
        List<String> objectIds = new ArrayList<>();
        while (true) {
            ObjectsPage ownedObjects = suiJsonRpcClient.getOwnedObjects(address,
                    query, cursor, 50);
            for (SuiObjectResponse suiObj : ownedObjects.getData()) {
                if (suiObj.getData() != null) {
                    objectIds.add(suiObj.getData().getObjectId());
                }
            }
            if (ownedObjects.getHasNextPage() == null || !ownedObjects.getHasNextPage()
                    || ownedObjects.getNextCursor() == null
            ) {
                break;
            }
            cursor = ownedObjects.getNextCursor();
        }
        return objectIds;
    }

    private String getDefaultSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.DEFAULT_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }

}
