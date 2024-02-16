// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.exchange;

import java.util.List;
import java.util.Date;
import java.math.BigInteger;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.Event;
import org.test.suiswapexample.domain.Command;

public interface ExchangeAggregate {
    ExchangeState getState();

    List<Event> getChanges();

    void addTokenPair(String tokenPairId, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.AddTokenPair c);

    void addTradePool(String tradePoolId, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.AddTradePool c);

    void addSellPool(String sellPoolId, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.AddSellPool c);

    void addBuyPool(String buyPoolId, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.AddBuyPool c);

    void update(String name, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.Update c);

    void throwOnInvalidStateTransition(Command c);
}

