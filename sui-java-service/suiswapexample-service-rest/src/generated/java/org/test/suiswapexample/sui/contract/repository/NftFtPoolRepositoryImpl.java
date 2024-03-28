package org.test.suiswapexample.sui.contract.repository;

import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;

@Repository
public class NftFtPoolRepositoryImpl implements NftFtPoolRepository {
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<NftAssetDto> getAssets(String nftType, String coinType, String liquidityTokenObjectId,
                                       String subtypeFieldName, String subtypeValue, Boolean buyable) {
        if (subtypeFieldName != null && !IdentifierValidator.isValidFieldName(subtypeFieldName)) {
            throw new IllegalArgumentException("Invalid subtypeFieldName");
        }
        StringBuilder queryBuilder = new StringBuilder("SELECT\n" +
                "    a.key_ AS assetObjectId, a.value AS assetAmount,\n" +
                "    a.trade_pool_id as poolObjectId,\n" +
                "    p.liquidity_token_id as liquidityTokenObjectId, p.pool_type as poolType,\n" +
                "    p.x_token_type as nftType, p.y_token_type as coinType, ");

        if (subtypeFieldName != null && subtypeValue != null) {
            queryBuilder.append("JSON_UNQUOTE(JSON_EXTRACT(r.value, CONCAT('$.','").append(subtypeFieldName).append("'))) as assetSubtype");
        } else {
            queryBuilder.append("NULL as assetSubtype");
        }

        queryBuilder.append("\nFROM\n" +
                "    trade_pool_x_amounts_item a\n" +
                "        LEFT JOIN\n" +
                "    trade_pool p ON a.trade_pool_id = p.id\n" +
                "        LEFT JOIN\n" +
                "    trade_pool_x_reserve_item r ON a.trade_pool_id = r.trade_pool_id\n" +
                "WHERE\n x_token_type = :nftType AND y_token_type = :coinType");
        if (liquidityTokenObjectId != null) {
            queryBuilder.append(" AND p.liquidity_token_id = :liquidityTokenObjectId");
        }
        if (subtypeFieldName != null && subtypeValue != null) {
            queryBuilder.append(" AND JSON_UNQUOTE(JSON_EXTRACT(r.value, CONCAT('$.','").append(subtypeFieldName).append("'))) = :subtypeValue");
        }
        // PoolType:
        //    const TRADE_POOL: u8 = 0;
        //    const SELL_POOL: u8 = 1;
        //    const BUY_POOL: u8 = 2;
        //
        // TradePool and SellPool are buyable.
        if (buyable != null && buyable) {
            queryBuilder.append(" AND p.pool_type IN (0, 1)");
        }
        Query query = entityManager.createNativeQuery(queryBuilder.toString(), "NftAssetDtoMapping");
        query.setParameter("nftType", nftType);
        query.setParameter("coinType", coinType);
        if (liquidityTokenObjectId != null) {
            query.setParameter("liquidityTokenObjectId", liquidityTokenObjectId);
        }
        if (subtypeFieldName != null && subtypeValue != null) {
            query.setParameter("subtypeValue", subtypeValue);
        }
        return query.getResultList();
    }
}
