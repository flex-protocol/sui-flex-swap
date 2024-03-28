package org.test.suiswapexample.sui.contract.repository;

import java.util.List;

public interface NftFtPoolRepository {

    List<NftAssetDto> getAssets(String nftType, String coinType, String liquidityTokenObjectId,
                                String subtypeFieldName, String subtypeValue, Boolean buyable);

    class NftAssetDto {
        private String assetObjectId;
        private String assetAmount;
        private String assetSubtype;
        private String poolObjectId;
        private String liquidityTokenObjectId;
        private String poolType;
        private String nftType;
        private String coinType;


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

        @Override
        public String toString() {
            return "NftAssetDto{" +
                    "assetObjectId='" + assetObjectId + '\'' +
                    ", assetAmount='" + assetAmount + '\'' +
                    ", assetSubtype='" + assetSubtype + '\'' +
                    ", poolObjectId='" + poolObjectId + '\'' +
                    ", liquidityTokenObjectId='" + liquidityTokenObjectId + '\'' +
                    ", poolType='" + poolType + '\'' +
                    '}';
        }
    }
}
