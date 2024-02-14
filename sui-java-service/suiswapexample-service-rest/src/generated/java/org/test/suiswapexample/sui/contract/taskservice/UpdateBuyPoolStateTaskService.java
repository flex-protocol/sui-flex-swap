// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.taskservice;

import org.test.suiswapexample.sui.contract.repository.*;
import org.test.suiswapexample.sui.contract.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UpdateBuyPoolStateTaskService {

    @Autowired
    private SuiBuyPoolService suiBuyPoolService;

    @Autowired
    private BuyPoolEventRepository buyPoolEventRepository;

    @Autowired
    private BuyPoolEventService buyPoolEventService;

    @Scheduled(fixedDelayString = "${sui.contract.update-buy-pool-states.fixed-delay:5000}")
    @Transactional
    public void updateBuyPoolStates() {
        buyPoolEventRepository.findByStatusIsNull().forEach(e -> {
            String objectId = e.getId();
            if (BuyPoolEventService.isDeletionCommand(e)) {
                suiBuyPoolService.deleteBuyPool(objectId);
            } else {
                suiBuyPoolService.updateBuyPoolState(objectId);
            }
            buyPoolEventService.updateStatusToProcessed(e);
        });
    }
}
