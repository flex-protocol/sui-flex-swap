// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.taskservice;

import org.test.suiswapexample.sui.contract.service.BuyPoolEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class PullBuyPoolEventsTaskService {

    @Autowired
    private BuyPoolEventService buyPoolEventService;

    @Scheduled(fixedDelayString = "${sui.contract.pull-buy-pool-events.buy-pool-initialized.fixed-delay:5000}")
    public void pullBuyPoolInitializedEvents() {
        buyPoolEventService.pullBuyPoolInitializedEvents();
    }

    @Scheduled(fixedDelayString = "${sui.contract.pull-buy-pool-events.buy-pool-exchange-rate-updated.fixed-delay:5000}")
    public void pullBuyPoolExchangeRateUpdatedEvents() {
        buyPoolEventService.pullBuyPoolExchangeRateUpdatedEvents();
    }

    @Scheduled(fixedDelayString = "${sui.contract.pull-buy-pool-events.buy-pool-x-token-removed.fixed-delay:5000}")
    public void pullBuyPoolXTokenRemovedEvents() {
        buyPoolEventService.pullBuyPoolXTokenRemovedEvents();
    }

    @Scheduled(fixedDelayString = "${sui.contract.pull-buy-pool-events.buy-pool-y-reserve-withdrawn.fixed-delay:5000}")
    public void pullBuyPoolYReserveWithdrawnEvents() {
        buyPoolEventService.pullBuyPoolYReserveWithdrawnEvents();
    }

    @Scheduled(fixedDelayString = "${sui.contract.pull-buy-pool-events.buy-pool-destroyed.fixed-delay:5000}")
    public void pullBuyPoolDestroyedEvents() {
        buyPoolEventService.pullBuyPoolDestroyedEvents();
    }

    @Scheduled(fixedDelayString = "${sui.contract.pull-buy-pool-events.buy-pool-x-swapped-for-y.fixed-delay:5000}")
    public void pullBuyPoolXSwappedForYEvents() {
        buyPoolEventService.pullBuyPoolXSwappedForYEvents();
    }

}
