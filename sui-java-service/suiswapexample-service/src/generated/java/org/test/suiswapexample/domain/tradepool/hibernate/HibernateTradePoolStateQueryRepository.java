// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tradepool.hibernate;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.hibernate.Session;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.test.suiswapexample.domain.tradepool.*;
import org.test.suiswapexample.specialization.*;
import org.test.suiswapexample.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateTradePoolStateQueryRepository implements TradePoolStateQueryRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("Id", "PoolType", "Version", "X_Reserve", "X_Amounts", "X_TotalAmount", "Y_Reserve", "LiquidityTokenId", "X_SoldAmount", "X_BoughtAmount", "StartExchangeRateNumerator", "ExchangeRateNumerator", "ExchangeRateDenominator", "PriceCurveType", "PriceDeltaX_Amount", "PriceDeltaNumerator", "PriceDeltaDenominator", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted", "TradePoolX_ReserveItems", "TradePoolX_AmountsItems", "X_TokenType", "Y_TokenType"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public TradePoolState get(String id) {

        TradePoolState state = (TradePoolState)getCurrentSession().get(AbstractTradePoolState.SimpleTradePoolState.class, id);
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (TradePoolState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{TradePoolState.SqlTradePoolState.class, Saveable.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    @Transactional(readOnly = true)
    public Iterable<TradePoolState> getAll(Integer firstResult, Integer maxResults) {
        Criteria criteria = getCurrentSession().createCriteria(TradePoolState.class);
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
        if (firstResult != null) { criteria.setFirstResult(firstResult); }
        if (maxResults != null) { criteria.setMaxResults(maxResults); }
         addNotDeletedRestriction(criteria);
        return criteria.list();
    }

    @Transactional(readOnly = true)
    public Iterable<TradePoolState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        Criteria criteria = getCurrentSession().createCriteria(TradePoolState.class);
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
        HibernateUtils.criteriaAddFilterAndOrdersAndSetFirstResultAndMaxResults(criteria, filter, orders, firstResult, maxResults);
        addNotDeletedRestriction(criteria);
        return criteria.list();
    }

    @Transactional(readOnly = true)
    public Iterable<TradePoolState> get(org.dddml.support.criterion.Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        Criteria criteria = getCurrentSession().createCriteria(TradePoolState.class);
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
        HibernateUtils.criteriaAddFilterAndOrdersAndSetFirstResultAndMaxResults(criteria, filter, orders, firstResult, maxResults);
        addNotDeletedRestriction(criteria);
        return criteria.list();
    }

    @Transactional(readOnly = true)
    public TradePoolState getFirst(Iterable<Map.Entry<String, Object>> filter, List<String> orders) {
        List<TradePoolState> list = (List<TradePoolState>)get(filter, orders, 0, 1);
        if (list == null || list.size() <= 0)
        {
            return null;
        }
        return list.get(0);
    }

    @Transactional(readOnly = true)
    public TradePoolState getFirst(Map.Entry<String, Object> keyValue, List<String> orders) {
        List<Map.Entry<String, Object>> filter = new ArrayList<>();
        filter.add(keyValue);
        return getFirst(filter, orders);
    }

    @Transactional(readOnly = true)
    public Iterable<TradePoolState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        Map.Entry<String, Object> keyValue = new java.util.AbstractMap.SimpleEntry<String, Object> (propertyName, propertyValue);
        List<Map.Entry<String, Object>> filter = new ArrayList<Map.Entry<String, Object>>();
        filter.add(keyValue);
        return get(filter, orders, firstResult, maxResults);
    }

    @Transactional(readOnly = true)
    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        Criteria criteria = getCurrentSession().createCriteria(TradePoolState.class);
        criteria.setProjection(Projections.rowCount());
        if (filter != null) {
            HibernateUtils.criteriaAddFilter(criteria, filter);
        }
        addNotDeletedRestriction(criteria);
        return (long)criteria.uniqueResult();
    }

    @Transactional(readOnly = true)
    public long getCount(org.dddml.support.criterion.Criterion filter) {
        Criteria criteria = getCurrentSession().createCriteria(TradePoolState.class);
        criteria.setProjection(Projections.rowCount());
        if (filter != null)
        {
            org.hibernate.criterion.Criterion hc = CriterionUtils.toHibernateCriterion(filter);
            criteria.add(hc);
        }
        addNotDeletedRestriction(criteria);
        return (long)criteria.uniqueResult();
    }

    @Transactional(readOnly = true)
    public TradePoolX_ReserveItemState getTradePoolX_ReserveItem(String tradePoolId, String key) {
        TradePoolX_ReserveItemId entityId = new TradePoolX_ReserveItemId(tradePoolId, key);
        return (TradePoolX_ReserveItemState) getCurrentSession().get(AbstractTradePoolX_ReserveItemState.SimpleTradePoolX_ReserveItemState.class, entityId);
    }

    @Transactional(readOnly = true)
    public Iterable<TradePoolX_ReserveItemState> getTradePoolX_ReserveItems(String tradePoolId, org.dddml.support.criterion.Criterion filter, List<String> orders) {
        Criteria criteria = getCurrentSession().createCriteria(AbstractTradePoolX_ReserveItemState.SimpleTradePoolX_ReserveItemState.class);
        org.hibernate.criterion.Junction partIdCondition = org.hibernate.criterion.Restrictions.conjunction()
            .add(org.hibernate.criterion.Restrictions.eq("tradePoolX_ReserveItemId.tradePoolId", tradePoolId))
            ;
        HibernateUtils.criteriaAddFilterAndOrdersAndSetFirstResultAndMaxResults(criteria, filter, orders, 0, Integer.MAX_VALUE);
        return criteria.add(partIdCondition).list();
    }

    @Transactional(readOnly = true)
    public TradePoolX_AmountsItemState getTradePoolX_AmountsItem(String tradePoolId, String key) {
        TradePoolX_AmountsItemId entityId = new TradePoolX_AmountsItemId(tradePoolId, key);
        return (TradePoolX_AmountsItemState) getCurrentSession().get(AbstractTradePoolX_AmountsItemState.SimpleTradePoolX_AmountsItemState.class, entityId);
    }

    @Transactional(readOnly = true)
    public Iterable<TradePoolX_AmountsItemState> getTradePoolX_AmountsItems(String tradePoolId, org.dddml.support.criterion.Criterion filter, List<String> orders) {
        Criteria criteria = getCurrentSession().createCriteria(AbstractTradePoolX_AmountsItemState.SimpleTradePoolX_AmountsItemState.class);
        org.hibernate.criterion.Junction partIdCondition = org.hibernate.criterion.Restrictions.conjunction()
            .add(org.hibernate.criterion.Restrictions.eq("tradePoolX_AmountsItemId.tradePoolId", tradePoolId))
            ;
        HibernateUtils.criteriaAddFilterAndOrdersAndSetFirstResultAndMaxResults(criteria, filter, orders, 0, Integer.MAX_VALUE);
        return criteria.add(partIdCondition).list();
    }


    protected static void addNotDeletedRestriction(Criteria criteria) {
        criteria.add(org.hibernate.criterion.Restrictions.or(
                org.hibernate.criterion.Restrictions.isNull("deleted"),
                org.hibernate.criterion.Restrictions.eq("deleted", false)
        ));
    }

}

