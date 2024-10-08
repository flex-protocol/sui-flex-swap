// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair.hibernate;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.hibernate.Session;
import org.hibernate.Criteria;
//import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.test.suiswapexample.domain.tokenpair.*;
import org.test.suiswapexample.specialization.*;
import org.test.suiswapexample.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateTokenPairStateRepository implements TokenPairStateRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("Id", "X_Reserve", "Y_Reserve", "TotalLiquidity", "FeeNumerator", "FeeDenominator", "Version", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted", "X_TokenType", "Y_TokenType"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public TokenPairState get(String id, boolean nullAllowed) {
        TokenPairState.SqlTokenPairState state = (TokenPairState.SqlTokenPairState)getCurrentSession().get(AbstractTokenPairState.SimpleTokenPairState.class, id);
        if (!nullAllowed && state == null) {
            state = new AbstractTokenPairState.SimpleTokenPairState();
            state.setId(id);
        }
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (TokenPairState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{TokenPairState.SqlTokenPairState.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    public void save(TokenPairState state) {
        TokenPairState s = state;
        if (getReadOnlyProxyGenerator() != null) {
            s = (TokenPairState) getReadOnlyProxyGenerator().getTarget(state);
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

    public void merge(TokenPairState detached) {
        TokenPairState persistent = getCurrentSession().get(AbstractTokenPairState.SimpleTokenPairState.class, detached.getId());
        if (persistent != null) {
            merge(persistent, detached);
            getCurrentSession().save(persistent);
        } else {
            getCurrentSession().save(detached);
        }
        getCurrentSession().flush();
    }

    private void merge(TokenPairState persistent, TokenPairState detached) {
        ((AbstractTokenPairState) persistent).merge(detached);
    }

}

