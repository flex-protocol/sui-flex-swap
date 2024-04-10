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
import org.test.suiswapexample.sui.contract.utils.Pair;
import org.test.suiswapexample.sui.contract.utils.PriceCurve;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RequestMapping(path = "nftPools", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class NftPoolResource {
    public static final int PAGE_MAX_SIZE = 50;
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

    private static void sortPoolsByFirstSpotPrice(boolean buyOrSell, List<NftFtPoolRepository.PoolDto> pools) {
        pools.sort((p1, p2) -> {
            if (p1.getSpotPrices().length == 0 && p2.getSpotPrices().length == 0) {
                return 0;
            }
            if (p1.getSpotPrices().length == 0) {
                //pool having the spot prices takes precedence
                return 1;
            }
            if (p2.getSpotPrices().length == 0) {
                return -1;
            }
            int c = p1.getSpotPrices()[0].getCoinAmount().compareTo(p2.getSpotPrices()[0].getCoinAmount());
            return buyOrSell ? c : -c;//buy: ascending, sell: descending
        });
    }

    @GetMapping(path = "assets")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.NftAssetDto> getAssets(
            @RequestParam String nftType,
            @RequestParam String coinType,
            @RequestParam(required = false) String liquidityTokenObjectId,
            @RequestParam(required = false) String poolObjectId,
            @RequestParam(required = false) String subtypeFieldName,
            @RequestParam(required = false) String subtypeValue,
            @RequestParam(required = false) Boolean buyable,
            @RequestParam(required = false) Boolean showDisplay) {
        List<NftFtPoolRepository.NftAssetDto> assets = nftPoolRepository.getAssets(nftType, coinType,
                liquidityTokenObjectId, poolObjectId, subtypeFieldName, subtypeValue, buyable);
        if (showDisplay != null && showDisplay) {
            assets.forEach(asset -> {
                SuiObjectResponse suiObjectResponse = suiJsonRpcClient.getObject(asset.getAssetObjectId(),
                        new SuiObjectDataOptions(
                                false,
                                false,
                                false,
                                true,
                                false,
                                false,
                                false
                        )
                );
                if (suiObjectResponse.getData() != null && suiObjectResponse.getData().getDisplay() != null) {
                    asset.setDisplay(suiObjectResponse.getData().getDisplay());
                }
            });
        }
        return assets;
    }

    @GetMapping(path = "ownedAssets")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.NftAssetDto> getOwnedAssets(
            @RequestParam String nftType,
            @RequestParam String address) {
        List<String> assetObjIds = getOwnedObjectIds(nftType, address);

        return assetObjIds.stream().map(objectId -> {
            String[] amountAndSubtype = getAssetAmountAndSubtype(objectId, nftType);
            String assetAmount = amountAndSubtype != null && amountAndSubtype.length > 0 ? amountAndSubtype[0] : null;
            String assetSubtype = amountAndSubtype != null && amountAndSubtype.length > 1 ? amountAndSubtype[1] : null;
            NftFtPoolRepository.NftAssetDto assetDto = new NftFtPoolRepository.NftAssetDto(objectId, assetAmount, assetSubtype,
                    null, null, null, nftType, null);
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
            if (suiObjectResponse.getData() != null && suiObjectResponse.getData().getDisplay() != null) {
                assetDto.setDisplay(suiObjectResponse.getData().getDisplay());
            }
            return assetDto;
        }).collect(Collectors.toList());
    }

    @GetMapping(path = "ownedPools")
    @Transactional(readOnly = true)
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

    @GetMapping(path = "buySpotPrices")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.PoolDto> getBuySpotPrices(
            @RequestParam String nftType,
            @RequestParam String coinType,
            @RequestParam BigInteger nftAmountLimit,
            @RequestParam(required = false) String poolObjectId
    ) {
        String[] poolTypes = new String[]{
                NftFtPoolRepository.SELL_POOL + "",
                NftFtPoolRepository.TRADE_POOL + ""
        };
        return getBuyOrSellSpotPrices(
                nftType, coinType, nftAmountLimit, poolObjectId, poolTypes, true
        );
    }

    @GetMapping(path = "sellSpotPrices")
    @Transactional(readOnly = true)
    public List<NftFtPoolRepository.PoolDto> getSellSpotPrices(
            @RequestParam String nftType,
            @RequestParam String coinType,
            @RequestParam BigInteger nftAmountLimit,
            @RequestParam(required = false) String poolObjectId
    ) {
        String[] poolTypes = new String[]{
                NftFtPoolRepository.BUY_POOL + "",
                NftFtPoolRepository.TRADE_POOL + ""
        };
        return getBuyOrSellSpotPrices(
                nftType, coinType, nftAmountLimit, poolObjectId, poolTypes, false
        );
    }

    private List<NftFtPoolRepository.PoolDto> getBuyOrSellSpotPrices(
            String nftType, String coinType,
            BigInteger nftAmountLimit,
            String poolObjectId,
            String[] poolTypes,
            boolean buyOrSell
    ) {
        BigInteger nftBasicUnitAmount = getNftBasicUnitAmount(nftType);
        String liquidityTokenObjectId = null;
        List<NftFtPoolRepository.PoolDto> pools = nftPoolRepository.getPools(nftType, coinType, poolTypes, poolObjectId, liquidityTokenObjectId);
        for (NftFtPoolRepository.PoolDto p : pools) {
            BigInteger coinReserve = new BigDecimal(p.getCoinReserve()).toBigInteger();
            BigInteger totalCoinAmount = BigInteger.ZERO;
            p.setNftBasicUnitAmount(nftBasicUnitAmount + "");
            BigInteger l = nftAmountLimit;
            if (buyOrSell) {//it is a buy
                BigInteger totalNftAmount = p.getNftTotalAmount() != null && !p.getNftTotalAmount().isEmpty() ?
                        new BigInteger(p.getNftTotalAmount()) : BigInteger.ZERO;
                if (nftAmountLimit.compareTo(totalNftAmount) > 0) {
                    l = totalNftAmount;
                }
            }
            BigInteger r = l.remainder(nftBasicUnitAmount);
            int n = l.divide(nftBasicUnitAmount).intValue() + (r.compareTo(BigInteger.ZERO) > 0 ? 1 : 0);
            BigInteger spot_price = new BigInteger(p.getExchangeRateNumerator());
            BigInteger start_price = new BigInteger(p.getStartExchangeRateNumerator());
            BigInteger scaling_factor = new BigInteger(p.getExchangeRateDenominator());
            List<NftFtPoolRepository.SpotPriceDto> spotPrices = new ArrayList<>();
            for (int i = 0; i < n; i++) {
                int MAX_NFT_COUNT = 500;
                if (i >= MAX_NFT_COUNT) {
                    break;
                }
                //BigInteger nftAmount = nftBasicUnitAmount;
                BigInteger nftAmount = i == n - 1 && r.compareTo(BigInteger.ZERO) > 0 ? r : nftBasicUnitAmount;
                byte curve_type = Byte.parseByte(p.getPriceCurveType());
                BigInteger price_delta_enumerator = new BigInteger(p.getPriceDeltaNumerator());
                BigInteger price_delta_denominator = new BigInteger(p.getPriceDeltaDenominator());
                new BigInteger(p.getPriceDeltaDenominator());
                // --------
                // todo cache this?
                Pair<BigInteger, BigInteger> coin_amount_and_new_spot_price = buyOrSell ? PriceCurve.getBuyInfo(
                        curve_type, nftAmount, nftBasicUnitAmount, spot_price, start_price,
                        price_delta_enumerator, price_delta_denominator
                ) : PriceCurve.getSellInfo(
                        curve_type, nftAmount, nftBasicUnitAmount, spot_price, start_price,
                        price_delta_enumerator, price_delta_denominator
                );
                // --------
                BigInteger unscaled_coin_amount = coin_amount_and_new_spot_price.getItem1();
                BigInteger coinAmount = unscaled_coin_amount.divide(scaling_factor);
                if (!buyOrSell) { //it is a sell
                    if (coinAmount.compareTo(BigInteger.ZERO) == 0) {
                        break;
                    }
                    totalCoinAmount = totalCoinAmount.add(coinAmount);
                    if (totalCoinAmount.compareTo(coinReserve) > 0) {
                        break;//"Insufficient coin reserve"
                    }
                }
                NftFtPoolRepository.SpotPriceDto spotPrice = new NftFtPoolRepository.SpotPriceDto(coinAmount, nftAmount);
                spotPrices.add(spotPrice);
                spot_price = coin_amount_and_new_spot_price.getItem2(); //new spot price
            }//end for
            p.setSpotPrices(spotPrices.toArray(new NftFtPoolRepository.SpotPriceDto[0]));
        }//end for
        //
        sortPoolsByFirstSpotPrice(buyOrSell, pools);
        //
        return pools;
    }

    //todo cache this?
    private String getPoolIdByLiquidityTokenId(String liquidityTokenId) {
        List<java.util.Map.Entry<String, Object>> filter = new ArrayList<>();
        filter.add(new AbstractMap.SimpleEntry<>("liquidityTokenId", liquidityTokenId));
        TradePoolState pool = tradePoolStateQueryRepository.getFirst(filter, null);
        return pool == null ? null : pool.getId();
    }

    //todo cache this?
    private BigInteger getNftBasicUnitAmount(String nftType) {
        NftCollectionState c = nftCollectionStateRepository.get(nftType, true);
        if (c == null) {
            throw new IllegalArgumentException("Invalid nftType");
        }
        return c.getBasicUnitAmount();
    }

    //todo cache this?
    private String[] getAssetAmountAndSubtype(String objectId, String nftType) {
        NftCollectionState c = nftCollectionStateRepository.get(nftType, true);
        if (c == null) {
            return null;//new String[]{null, null};
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
            String amount = moveObject.getFields().containsKey(amountFieldName) ? String.valueOf(moveObject.getFields().get(amountFieldName)) : null;
            String subtype = moveObject.getFields().containsKey(subtypeFieldName) ? String.valueOf(moveObject.getFields().get(subtypeFieldName)) : null;
            return new String[]{amount, subtype};
        } else {
            return null;//new String[]{null, null};
        }
    }

    private List<String> getOwnedObjectIds(String objectType, String address) {
        SuiObjectDataFilter filter = new SuiObjectDataFilter.StructType(objectType);
        SuiObjectResponseQuery query = new SuiObjectResponseQuery(filter, null);
        String cursor = null;
        List<String> objectIds = new ArrayList<>();
        while (true) {
            ObjectsPage ownedObjects = suiJsonRpcClient.getOwnedObjects(address,
                    query, cursor, PAGE_MAX_SIZE);
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

    //todo cache this?
    private String getDefaultSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.DEFAULT_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }

}
