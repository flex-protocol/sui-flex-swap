// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tradepool;

import java.util.*;
import java.math.*;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;
import org.test.suiswapexample.domain.tradepool.TradePoolX_ReserveItemEvent.*;

public abstract class AbstractTradePoolX_ReserveItemState implements TradePoolX_ReserveItemState.SqlTradePoolX_ReserveItemState {

    private TradePoolX_ReserveItemId tradePoolX_ReserveItemId = new TradePoolX_ReserveItemId();

    public TradePoolX_ReserveItemId getTradePoolX_ReserveItemId() {
        return this.tradePoolX_ReserveItemId;
    }

    public void setTradePoolX_ReserveItemId(TradePoolX_ReserveItemId tradePoolX_ReserveItemId) {
        this.tradePoolX_ReserveItemId = tradePoolX_ReserveItemId;
    }

    private transient TradePoolState tradePoolState;

    public TradePoolState getTradePoolState() {
        return tradePoolState;
    }

    public void setTradePoolState(TradePoolState s) {
        tradePoolState = s;
    }
    
    private TradePoolState protectedTradePoolState;

    protected TradePoolState getProtectedTradePoolState() {
        return protectedTradePoolState;
    }

    protected void setProtectedTradePoolState(TradePoolState protectedTradePoolState) {
        this.protectedTradePoolState = protectedTradePoolState;
    }

    public String getTradePoolId() {
        return this.getTradePoolX_ReserveItemId().getTradePoolId();
    }
        
    public void setTradePoolId(String tradePoolId) {
        this.getTradePoolX_ReserveItemId().setTradePoolId(tradePoolId);
    }

    public String getKey() {
        return this.getTradePoolX_ReserveItemId().getKey();
    }
        
    public void setKey(String key) {
        this.getTradePoolX_ReserveItemId().setKey(key);
    }

    private java.util.Map<String, Object> value;

    public java.util.Map<String, Object> getValue() {
        return this.value;
    }

    public void setValue(java.util.Map<String, Object> value) {
        this.value = value;
    }

    private Long offChainVersion;

    public Long getOffChainVersion() {
        return this.offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion) {
        this.offChainVersion = offChainVersion;
    }

    private String createdBy;

    public String getCreatedBy() {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    private Date createdAt;

    public Date getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    private String updatedBy;

    public String getUpdatedBy() {
        return this.updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    private Date updatedAt;

    public Date getUpdatedAt() {
        return this.updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    private Boolean active;

    public Boolean getActive() {
        return this.active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    private Boolean deleted;

    public Boolean getDeleted() {
        return this.deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public boolean isStateUnsaved() {
        return this.getOffChainVersion() == null;
    }

    private Boolean stateReadOnly;

    public Boolean getStateReadOnly() { return this.stateReadOnly; }

    public void setStateReadOnly(Boolean readOnly) { this.stateReadOnly = readOnly; }

    private boolean forReapplying;

    public boolean getForReapplying() {
        return forReapplying;
    }

    public void setForReapplying(boolean forReapplying) {
        this.forReapplying = forReapplying;
    }


    public AbstractTradePoolX_ReserveItemState() {
        initializeProperties();
    }

    protected void initializeForReapplying() {
        this.forReapplying = true;

        initializeProperties();
    }
    
    protected void initializeProperties() {
    }

    @Override
    public int hashCode() {
        return getKey().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) { return true; }
        if (obj instanceof TradePoolX_ReserveItemState) {
            return Objects.equals(this.getKey(), ((TradePoolX_ReserveItemState)obj).getKey());
        }
        return false;
    }


    public void mutate(Event e) {
        setStateReadOnly(false);
        if (false) { 
            ;
        } else {
            throw new UnsupportedOperationException(String.format("Unsupported event type: %1$s", e.getClass().getName()));
        }
    }

    public void merge(TradePoolX_ReserveItemState s) {
        if (s == this) {
            return;
        }
        this.setValue(s.getValue());
        this.setActive(s.getActive());
    }

    public void save() {
    }

    protected void throwOnWrongEvent(TradePoolX_ReserveItemEvent event) {
        String stateEntityIdTradePoolId = this.getTradePoolX_ReserveItemId().getTradePoolId();
        String eventEntityIdTradePoolId = ((TradePoolX_ReserveItemEvent.SqlTradePoolX_ReserveItemEvent)event).getTradePoolX_ReserveItemEventId().getTradePoolId();
        if (!stateEntityIdTradePoolId.equals(eventEntityIdTradePoolId)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id TradePoolId %1$s in state but entity id TradePoolId %2$s in event", stateEntityIdTradePoolId, eventEntityIdTradePoolId);
        }

        String stateEntityIdKey = this.getTradePoolX_ReserveItemId().getKey();
        String eventEntityIdKey = ((TradePoolX_ReserveItemEvent.SqlTradePoolX_ReserveItemEvent)event).getTradePoolX_ReserveItemEventId().getKey();
        if (!stateEntityIdKey.equals(eventEntityIdKey)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id Key %1$s in state but entity id Key %2$s in event", stateEntityIdKey, eventEntityIdKey);
        }


        if (getForReapplying()) { return; }

    }


    public static class SimpleTradePoolX_ReserveItemState extends AbstractTradePoolX_ReserveItemState {

        public SimpleTradePoolX_ReserveItemState() {
        }

        public static SimpleTradePoolX_ReserveItemState newForReapplying() {
            SimpleTradePoolX_ReserveItemState s = new SimpleTradePoolX_ReserveItemState();
            s.initializeForReapplying();
            return s;
        }

    }



}

