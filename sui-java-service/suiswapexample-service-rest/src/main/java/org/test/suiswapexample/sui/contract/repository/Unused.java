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
public class Unused {
    @Id
    private String id;
}
