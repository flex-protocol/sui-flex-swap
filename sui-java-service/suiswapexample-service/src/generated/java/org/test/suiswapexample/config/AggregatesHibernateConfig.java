// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.config;

import org.test.suiswapexample.domain.tokenpair.*;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.tokenpair.hibernate.*;
import org.test.suiswapexample.domain.tradepool.*;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.tradepool.hibernate.*;
import org.test.suiswapexample.domain.liquiditytoken.*;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.liquiditytoken.hibernate.*;
import org.test.suiswapexample.domain.exchange.*;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.exchange.hibernate.*;
import org.test.suiswapexample.specialization.AggregateEventListener;
import org.test.suiswapexample.specialization.EventStore;
import org.test.suiswapexample.specialization.IdGenerator;
import org.test.suiswapexample.specialization.ReadOnlyProxyGenerator;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AggregatesHibernateConfig {


    @Bean
    public TokenPairX_ReserveItemEventDao tokenPairX_ReserveItemEventDao(SessionFactory hibernateSessionFactory) {
        HibernateTokenPairX_ReserveItemEventDao dao = new HibernateTokenPairX_ReserveItemEventDao();
        dao.setSessionFactory(hibernateSessionFactory);
        return dao;
    }

    @Bean
    public TokenPairX_AmountsItemEventDao tokenPairX_AmountsItemEventDao(SessionFactory hibernateSessionFactory) {
        HibernateTokenPairX_AmountsItemEventDao dao = new HibernateTokenPairX_AmountsItemEventDao();
        dao.setSessionFactory(hibernateSessionFactory);
        return dao;
    }

    @Bean
    public TokenPairStateRepository tokenPairStateRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateTokenPairStateRepository repository = new HibernateTokenPairStateRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public TokenPairStateQueryRepository tokenPairStateQueryRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateTokenPairStateQueryRepository repository = new HibernateTokenPairStateQueryRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public HibernateTokenPairEventStore tokenPairEventStore(SessionFactory hibernateSessionFactory) {
        HibernateTokenPairEventStore eventStore = new HibernateTokenPairEventStore();
        eventStore.setSessionFactory(hibernateSessionFactory);
        return eventStore;
    }

    @Bean
    public AbstractTokenPairApplicationService.SimpleTokenPairApplicationService tokenPairApplicationService(
            @Qualifier("tokenPairEventStore") EventStore tokenPairEventStore,
            TokenPairStateRepository tokenPairStateRepository,
            TokenPairStateQueryRepository tokenPairStateQueryRepository
    ) {
        AbstractTokenPairApplicationService.SimpleTokenPairApplicationService applicationService = new AbstractTokenPairApplicationService.SimpleTokenPairApplicationService(
                tokenPairEventStore,
                tokenPairStateRepository,
                tokenPairStateQueryRepository
        );
        return applicationService;
    }



    @Bean
    public TradePoolX_ReserveItemEventDao tradePoolX_ReserveItemEventDao(SessionFactory hibernateSessionFactory) {
        HibernateTradePoolX_ReserveItemEventDao dao = new HibernateTradePoolX_ReserveItemEventDao();
        dao.setSessionFactory(hibernateSessionFactory);
        return dao;
    }

    @Bean
    public TradePoolX_AmountsItemEventDao tradePoolX_AmountsItemEventDao(SessionFactory hibernateSessionFactory) {
        HibernateTradePoolX_AmountsItemEventDao dao = new HibernateTradePoolX_AmountsItemEventDao();
        dao.setSessionFactory(hibernateSessionFactory);
        return dao;
    }

    @Bean
    public TradePoolStateRepository tradePoolStateRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateTradePoolStateRepository repository = new HibernateTradePoolStateRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public TradePoolStateQueryRepository tradePoolStateQueryRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateTradePoolStateQueryRepository repository = new HibernateTradePoolStateQueryRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public HibernateTradePoolEventStore tradePoolEventStore(SessionFactory hibernateSessionFactory) {
        HibernateTradePoolEventStore eventStore = new HibernateTradePoolEventStore();
        eventStore.setSessionFactory(hibernateSessionFactory);
        return eventStore;
    }

    @Bean
    public AbstractTradePoolApplicationService.SimpleTradePoolApplicationService tradePoolApplicationService(
            @Qualifier("tradePoolEventStore") EventStore tradePoolEventStore,
            TradePoolStateRepository tradePoolStateRepository,
            TradePoolStateQueryRepository tradePoolStateQueryRepository
    ) {
        AbstractTradePoolApplicationService.SimpleTradePoolApplicationService applicationService = new AbstractTradePoolApplicationService.SimpleTradePoolApplicationService(
                tradePoolEventStore,
                tradePoolStateRepository,
                tradePoolStateQueryRepository
        );
        return applicationService;
    }



    @Bean
    public LiquidityTokenStateRepository liquidityTokenStateRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateLiquidityTokenStateRepository repository = new HibernateLiquidityTokenStateRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public LiquidityTokenStateQueryRepository liquidityTokenStateQueryRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateLiquidityTokenStateQueryRepository repository = new HibernateLiquidityTokenStateQueryRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public HibernateLiquidityTokenEventStore liquidityTokenEventStore(SessionFactory hibernateSessionFactory) {
        HibernateLiquidityTokenEventStore eventStore = new HibernateLiquidityTokenEventStore();
        eventStore.setSessionFactory(hibernateSessionFactory);
        return eventStore;
    }

    @Bean
    public AbstractLiquidityTokenApplicationService.SimpleLiquidityTokenApplicationService liquidityTokenApplicationService(
            @Qualifier("liquidityTokenEventStore") EventStore liquidityTokenEventStore,
            LiquidityTokenStateRepository liquidityTokenStateRepository,
            LiquidityTokenStateQueryRepository liquidityTokenStateQueryRepository
    ) {
        AbstractLiquidityTokenApplicationService.SimpleLiquidityTokenApplicationService applicationService = new AbstractLiquidityTokenApplicationService.SimpleLiquidityTokenApplicationService(
                liquidityTokenEventStore,
                liquidityTokenStateRepository,
                liquidityTokenStateQueryRepository
        );
        return applicationService;
    }



    @Bean
    public ExchangeStateRepository exchangeStateRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateExchangeStateRepository repository = new HibernateExchangeStateRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public ExchangeStateQueryRepository exchangeStateQueryRepository(
            SessionFactory hibernateSessionFactory,
            ReadOnlyProxyGenerator stateReadOnlyProxyGenerator
    ) {
        HibernateExchangeStateQueryRepository repository = new HibernateExchangeStateQueryRepository();
        repository.setSessionFactory(hibernateSessionFactory);
        repository.setReadOnlyProxyGenerator(stateReadOnlyProxyGenerator);
        return repository;
    }

    @Bean
    public HibernateExchangeEventStore exchangeEventStore(SessionFactory hibernateSessionFactory) {
        HibernateExchangeEventStore eventStore = new HibernateExchangeEventStore();
        eventStore.setSessionFactory(hibernateSessionFactory);
        return eventStore;
    }

    @Bean
    public AbstractExchangeApplicationService.SimpleExchangeApplicationService exchangeApplicationService(
            @Qualifier("exchangeEventStore") EventStore exchangeEventStore,
            ExchangeStateRepository exchangeStateRepository,
            ExchangeStateQueryRepository exchangeStateQueryRepository
    ) {
        AbstractExchangeApplicationService.SimpleExchangeApplicationService applicationService = new AbstractExchangeApplicationService.SimpleExchangeApplicationService(
                exchangeEventStore,
                exchangeStateRepository,
                exchangeStateQueryRepository
        );
        return applicationService;
    }


}
