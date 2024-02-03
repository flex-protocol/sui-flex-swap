// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.sellpool;

import java.util.List;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.Event;
import org.test.suiswapexample.domain.Command;

public interface SellPoolAggregate {
    SellPoolState getState();

    List<Event> getChanges();

    void updateExchangeRate(String liquidityToken, BigInteger exchangeRateNumerator, BigInteger exchangeRateDenominator, BigInteger priceDeltaX_Amount, BigInteger priceDeltaNumerator, BigInteger priceDeltaDenominator, Long offChainVersion, String commandId, String requesterId, SellPoolCommands.UpdateExchangeRate c);

    void destroy(String liquidityToken, Long offChainVersion, String commandId, String requesterId, SellPoolCommands.Destroy c);

    void throwOnInvalidStateTransition(Command c);
}

