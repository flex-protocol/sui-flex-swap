// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;
import org.test.suiswapexample.domain.tokenpair.TokenPairEvent.*;

public abstract class AbstractTokenPairState implements TokenPairState.SqlTokenPairState {

    private String id;

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    private ObjectTable x_Reserve;

    public ObjectTable getX_Reserve() {
        return this.x_Reserve;
    }

    public void setX_Reserve(ObjectTable x_Reserve) {
        this.x_Reserve = x_Reserve;
    }

    private Table x_Amounts;

    public Table getX_Amounts() {
        return this.x_Amounts;
    }

    public void setX_Amounts(Table x_Amounts) {
        this.x_Amounts = x_Amounts;
    }

    private BigInteger x_TotalAmount;

    public BigInteger getX_TotalAmount() {
        return this.x_TotalAmount;
    }

    public void setX_TotalAmount(BigInteger x_TotalAmount) {
        this.x_TotalAmount = x_TotalAmount;
    }

    private java.math.BigInteger y_Reserve;

    public java.math.BigInteger getY_Reserve() {
        return this.y_Reserve;
    }

    public void setY_Reserve(java.math.BigInteger y_Reserve) {
        this.y_Reserve = y_Reserve;
    }

    private BigInteger totalLiquidity;

    public BigInteger getTotalLiquidity() {
        return this.totalLiquidity;
    }

    public void setTotalLiquidity(BigInteger totalLiquidity) {
        this.totalLiquidity = totalLiquidity;
    }

    private String liquidityTokenId;

    public String getLiquidityTokenId() {
        return this.liquidityTokenId;
    }

    public void setLiquidityTokenId(String liquidityTokenId) {
        this.liquidityTokenId = liquidityTokenId;
    }

    private BigInteger feeNumerator;

    public BigInteger getFeeNumerator() {
        return this.feeNumerator;
    }

    public void setFeeNumerator(BigInteger feeNumerator) {
        this.feeNumerator = feeNumerator;
    }

    private BigInteger feeDenominator;

    public BigInteger getFeeDenominator() {
        return this.feeDenominator;
    }

    public void setFeeDenominator(BigInteger feeDenominator) {
        this.feeDenominator = feeDenominator;
    }

    private BigInteger version;

