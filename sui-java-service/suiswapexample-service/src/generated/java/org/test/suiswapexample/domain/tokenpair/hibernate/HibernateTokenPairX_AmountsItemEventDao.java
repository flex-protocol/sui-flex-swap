// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair.hibernate;

import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.hibernate.*;
import org.hibernate.criterion.*;
import org.test.suiswapexample.domain.tokenpair.*;
import org.test.suiswapexample.specialization.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateTokenPairX_AmountsItemEventDao implements TokenPairX_AmountsItemEventDao {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }

    @Override
    public void save(TokenPairX_AmountsItemEvent e)
    {
        getCurrentSession().save(e);
        if (e instanceof Saveable)
        {
            Saveable saveable = (Saveable) e;
            saveable.save();
        }
    }


    @Transactional(readOnly = true)
    @Override
    public Iterable<TokenPairX_AmountsItemEvent> findByTokenPairEventId(TokenPairEventId tokenPairEventId)
    {
        Criteria criteria = getCurrentSession().createCriteria(AbstractTokenPairX_AmountsItemEvent.class);
        Junction partIdCondition = Restrictions.conjunction()
            .add(Restrictions.eq("tokenPairX_AmountsItemEventId.tokenPairId", tokenPairEventId.getId()))
            .add(Restrictions.eq("tokenPairX_AmountsItemEventId.version", tokenPairEventId.getVersion()))
            ;
        return criteria.add(partIdCondition).list();
    }

}

