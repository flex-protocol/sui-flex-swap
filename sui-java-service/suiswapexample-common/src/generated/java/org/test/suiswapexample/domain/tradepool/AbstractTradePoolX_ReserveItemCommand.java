// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tradepool;

import java.util.*;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.AbstractCommand;

public abstract class AbstractTradePoolX_ReserveItemCommand extends AbstractCommand implements TradePoolX_ReserveItemCommand {

    private String key;

    public String getKey()
    {
        return this.key;
    }

    public void setKey(String key)
    {
        this.key = key;
    }

    private String tradePoolId;

    public String getTradePoolId()
    {
        return this.tradePoolId;
    }

    public void setTradePoolId(String tradePoolId)
    {
        this.tradePoolId = tradePoolId;
    }


}

