// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.exchange;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import java.util.Date;
import java.math.BigInteger;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;

public abstract class AbstractExchangeApplicationService implements ExchangeApplicationService {

    private EventStore eventStore;

    protected EventStore getEventStore()
    {
        return eventStore;
    }

    private ExchangeStateRepository stateRepository;

    protected ExchangeStateRepository getStateRepository() {
        return stateRepository;
    }

    private ExchangeStateQueryRepository stateQueryRepository;

    protected ExchangeStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    private AggregateEventListener<ExchangeAggregate, ExchangeState> aggregateEventListener;

    public AggregateEventListener<ExchangeAggregate, ExchangeState> getAggregateEventListener() {
        return aggregateEventListener;
    }

    public void setAggregateEventListener(AggregateEventListener<ExchangeAggregate, ExchangeState> eventListener) {
        this.aggregateEventListener = eventListener;
    }

    public AbstractExchangeApplicationService(EventStore eventStore, ExchangeStateRepository stateRepository, ExchangeStateQueryRepository stateQueryRepository) {
        this.eventStore = eventStore;
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public void when(ExchangeCommands.AddTokenPair c) {
        update(c, ar -> ar.addTokenPair(c.getTokenPairId(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(ExchangeCommands.AddTradePool c) {
        update(c, ar -> ar.addTradePool(c.getTradePoolId(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(ExchangeCommands.AddSellPool c) {
        update(c, ar -> ar.addSellPool(c.getSellPoolId(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(ExchangeCommands.AddBuyPool c) {
        update(c, ar -> ar.addBuyPool(c.getBuyPoolId(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(ExchangeCommands.Update c) {
        update(c, ar -> ar.update(c.getName(), c.getUpdateTokenPairs(), c.getTokenPairs(), c.getTokenPairX_TokenTypes(), c.getTokenPairY_TokenTypes(), c.getUpdateTradePools(), c.getTradePools(), c.getTradePoolX_TokenTypes(), c.getTradePoolY_TokenTypes(), c.getUpdateSellPools(), c.getSellPools(), c.getSellPoolX_TokenTypes(), c.getSellPoolY_TokenTypes(), c.getUpdateBuyPools(), c.getBuyPools(), c.getBuyPoolX_TokenTypes(), c.getBuyPoolY_TokenTypes(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public ExchangeState get(String id) {
        ExchangeState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<ExchangeState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<ExchangeState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<ExchangeState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<ExchangeState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public ExchangeEvent getEvent(String id, long version) {
        ExchangeEvent e = (ExchangeEvent)getEventStore().getEvent(toEventStoreAggregateId(id), version);
        if (e != null) {
            ((ExchangeEvent.SqlExchangeEvent)e).setEventReadOnly(true); 
        } else if (version == -1) {
            return getEvent(id, 0);
        }
        return e;
    }

    public ExchangeState getHistoryState(String id, long version) {
        EventStream eventStream = getEventStore().loadEventStream(AbstractExchangeEvent.class, toEventStoreAggregateId(id), version - 1);
        return new AbstractExchangeState.SimpleExchangeState(eventStream.getEvents());
    }


    public ExchangeAggregate getExchangeAggregate(ExchangeState state) {
        return new AbstractExchangeAggregate.SimpleExchangeAggregate(state);
    }

    public EventStoreAggregateId toEventStoreAggregateId(String aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(ExchangeCommand c, Consumer<ExchangeAggregate> action) {
        String aggregateId = c.getId();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        ExchangeState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        ExchangeAggregate aggregate = getExchangeAggregate(state);
        aggregate.throwOnInvalidStateTransition(c);
        action.accept(aggregate);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? ExchangeState.VERSION_NULL : c.getOffChainVersion(), aggregate, state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, ExchangeAggregate aggregate, ExchangeState state) {
        getEventStore().appendEvents(eventStoreAggregateId, version, 
            aggregate.getChanges(), (events) -> { 
                getStateRepository().save(state); 
            });
        if (aggregateEventListener != null) {
            aggregateEventListener.eventAppended(new AggregateEvent<>(aggregate, state, aggregate.getChanges()));
        }
    }

    protected boolean isDuplicateCommand(ExchangeCommand command, EventStoreAggregateId eventStoreAggregateId, ExchangeState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(ExchangeState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() > command.getOffChainVersion()) {
            Event lastEvent = getEventStore().getEvent(AbstractExchangeEvent.class, eventStoreAggregateId, command.getOffChainVersion());
            if (lastEvent != null && lastEvent instanceof AbstractEvent
               && command.getCommandId() != null && command.getCommandId().equals(((AbstractEvent) lastEvent).getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    public static class SimpleExchangeApplicationService extends AbstractExchangeApplicationService {
        public SimpleExchangeApplicationService(EventStore eventStore, ExchangeStateRepository stateRepository, ExchangeStateQueryRepository stateQueryRepository)
        {
            super(eventStore, stateRepository, stateQueryRepository);
        }
    }

}

