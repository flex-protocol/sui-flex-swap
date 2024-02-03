// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.exchange.hibernate;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.test.suiswapexample.domain.*;
import org.hibernate.Session;
import org.hibernate.Criteria;
//import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.test.suiswapexample.domain.exchange.*;
import org.test.suiswapexample.specialization.*;
import org.test.suiswapexample.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateExchangeStateRepository implements ExchangeStateRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("Id", "Name", "TokenPairs", "TokenPairX_TokenTypes", "TokenPairY_TokenTypes", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted", "Version"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public ExchangeState get(String id, boolean nullAllowed) {
        ExchangeState.SqlExchangeState state = (ExchangeState.SqlExchangeState)getCurrentSession().get(AbstractExchangeState.SimpleExchangeState.class, id);
        if (!nullAllowed && state == null) {
            state = new AbstractExchangeState.SimpleExchangeState();
            state.setId(id);
        }
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (ExchangeState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{ExchangeState.SqlExchangeState.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    public void save(ExchangeState state) {
        ExchangeState s = state;
        if (getReadOnlyProxyGenerator() != null) {
            s = (ExchangeState) getReadOnlyProxyGenerator().getTarget(state);
        }
        if(s.getOffChainVersion() == null) {
            getCurrentSession().save(s);
        } else {
            getCurrentSession().update(s);
        }

        if (s instanceof Saveable)
        {
            Saveable saveable = (Saveable) s;
            saveable.save();
        }
        getCurrentSession().flush();
    }

    public void merge(ExchangeState detached) {
        ExchangeState persistent = getCurrentSession().get(AbstractExchangeState.SimpleExchangeState.class, detached.getId());
        if (persistent != null) {
            merge(persistent, detached);
            getCurrentSession().save(persistent);
        } else {
            getCurrentSession().save(detached);
        }
        getCurrentSession().flush();
    }

    private void merge(ExchangeState persistent, ExchangeState detached) {
        ((AbstractExchangeState) persistent).merge(detached);
    }

}

