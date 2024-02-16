// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.exchange;

import java.util.*;
import java.math.*;
import java.util.Date;
import java.math.BigInteger;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.Event;

public interface ExchangeState extends VersionedSuiMoveObject
{
    Long VERSION_ZERO = 0L;

    Long VERSION_NULL = VERSION_ZERO - 1;

    String getId();

    String getName();

    Long getOffChainVersion();

    String getCreatedBy();

    Date getCreatedAt();

    String getUpdatedBy();

    Date getUpdatedAt();

    Boolean getActive();

    Boolean getDeleted();

    List<String> getTokenPairs();

    List<String> getTokenPairX_TokenTypes();

    List<String> getTokenPairY_TokenTypes();

    List<String> getTradePools();

    List<String> getTradePoolX_TokenTypes();

    List<String> getTradePoolY_TokenTypes();

    List<String> getSellPools();

    List<String> getSellPoolX_TokenTypes();

    List<String> getSellPoolY_TokenTypes();

    List<String> getBuyPools();

    List<String> getBuyPoolX_TokenTypes();

    List<String> getBuyPoolY_TokenTypes();

    interface MutableExchangeState extends ExchangeState, VersionedSuiMoveObject.MutableVersionedSuiMoveObject {
        void setId(String id);

        void setName(String name);

        void setOffChainVersion(Long offChainVersion);

        void setCreatedBy(String createdBy);

        void setCreatedAt(Date createdAt);

        void setUpdatedBy(String updatedBy);

        void setUpdatedAt(Date updatedAt);

        void setActive(Boolean active);

        void setDeleted(Boolean deleted);

        void setTokenPairs(List<String> tokenPairs);

        void setTokenPairX_TokenTypes(List<String> tokenPairX_TokenTypes);

        void setTokenPairY_TokenTypes(List<String> tokenPairY_TokenTypes);

        void setTradePools(List<String> tradePools);

        void setTradePoolX_TokenTypes(List<String> tradePoolX_TokenTypes);

        void setTradePoolY_TokenTypes(List<String> tradePoolY_TokenTypes);

        void setSellPools(List<String> sellPools);

        void setSellPoolX_TokenTypes(List<String> sellPoolX_TokenTypes);

        void setSellPoolY_TokenTypes(List<String> sellPoolY_TokenTypes);

        void setBuyPools(List<String> buyPools);

        void setBuyPoolX_TokenTypes(List<String> buyPoolX_TokenTypes);

        void setBuyPoolY_TokenTypes(List<String> buyPoolY_TokenTypes);


        void mutate(Event e);

        //void when(ExchangeEvent.ExchangeStateCreated e);

        //void when(ExchangeEvent.ExchangeStateMergePatched e);

        //void when(ExchangeEvent.ExchangeStateDeleted e);
    }

    interface SqlExchangeState extends MutableExchangeState {

        boolean isStateUnsaved();

        boolean getForReapplying();
    }
}

