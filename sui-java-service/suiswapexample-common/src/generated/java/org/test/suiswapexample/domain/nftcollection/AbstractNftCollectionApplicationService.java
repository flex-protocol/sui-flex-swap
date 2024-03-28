// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.nftcollection;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;

public abstract class AbstractNftCollectionApplicationService implements NftCollectionApplicationService {

    private EventStore eventStore;

    protected EventStore getEventStore()
    {
        return eventStore;
    }

    private NftCollectionStateRepository stateRepository;

    protected NftCollectionStateRepository getStateRepository() {
        return stateRepository;
    }

    private NftCollectionStateQueryRepository stateQueryRepository;

    protected NftCollectionStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    private AggregateEventListener<NftCollectionAggregate, NftCollectionState> aggregateEventListener;

    public AggregateEventListener<NftCollectionAggregate, NftCollectionState> getAggregateEventListener() {
        return aggregateEventListener;
    }

    public void setAggregateEventListener(AggregateEventListener<NftCollectionAggregate, NftCollectionState> eventListener) {
        this.aggregateEventListener = eventListener;
    }

    public AbstractNftCollectionApplicationService(EventStore eventStore, NftCollectionStateRepository stateRepository, NftCollectionStateQueryRepository stateQueryRepository) {
        this.eventStore = eventStore;
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public NftCollectionState get(String id) {
        NftCollectionState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<NftCollectionState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<NftCollectionState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<NftCollectionState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<NftCollectionState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public NftCollectionEvent getEvent(String collectionType, long version) {
        NftCollectionEvent e = (NftCollectionEvent)getEventStore().getEvent(toEventStoreAggregateId(collectionType), version);
        if (e != null) {
            ((NftCollectionEvent.SqlNftCollectionEvent)e).setEventReadOnly(true); 
        } else if (version == -1) {
            return getEvent(collectionType, 0);
        }
        return e;
    }

    public NftCollectionState getHistoryState(String collectionType, long version) {
        EventStream eventStream = getEventStore().loadEventStream(AbstractNftCollectionEvent.class, toEventStoreAggregateId(collectionType), version - 1);
        return new AbstractNftCollectionState.SimpleNftCollectionState(eventStream.getEvents());
    }

    public NftCollectionSubtypeState getNftCollectionSubtype(String nftCollectionCollectionType, String name) {
        return getStateQueryRepository().getNftCollectionSubtype(nftCollectionCollectionType, name);
    }

    public Iterable<NftCollectionSubtypeState> getNftCollectionSubtypes(String nftCollectionCollectionType, Criterion filter, List<String> orders) {
        return getStateQueryRepository().getNftCollectionSubtypes(nftCollectionCollectionType, filter, orders);
    }


    public NftCollectionAggregate getNftCollectionAggregate(NftCollectionState state) {
        return new AbstractNftCollectionAggregate.SimpleNftCollectionAggregate(state);
    }

    public EventStoreAggregateId toEventStoreAggregateId(String aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(NftCollectionCommand c, Consumer<NftCollectionAggregate> action) {
        String aggregateId = c.getCollectionType();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        NftCollectionState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        NftCollectionAggregate aggregate = getNftCollectionAggregate(state);
        aggregate.throwOnInvalidStateTransition(c);
        action.accept(aggregate);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? NftCollectionState.VERSION_NULL : c.getOffChainVersion(), aggregate, state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, NftCollectionAggregate aggregate, NftCollectionState state) {
        getEventStore().appendEvents(eventStoreAggregateId, version, 
            aggregate.getChanges(), (events) -> { 
                getStateRepository().save(state); 
            });
        if (aggregateEventListener != null) {
            aggregateEventListener.eventAppended(new AggregateEvent<>(aggregate, state, aggregate.getChanges()));
        }
    }

    protected boolean isDuplicateCommand(NftCollectionCommand command, EventStoreAggregateId eventStoreAggregateId, NftCollectionState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(NftCollectionState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() > command.getOffChainVersion()) {
            Event lastEvent = getEventStore().getEvent(AbstractNftCollectionEvent.class, eventStoreAggregateId, command.getOffChainVersion());
            if (lastEvent != null && lastEvent instanceof AbstractEvent
               && command.getCommandId() != null && command.getCommandId().equals(((AbstractEvent) lastEvent).getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    public static class SimpleNftCollectionApplicationService extends AbstractNftCollectionApplicationService {
        public SimpleNftCollectionApplicationService(EventStore eventStore, NftCollectionStateRepository stateRepository, NftCollectionStateQueryRepository stateQueryRepository)
        {
            super(eventStore, stateRepository, stateQueryRepository);
        }
    }

}

