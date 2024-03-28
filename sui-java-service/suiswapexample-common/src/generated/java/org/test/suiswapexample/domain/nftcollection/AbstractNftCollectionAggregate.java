// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.nftcollection;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;

public abstract class AbstractNftCollectionAggregate extends AbstractAggregate implements NftCollectionAggregate {
    private NftCollectionState.MutableNftCollectionState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractNftCollectionAggregate(NftCollectionState state) {
        this.state = (NftCollectionState.MutableNftCollectionState)state;
    }

    public NftCollectionState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        NftCollectionCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleNftCollectionAggregate extends AbstractNftCollectionAggregate {
        public SimpleNftCollectionAggregate(NftCollectionState state) {
            super(state);
        }

    }

}

