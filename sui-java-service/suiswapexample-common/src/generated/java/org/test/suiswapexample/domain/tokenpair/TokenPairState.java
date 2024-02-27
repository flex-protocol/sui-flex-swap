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
import org.test.suiswapexample.specialization.Event;

public interface TokenPairState extends VersionedSuiMoveObject
{
    Long VERSION_ZERO = 0L;

    Long VERSION_NULL = VERSION_ZERO - 1;

    String getId();

    ObjectTable getX_Reserve();

    Table getX_Amounts();

    BigInteger getX_TotalAmount();

    java.math.BigInteger getY_Reserve();

    BigInteger getTotalLiquidity();

    String getLiquidityTokenId();

    BigInteger getFeeNumerator();

    BigInteger getFeeDenominator();

    Long getOffChainVersion();

    String getCreatedBy();

    Date getCreatedAt();

    String getUpdatedBy();

    Date getUpdatedAt();

    Boolean getActive();

    Boolean getDeleted();

    String getX_TokenType();

    String getY_TokenType();

    EntityStateCollection<String, TokenPairX_ReserveItemState> getTokenPairX_ReserveItems();

    EntityStateCollection<String, TokenPairX_AmountsItemState> getTokenPairX_AmountsItems();

    interface MutableTokenPairState extends TokenPairState, VersionedSuiMoveObject.MutableVersionedSuiMoveObject {
        void setId(String id);

        void setX_Reserve(ObjectTable x_Reserve);

        void setX_Amounts(Table x_Amounts);

        void setX_TotalAmount(BigInteger x_TotalAmount);

        void setY_Reserve(java.math.BigInteger y_Reserve);

        void setTotalLiquidity(BigInteger totalLiquidity);

        void setLiquidityTokenId(String liquidityTokenId);

        void setFeeNumerator(BigInteger feeNumerator);

        void setFeeDenominator(BigInteger feeDenominator);

        void setOffChainVersion(Long offChainVersion);

        void setCreatedBy(String createdBy);

        void setCreatedAt(Date createdAt);

        void setUpdatedBy(String updatedBy);

        void setUpdatedAt(Date updatedAt);

        void setActive(Boolean active);

        void setDeleted(Boolean deleted);

        void setX_TokenType(String x_TokenType);

        void setY_TokenType(String y_TokenType);


        void mutate(Event e);

        //void when(TokenPairEvent.TokenPairStateCreated e);

        //void when(TokenPairEvent.TokenPairStateMergePatched e);

        //void when(TokenPairEvent.TokenPairStateDeleted e);
    }

    interface SqlTokenPairState extends MutableTokenPairState {

        boolean isStateUnsaved();

        boolean getForReapplying();
    }
}

