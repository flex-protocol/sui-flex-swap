package org.test.suiswapexample.sui.contract.repository;

import javax.persistence.*;

@Entity
@SqlResultSetMapping(
        name = "NftAssetDtoMapping",
        classes = @ConstructorResult(
                targetClass = NftFtPoolRepository.NftAssetDto.class,
                columns = {
                        @ColumnResult(name = "assetObjectId", type = String.class),
                        @ColumnResult(name = "assetAmount", type = String.class),
                        @ColumnResult(name = "assetSubtype", type = String.class),
                        @ColumnResult(name = "poolObjectId", type = String.class),
                        @ColumnResult(name = "liquidityTokenObjectId", type = String.class),
                        @ColumnResult(name = "poolType", type = String.class),
                        @ColumnResult(name = "nftType", type = String.class),
                        @ColumnResult(name = "coinType", type = String.class)
                }
        )
)
@SqlResultSetMapping(
        name = "NftFtPoolDtoMapping",
        classes = @ConstructorResult(
                targetClass = NftFtPoolRepository.PoolDto.class,
                columns = {
                        @ColumnResult(name = "poolObjectId", type = String.class),
                        @ColumnResult(name = "nftType", type = String.class),
                        @ColumnResult(name = "coinType", type = String.class),
                        @ColumnResult(name = "nftBasicUnitAmount", type = String.class),
                        @ColumnResult(name = "nftTotalAmount", type = String.class),
                        @ColumnResult(name = "poolType", type = String.class),
                        @ColumnResult(name = "priceCurveType", type = String.class),
                        @ColumnResult(name = "startExchangeRateNumerator", type = String.class),
                        @ColumnResult(name = "exchangeRateNumerator", type = String.class),
                        @ColumnResult(name = "exchangeRateDenominator", type = String.class),
                        @ColumnResult(name = "priceDeltaNftAmount", type = String.class),
                        @ColumnResult(name = "priceDeltaNumerator", type = String.class),
                        @ColumnResult(name = "priceDeltaDenominator", type = String.class),
                        @ColumnResult(name = "liquidityTokenObjectId", type = String.class)
                }
        )
)
public class Unused {
    @Id
    private String id;
}
