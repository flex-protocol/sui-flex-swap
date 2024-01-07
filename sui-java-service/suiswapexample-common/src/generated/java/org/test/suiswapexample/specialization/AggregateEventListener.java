package org.test.suiswapexample.specialization;


public interface AggregateEventListener<TA, TS> {

    void eventAppended(AggregateEvent<TA, TS> e);

}
