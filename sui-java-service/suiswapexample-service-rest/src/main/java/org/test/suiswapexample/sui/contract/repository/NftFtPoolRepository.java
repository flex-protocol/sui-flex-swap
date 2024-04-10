package org.test.suiswapexample.sui.contract.repository;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public interface NftFtPoolRepository {

    byte TRADE_POOL = 0;
    byte SELL_POOL = 1;
    byte BUY_POOL = 2;

    List<NftAssetDto> getAssets(String nftType, String coinType, String liquidityTokenObjectId,
                                String poolObjectId,
                                String subtypeFieldName, String subtypeValue, Boolean buyable);

    List<PoolDto> getPools(String nftType, String coinType, String[] poolTypes, String poolObjectId,
                           String liquidityTokenObjectId);

    class NftAssetDto {
        private String assetObjectId;
        private String assetAmount;
        private String assetSubtype;
        private String poolObjectId;
        private String liquidityTokenObjectId;
        private String poolType;
        private String nftType;
        private String coinType;

        private Map<String, Object> display;

        public NftAssetDto(String assetObjectId, String assetAmount, String assetSubtype,
                           String poolObjectId, String liquidityTokenObjectId, String poolType,
                           String nftType, String coinType) {
            this.assetObjectId = assetObjectId;
            this.assetAmount = assetAmount;
            this.assetSubtype = assetSubtype;
            this.poolObjectId = poolObjectId;
            this.liquidityTokenObjectId = liquidityTokenObjectId;
            this.poolType = poolType;
            this.nftType = nftType;
            this.coinType = coinType;
        }

        public String getAssetObjectId() {
            return assetObjectId;
        }

        public void setAssetObjectId(String assetObjectId) {
            this.assetObjectId = assetObjectId;
        }

        public String getAssetAmount() {
            return assetAmount;
        }

        public void setAssetAmount(String assetAmount) {
            this.assetAmount = assetAmount;
        }

        public String getAssetSubtype() {
            return assetSubtype;
        }

        public void setAssetSubtype(String assetSubtype) {
            this.assetSubtype = assetSubtype;
        }

        public String getPoolObjectId() {
            return poolObjectId;
        }

        public void setPoolObjectId(String poolObjectId) {
            this.poolObjectId = poolObjectId;
        }

        public String getLiquidityTokenObjectId() {
            return liquidityTokenObjectId;
        }

        public void setLiquidityTokenObjectId(String liquidityTokenObjectId) {
            this.liquidityTokenObjectId = liquidityTokenObjectId;
        }

        public String getPoolType() {
            return poolType;
        }

        public void setPoolType(String poolType) {
            this.poolType = poolType;
        }

        public String getNftType() {
            return nftType;
        }

        public void setNftType(String nftType) {
            this.nftType = nftType;
        }

        public String getCoinType() {
            return coinType;
        }

        public void setCoinType(String coinType) {
            this.coinType = coinType;
        }

        public Map<String, Object> getDisplay() {
            return display;
        }

        public void setDisplay(Map<String, Object> display) {
            this.display = display;
        }

        @Override
        public String toString() {
            return "NftAssetDto{" +
                    "assetObjectId='" + assetObjectId + '\'' +
                    ", assetAmount='" + assetAmount + '\'' +
                    ", assetSubtype='" + assetSubtype + '\'' +
                    ", poolObjectId='" + poolObjectId + '\'' +
                    ", liquidityTokenObjectId='" + liquidityTokenObjectId + '\'' +
                    ", poolType='" + poolType + '\'' +
                    ", display='" + display + '\'' +
                    '}';
        }
    }

    class PoolDto {
        private String poolObjectId;
        private String nftType;
        private String coinType;
        private String nftBasicUnitAmount;
        private String nftTotalAmount;
        private String poolType;
        private String priceCurveType;
        private String startExchangeRateNumerator;
        private String exchangeRateNumerator;
        private String exchangeRateDenominator;
        private String priceDeltaNftAmount;
        private String priceDeltaNumerator;
        private String priceDeltaDenominator;
        private String liquidityTokenObjectId;
        private String coinReserve;
        private SpotPriceDto[] spotPrices;

        public PoolDto(String poolObjectId, String nftType, String coinType,
                       //String nftBasicUnitAmount,
                       String nftTotalAmount,
                       String poolType, String priceCurveType,
                       String startExchangeRateNumerator,
                       String exchangeRateNumerator, String exchangeRateDenominator,
                       String priceDeltaNftAmount, String priceDeltaNumerator, String priceDeltaDenominator,
                       String liquidityTokenObjectId,
                       String coinReserve
        ) {
            this.poolObjectId = poolObjectId;
            this.nftType = nftType;
            this.coinType = coinType;
            //this.nftBasicUnitAmount = nftBasicUnitAmount;
            this.nftTotalAmount = nftTotalAmount;
            this.poolType = poolType;
            this.priceCurveType = priceCurveType;
            this.startExchangeRateNumerator = startExchangeRateNumerator;
            this.exchangeRateNumerator = exchangeRateNumerator;
            this.exchangeRateDenominator = exchangeRateDenominator;
            this.priceDeltaNftAmount = priceDeltaNftAmount;
            this.priceDeltaNumerator = priceDeltaNumerator;
            this.priceDeltaDenominator = priceDeltaDenominator;
            this.liquidityTokenObjectId = liquidityTokenObjectId;
            this.coinReserve = coinReserve;
        }

        public String getPoolObjectId() {
            return poolObjectId;
        }

        public void setPoolObjectId(String poolObjectId) {
            this.poolObjectId = poolObjectId;
        }

        public String getNftType() {
            return nftType;
        }

        public void setNftType(String nftType) {
            this.nftType = nftType;
        }

        public String getCoinType() {
            return coinType;
        }

        public void setCoinType(String coinType) {
            this.coinType = coinType;
        }

        public String getNftBasicUnitAmount() {
            return nftBasicUnitAmount;
        }

        public void setNftBasicUnitAmount(String nftBasicUnitAmount) {
            this.nftBasicUnitAmount = nftBasicUnitAmount;
        }

        public String getNftTotalAmount() {
            return nftTotalAmount;
        }

        public void setNftTotalAmount(String nftTotalAmount) {
            this.nftTotalAmount = nftTotalAmount;
        }

        public String getPoolType() {
            return poolType;
        }

        public void setPoolType(String poolType) {
            this.poolType = poolType;
        }

        public String getPriceCurveType() {
            return priceCurveType;
        }

        public void setPriceCurveType(String priceCurveType) {
            this.priceCurveType = priceCurveType;
        }

        public String getStartExchangeRateNumerator() {
            return startExchangeRateNumerator;
        }

        public void setStartExchangeRateNumerator(String startExchangeRateNumerator) {
            this.startExchangeRateNumerator = startExchangeRateNumerator;
        }

        public String getExchangeRateNumerator() {
            return exchangeRateNumerator;
        }

        public void setExchangeRateNumerator(String exchangeRateNumerator) {
            this.exchangeRateNumerator = exchangeRateNumerator;
        }

        public String getExchangeRateDenominator() {
            return exchangeRateDenominator;
        }

        public void setExchangeRateDenominator(String exchangeRateDenominator) {
            this.exchangeRateDenominator = exchangeRateDenominator;
        }

        public String getPriceDeltaNftAmount() {
            return priceDeltaNftAmount;
        }

        public void setPriceDeltaNftAmount(String priceDeltaNftAmount) {
            this.priceDeltaNftAmount = priceDeltaNftAmount;
        }

        public String getPriceDeltaNumerator() {
            return priceDeltaNumerator;
        }

        public void setPriceDeltaNumerator(String priceDeltaNumerator) {
            this.priceDeltaNumerator = priceDeltaNumerator;
        }

        public String getPriceDeltaDenominator() {
            return priceDeltaDenominator;
        }

        public void setPriceDeltaDenominator(String priceDeltaDenominator) {
            this.priceDeltaDenominator = priceDeltaDenominator;
        }

        public String getLiquidityTokenObjectId() {
            return liquidityTokenObjectId;
        }

        public void setLiquidityTokenObjectId(String liquidityTokenObjectId) {
            this.liquidityTokenObjectId = liquidityTokenObjectId;
        }

        public String getCoinReserve() {
            return coinReserve;
        }

        public void setCoinReserve(String coinReserve) {
            this.coinReserve = coinReserve;
        }

        public SpotPriceDto[] getSpotPrices() {
            return spotPrices;
        }

        public void setSpotPrices(SpotPriceDto[] spotPrices) {
            this.spotPrices = spotPrices;
        }

        @Override
        public String toString() {
            return "PoolDto{" +
                    "poolObjectId='" + poolObjectId + '\'' +
                    ", nftType='" + nftType + '\'' +
                    ", coinType='" + coinType + '\'' +
                    ", nftBasicUnitAmount='" + nftBasicUnitAmount + '\'' +
                    ", nftTotalAmount='" + nftTotalAmount + '\'' +
                    ", poolType='" + poolType + '\'' +
                    ", priceCurveType='" + priceCurveType + '\'' +
                    ", startExchangeRateNumerator='" + startExchangeRateNumerator + '\'' +
                    ", exchangeRateNumerator='" + exchangeRateNumerator + '\'' +
                    ", exchangeRateDenominator='" + exchangeRateDenominator + '\'' +
                    ", priceDeltaNftAmount='" + priceDeltaNftAmount + '\'' +
                    ", priceDeltaNumerator='" + priceDeltaNumerator + '\'' +
                    ", priceDeltaDenominator='" + priceDeltaDenominator + '\'' +
                    ", liquidityTokenObjectId='" + liquidityTokenObjectId + '\'' +
                    ", coinReserve='" + coinReserve + '\'' +
                    ", spotPrices=" + Arrays.toString(spotPrices) +
                    '}';
        }
    }

    class SpotPriceDto {
        //private BigDecimal price;
        private BigInteger coinAmount;
        private BigInteger nftAmount;

        public SpotPriceDto(BigInteger coinAmount, BigInteger nftAmount) {
            this.coinAmount = coinAmount;
            this.nftAmount = nftAmount;
        }

        public SpotPriceDto() {
        }

        public BigInteger getCoinAmount() {
            return coinAmount;
        }

        public void setCoinAmount(BigInteger coinAmount) {
            this.coinAmount = coinAmount;
        }

        public BigInteger getNftAmount() {
            return nftAmount;
        }

        public void setNftAmount(BigInteger nftAmount) {
            this.nftAmount = nftAmount;
        }

        @Override
        public String toString() {
            return "SpotPriceDto{" +
                    "coinAmount=" + coinAmount +
                    ", nftAmount=" + nftAmount +
                    '}';
        }
    }
}
