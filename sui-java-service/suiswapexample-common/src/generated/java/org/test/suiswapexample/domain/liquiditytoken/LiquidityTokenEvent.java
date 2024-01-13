// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.liquiditytoken;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.Event;

public interface LiquidityTokenEvent extends Event, SuiEventEnvelope, SuiMoveEvent, HasStatus {

    interface SqlLiquidityTokenEvent extends LiquidityTokenEvent {
        LiquidityTokenEventId getLiquidityTokenEventId();

        boolean getEventReadOnly();

        void setEventReadOnly(boolean readOnly);
    }

    interface LiquidityTokenMinted extends LiquidityTokenEvent {
        String getX_TokenType();

        void setX_TokenType(String value);

        BigInteger getAmount();

        void setAmount(BigInteger value);

    }

    interface LiquidityTokenDestroyed extends LiquidityTokenEvent {
        BigInteger getAmount();

        void setAmount(BigInteger value);

    }

    interface LiquidityTokenSplit extends LiquidityTokenEvent {
        BigInteger getAmount();

        void setAmount(BigInteger value);

    }

    String getId();

    //void setId(String id);

    BigInteger getVersion();
    
    //void setVersion(BigInteger version);

    String getCreatedBy();

    void setCreatedBy(String createdBy);

    Date getCreatedAt();

    void setCreatedAt(Date createdAt);

    String getCommandId();

    void setCommandId(String commandId);


}

