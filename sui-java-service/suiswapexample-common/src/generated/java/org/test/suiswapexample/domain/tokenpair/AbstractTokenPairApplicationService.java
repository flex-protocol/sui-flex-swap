// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;

public abstract class AbstractTokenPairApplicationService implements TokenPairApplicationService {

    private EventStore eventStore;

    protected EventStore getEventStore()
    {
        return eventStore;
    }

    private TokenPairStateRepository stateRepository;

    protected TokenPairStateRepository getStateRepository() {
        return stateRepository;
    }

    private TokenPairStateQueryRepository stateQueryRepository;

    protected TokenPairStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    private AggregateEventListener<TokenPairAggregate, TokenPairState> aggregateEventListener;

    public AggregateEventListener<TokenPairAggregate, TokenPairState> getAggregateEventListener() {
        return aggregateEventListener;
    }

    public void setAggregateEventListener(AggregateEventListener<TokenPairAggregate, TokenPairState> eventListener) {
        this.aggregateEventListener = eventListener;
    }

    public AbstractTokenPairApplicationService(EventStore eventStore, TokenPairStateRepository stateRepository, TokenPairStateQueryRepository stateQueryRepository) {
        this.eventStore = eventStore;
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public TokenPairState get(String id) {
        TokenPairState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<TokenPairState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<TokenPairState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<TokenPairState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<TokenPairState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public TokenPairEvent getEvent(String id, long version) {
        TokenPairEvent e = (TokenPairEvent)getEventStore().getEvent(toEventStoreAggregateId(id), version);
        if (e != null) {
            ((TokenPairEvent.SqlTokenPairEvent)e).setEventReadOnly(true); 
        } else if (version == -1) {
            return getEvent(id, 0);
        }
        return e;
    }

    public TokenPairState getHistoryState(String id, long version) {
        EventStream eventStream = getEventStore().loadEventStream(AbstractTokenPairEvent.class, toEventStoreAggregateId(id), version - 1);
        return new AbstractTokenPairState.SimpleTokenPairState(eventStream.getEvents());
    }


    public TokenPairAggregate getTokenPairAggregate(TokenPairState state) {
        return new AbstractTokenPairAggregate.SimpleTokenPairAggregate(state);
    }

    public EventStoreAggregateId toEventStoreAggregateId(String aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(TokenPairCommand c, Consumer<TokenPairAggregate> action) {
        String aggregateId = c.getId();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        TokenPairState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        TokenPairAggregate aggregate = getTokenPairAggregate(state);
        aggregate.throwOnInvalidStateTransition(c);
        action.accept(aggregate);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? TokenPairState.VERSION_NULL : c.getOffChainVersion(), aggregate, state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, TokenPairAggregate aggregate, TokenPairState state) {
        getEventStore().appendEvents(eventStoreAggregateId, version, 
            aggregate.getChanges(), (events) -> { 
                getStateRepository().save(state); 
            });
        if (aggregateEventListener != null) {
            aggregateEventListener.eventAppended(new AggregateEvent<>(aggregate, state, aggregate.getChanges()));
        }
    }

    protected boolean isDuplicateCommand(TokenPairCommand command, EventStoreAggregateId eventStoreAggregateId, TokenPairState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(TokenPairState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() > command.getOffChainVersion()) {
            Event lastEvent = getEventStore().getEvent(AbstractTokenPairEvent.class, eventStoreAggregateId, command.getOffChainVersion());
            if (lastEvent != null && lastEvent instanceof AbstractEvent
               && command.getCommandId() != null && command.getCommandId().equals(((AbstractEvent) lastEvent).getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    public static class SimpleTokenPairApplicationService extends AbstractTokenPairApplicationService {
        public SimpleTokenPairApplicationService(EventStore eventStore, TokenPairStateRepository stateRepository, TokenPairStateQueryRepository stateQueryRepository)
        {
            super(eventStore, stateRepository, stateQueryRepository);
        }
    }

}

