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
                                       String poolObjectId,
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
                "    trade_pool_x_reserve_item r ON a.key_ = r.key_\n" +
                "WHERE\n x_token_type = :nftType AND y_token_type = :coinType");
        if (liquidityTokenObjectId != null) {
            queryBuilder.append(" AND p.liquidity_token_id = :liquidityTokenObjectId");
        }
        if (poolObjectId != null) {
            queryBuilder.append(" AND a.trade_pool_id = :poolObjectId");
        }
        if (subtypeFieldName != null && subtypeValue != null) {
            queryBuilder.append(" AND JSON_UNQUOTE(JSON_EXTRACT(r.value, CONCAT('$.','").append(subtypeFieldName).append("'))) = :subtypeValue");
        }
        // TradePool and SellPool are buyable.
        if (buyable != null && buyable) {
            queryBuilder.append(" AND p.pool_type IN (" + TRADE_POOL + ", " + SELL_POOL + ")");
        }
        Query query = entityManager.createNativeQuery(queryBuilder.toString(), "NftAssetDtoMapping");
        query.setParameter("nftType", nftType);
        query.setParameter("coinType", coinType);
        if (liquidityTokenObjectId != null) {
            query.setParameter("liquidityTokenObjectId", liquidityTokenObjectId);
        }
        if (poolObjectId != null) {
            query.setParameter("poolObjectId", poolObjectId);
        }
        if (subtypeFieldName != null && subtypeValue != null) {
            query.setParameter("subtypeValue", subtypeValue);
        }
        return query.getResultList();
    }

    @Override
    public List<PoolDto> getPools(String nftType, String coinType, String[] poolTypes, String poolObjectId, String liquidityTokenObjectId) {
        StringBuilder queryBuilder = new StringBuilder("SELECT\n" +
                "    p.id AS poolObjectId,\n" +
                "    p.x_token_type AS nftType,\n" +
                "    p.y_token_type AS coinType,\n" +
                //"    c.basic_unit_amount AS nftBasicUnitAmount,\n" +
                "    p.x_total_amount AS nftTotalAmount,\n" +
                "    p.pool_type AS poolType,\n" +
                "    p.price_curve_type AS priceCurveType,\n" +
                "    p.start_exchange_rate_numerator AS startExchangeRateNumerator,\n" +
                "    p.exchange_rate_numerator AS exchangeRateNumerator,\n" +
                "    p.exchange_rate_denominator AS exchangeRateDenominator,\n" +
                "    p.price_delta_x_amount AS priceDeltaNftAmount,\n" +
                "    p.price_delta_numerator AS priceDeltaNumerator,\n" +
                "    p.price_delta_denominator AS priceDeltaDenominator,\n" +
                "    p.liquidity_token_id AS liquidityTokenObjectId,\n" +
                "    p.y_reserve as coinReserve\n" +
                "FROM\n" +
                "    trade_pool p\n" +
                //"        LEFT JOIN\n" +
                //"    nft_collection c ON p.x_token_type = c.collection_type\n" +
                "WHERE\n" +
                "    1 = 1\n" +
                "        AND x_token_type = :nftType\n" +
                "        AND y_token_type = :coinType\n");

        if (poolObjectId != null) {
            queryBuilder.append(" AND p.id = :poolObjectId\n");
        }
        if (liquidityTokenObjectId != null) {
            queryBuilder.append(" AND p.liquidity_token_id = :liquidityTokenObjectId\n");
        }
        if (poolTypes != null && poolTypes.length > 0) {
            queryBuilder.append(" AND p.pool_type IN (");
            for (int i = 0; i < poolTypes.length; i++) {
                queryBuilder//.append("'")
                        .append(poolTypes[i]);//.append("'");
                if (i < poolTypes.length - 1) {
                    queryBuilder.append(", ");
                }
            }
            queryBuilder.append(")\n");
        }
        Query query = entityManager.createNativeQuery(queryBuilder.toString(), "NftFtPoolDtoMapping");
        query.setParameter("nftType", nftType);
        query.setParameter("coinType", coinType);
        if (poolObjectId != null) {
            query.setParameter("poolObjectId", poolObjectId);
        }
        if (liquidityTokenObjectId != null) {
            query.setParameter("liquidityTokenObjectId", liquidityTokenObjectId);
        }
        return query.getResultList();
    }

}