    public BigInteger getVersion() {
        return this.version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
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

    private String x_TokenType;

    public String getX_TokenType() {
        return this.x_TokenType;
    }

    public void setX_TokenType(String x_TokenType) {
        this.x_TokenType = x_TokenType;
    }

    private String y_TokenType;

    public String getY_TokenType() {
        return this.y_TokenType;
    }

    public void setY_TokenType(String y_TokenType) {
        this.y_TokenType = y_TokenType;
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

    public AbstractTokenPairState(List<Event> events) {
        initializeForReapplying();
        if (events != null && events.size() > 0) {
            this.setId(((TokenPairEvent.SqlTokenPairEvent) events.get(0)).getTokenPairEventId().getId());
            for (Event e : events) {
                mutate(e);
                this.setOffChainVersion((this.getOffChainVersion() == null ? TokenPairState.VERSION_NULL : this.getOffChainVersion()) + 1);
            }
        }
    }


    public AbstractTokenPairState() {
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
        return getId().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) { return true; }
        if (obj instanceof TokenPairState) {
            return Objects.equals(this.getId(), ((TokenPairState)obj).getId());
        }
        return false;
    }


    public void mutate(Event e) {
        setStateReadOnly(false);
        if (false) { 
            ;
        } else if (e instanceof AbstractTokenPairEvent.TokenPairDestroyed) {
            when((AbstractTokenPairEvent.TokenPairDestroyed)e);
        } else if (e instanceof AbstractTokenPairEvent.FeeRateUpdated) {
            when((AbstractTokenPairEvent.FeeRateUpdated)e);
        } else {
            throw new UnsupportedOperationException(String.format("Unsupported event type: %1$s", e.getClass().getName()));
        }
    }

    public void merge(TokenPairState s) {
        if (s == this) {
            return;
        }
        this.setX_Reserve(s.getX_Reserve());
        this.setX_Amounts(s.getX_Amounts());
        this.setX_TotalAmount(s.getX_TotalAmount());
        this.setY_Reserve(s.getY_Reserve());
        this.setTotalLiquidity(s.getTotalLiquidity());
        this.setLiquidityTokenId(s.getLiquidityTokenId());
        this.setFeeNumerator(s.getFeeNumerator());
        this.setFeeDenominator(s.getFeeDenominator());
        this.setVersion(s.getVersion());
        this.setActive(s.getActive());
        this.setX_TokenType(s.getX_TokenType());
        this.setY_TokenType(s.getY_TokenType());
    }

    public void when(AbstractTokenPairEvent.LiquidityAdded e) {
        throwOnWrongEvent(e);

        String liquidityTokenId = e.getLiquidityTokenId();
        String LiquidityTokenId = liquidityTokenId;
        BigInteger x_Amount = e.getX_Amount();
        BigInteger X_Amount = x_Amount;
        String provider = e.getProvider();
        String Provider = provider;
        String x_TokenType = e.getX_TokenType();
        String X_TokenType = x_TokenType;
        String y_TokenType = e.getY_TokenType();
        String Y_TokenType = y_TokenType;
        BigInteger y_Amount = e.getY_Amount();
        BigInteger Y_Amount = y_Amount;
        BigInteger liquidityAmount = e.getLiquidityAmount();
        BigInteger LiquidityAmount = liquidityAmount;
        String x_Id = e.getX_Id();
        String X_Id = x_Id;
        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        TokenPairState updatedTokenPairState = (TokenPairState) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.AddLiquidityLogic",
                    "mutate",
                    new Class[]{TokenPairState.class, String.class, BigInteger.class, String.class, String.class, String.class, BigInteger.class, BigInteger.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, liquidityTokenId, x_Amount, provider, x_TokenType, y_TokenType, y_Amount, liquidityAmount, x_Id, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class AddLiquidityLogic {
//    public static TokenPairState mutate(TokenPairState tokenPairState, String liquidityTokenId, BigInteger x_Amount, String provider, String x_TokenType, String y_TokenType, BigInteger y_Amount, BigInteger liquidityAmount, String x_Id, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<TokenPairState, TokenPairState.MutableTokenPairState> mutationContext) {
//    }
//}

        if (this != updatedTokenPairState) { merge(updatedTokenPairState); } //else do nothing

    }

    public void when(AbstractTokenPairEvent.LiquidityRemoved e) {
        throwOnWrongEvent(e);

        String liquidityTokenId = e.getLiquidityTokenId();
        String LiquidityTokenId = liquidityTokenId;
        String x_Id = e.getX_Id();
        String X_Id = x_Id;
        String provider = e.getProvider();
        String Provider = provider;
        String x_TokenType = e.getX_TokenType();
        String X_TokenType = x_TokenType;
        String y_TokenType = e.getY_TokenType();
        String Y_TokenType = y_TokenType;
        BigInteger x_Amount = e.getX_Amount();
        BigInteger X_Amount = x_Amount;
        BigInteger y_Amount = e.getY_Amount();
        BigInteger Y_Amount = y_Amount;
        BigInteger liquidityAmount = e.getLiquidityAmount();
        BigInteger LiquidityAmount = liquidityAmount;
        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        TokenPairState updatedTokenPairState = (TokenPairState) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.RemoveLiquidityLogic",
                    "mutate",
                    new Class[]{TokenPairState.class, String.class, String.class, String.class, String.class, String.class, BigInteger.class, BigInteger.class, BigInteger.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, liquidityTokenId, x_Id, provider, x_TokenType, y_TokenType, x_Amount, y_Amount, liquidityAmount, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class RemoveLiquidityLogic {
//    public static TokenPairState mutate(TokenPairState tokenPairState, String liquidityTokenId, String x_Id, String provider, String x_TokenType, String y_TokenType, BigInteger x_Amount, BigInteger y_Amount, BigInteger liquidityAmount, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<TokenPairState, TokenPairState.MutableTokenPairState> mutationContext) {
//    }
//}

        if (this != updatedTokenPairState) { merge(updatedTokenPairState); } //else do nothing

    }

    public void when(AbstractTokenPairEvent.TokenPairDestroyed e) {
        throwOnWrongEvent(e);

        String liquidityTokenId = e.getLiquidityTokenId();
        String LiquidityTokenId = liquidityTokenId;
        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        TokenPairState updatedTokenPairState = (TokenPairState) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.DestroyLogic",
                    "mutate",
                    new Class[]{TokenPairState.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, liquidityTokenId, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class DestroyLogic {
//    public static TokenPairState mutate(TokenPairState tokenPairState, String liquidityTokenId, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<TokenPairState, TokenPairState.MutableTokenPairState> mutationContext) {
//    }
//}

        if (this != updatedTokenPairState) { merge(updatedTokenPairState); } //else do nothing

    }

    public void when(AbstractTokenPairEvent.FeeRateUpdated e) {
        throwOnWrongEvent(e);

        String liquidityTokenId = e.getLiquidityTokenId();
        String LiquidityTokenId = liquidityTokenId;
        BigInteger feeNumerator = e.getFeeNumerator();
        BigInteger FeeNumerator = feeNumerator;
        BigInteger feeDenominator = e.getFeeDenominator();
        BigInteger FeeDenominator = feeDenominator;
        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        TokenPairState updatedTokenPairState = (TokenPairState) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.UpdateFeeRateLogic",
                    "mutate",
                    new Class[]{TokenPairState.class, String.class, BigInteger.class, BigInteger.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, liquidityTokenId, feeNumerator, feeDenominator, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class UpdateFeeRateLogic {
//    public static TokenPairState mutate(TokenPairState tokenPairState, String liquidityTokenId, BigInteger feeNumerator, BigInteger feeDenominator, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<TokenPairState, TokenPairState.MutableTokenPairState> mutationContext) {
//    }
//}

        if (this != updatedTokenPairState) { merge(updatedTokenPairState); } //else do nothing

    }

    public void save() {
    }

    protected void throwOnWrongEvent(TokenPairEvent event) {
        String stateEntityId = this.getId(); // Aggregate Id
        String eventEntityId = ((TokenPairEvent.SqlTokenPairEvent)event).getTokenPairEventId().getId(); // EntityBase.Aggregate.GetEventIdPropertyIdName();
        if (!stateEntityId.equals(eventEntityId)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id %1$s in state but entity id %2$s in event", stateEntityId, eventEntityId);
        }


        Long stateVersion = this.getOffChainVersion();

    }


    public static class SimpleTokenPairState extends AbstractTokenPairState {

        public SimpleTokenPairState() {
        }

        public SimpleTokenPairState(List<Event> events) {
            super(events);
        }

        public static SimpleTokenPairState newForReapplying() {
            SimpleTokenPairState s = new SimpleTokenPairState();
            s.initializeForReapplying();
            return s;
        }

    }



}

