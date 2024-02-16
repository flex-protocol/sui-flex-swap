// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.repository;

import org.test.suiswapexample.domain.tradepool.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface TradePoolEventRepository extends JpaRepository<AbstractTradePoolEvent, TradePoolEventId> {

    List<AbstractTradePoolEvent> findByStatusIsNull();

    AbstractTradePoolEvent.TradePoolInitialized findFirstTradePoolInitializedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.SellPoolInitialized findFirstSellPoolInitializedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.BuyPoolInitialized findFirstBuyPoolInitializedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolExchangeRateUpdated findFirstPoolExchangeRateUpdatedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolXTokenAdded findFirstPoolXTokenAddedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolXTokenRemoved findFirstPoolXTokenRemovedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolYReserveDeposited findFirstPoolYReserveDepositedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolYReserveWithdrawn findFirstPoolYReserveWithdrawnByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolDestroyed findFirstPoolDestroyedByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolYSwappedForX findFirstPoolYSwappedForXByOrderBySuiTimestampDesc();

    AbstractTradePoolEvent.PoolXSwappedForY findFirstPoolXSwappedForYByOrderBySuiTimestampDesc();

}
