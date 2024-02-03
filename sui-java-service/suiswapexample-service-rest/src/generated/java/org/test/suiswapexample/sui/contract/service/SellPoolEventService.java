// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.service;

import com.github.wubuku.sui.bean.EventId;
import com.github.wubuku.sui.bean.Page;
import com.github.wubuku.sui.bean.PaginatedMoveEvents;
import com.github.wubuku.sui.bean.SuiMoveEventEnvelope;
import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.test.suiswapexample.domain.sellpool.AbstractSellPoolEvent;
import org.test.suiswapexample.sui.contract.ContractConstants;
import org.test.suiswapexample.sui.contract.DomainBeanUtils;
import org.test.suiswapexample.sui.contract.SuiPackage;
import org.test.suiswapexample.sui.contract.sellpool.SellPoolInitialized;
import org.test.suiswapexample.sui.contract.sellpool.SellPoolExchangeRateUpdated;
import org.test.suiswapexample.sui.contract.sellpool.SellPoolXTokenAdded;
import org.test.suiswapexample.sui.contract.sellpool.SellPoolXTokenRemoved;
import org.test.suiswapexample.sui.contract.sellpool.YReserveWithdrawn;
import org.test.suiswapexample.sui.contract.sellpool.SellPoolDestroyed;
import org.test.suiswapexample.sui.contract.sellpool.SellPoolYSwappedForX;
import org.test.suiswapexample.sui.contract.repository.SellPoolEventRepository;
import org.test.suiswapexample.sui.contract.repository.SuiPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SellPoolEventService {

    public static final java.util.Set<String> DELETION_COMMAND_EVENTS = new java.util.HashSet<>(java.util.Arrays.asList("SellPoolDestroyed"));

    public static boolean isDeletionCommand(String eventType) {
        return DELETION_COMMAND_EVENTS.contains(eventType);
    }

    public static boolean isDeletionCommand(AbstractSellPoolEvent e) {
        if (isDeletionCommand(e.getEventType())) {
            return true;
        }
        return false;
    }

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private SellPoolEventRepository sellPoolEventRepository;

    @Transactional
    public void updateStatusToProcessed(AbstractSellPoolEvent event) {
        event.setStatus("D");
        sellPoolEventRepository.save(event);
    }

    @Transactional
    public void pullSellPoolInitializedEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolInitializedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolInitialized> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_SELL_POOL_INITIALIZED,
                    cursor, limit, false, SellPoolInitialized.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolInitialized> eventEnvelope : eventPage.getData()) {
                    saveSellPoolInitialized(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolInitializedEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstSellPoolInitializedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolInitialized(SuiMoveEventEnvelope<SellPoolInitialized> eventEnvelope) {
        AbstractSellPoolEvent.SellPoolInitialized sellPoolInitialized = DomainBeanUtils.toSellPoolInitialized(eventEnvelope);
        if (sellPoolEventRepository.findById(sellPoolInitialized.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(sellPoolInitialized);
    }

    @Transactional
    public void pullSellPoolExchangeRateUpdatedEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolExchangeRateUpdatedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolExchangeRateUpdated> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_SELL_POOL_EXCHANGE_RATE_UPDATED,
                    cursor, limit, false, SellPoolExchangeRateUpdated.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolExchangeRateUpdated> eventEnvelope : eventPage.getData()) {
                    saveSellPoolExchangeRateUpdated(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolExchangeRateUpdatedEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstSellPoolExchangeRateUpdatedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolExchangeRateUpdated(SuiMoveEventEnvelope<SellPoolExchangeRateUpdated> eventEnvelope) {
        AbstractSellPoolEvent.SellPoolExchangeRateUpdated sellPoolExchangeRateUpdated = DomainBeanUtils.toSellPoolExchangeRateUpdated(eventEnvelope);
        if (sellPoolEventRepository.findById(sellPoolExchangeRateUpdated.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(sellPoolExchangeRateUpdated);
    }

    @Transactional
    public void pullSellPoolXTokenAddedEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolXTokenAddedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolXTokenAdded> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_SELL_POOL_X_TOKEN_ADDED,
                    cursor, limit, false, SellPoolXTokenAdded.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolXTokenAdded> eventEnvelope : eventPage.getData()) {
                    saveSellPoolXTokenAdded(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolXTokenAddedEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstSellPoolXTokenAddedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolXTokenAdded(SuiMoveEventEnvelope<SellPoolXTokenAdded> eventEnvelope) {
        AbstractSellPoolEvent.SellPoolXTokenAdded sellPoolXTokenAdded = DomainBeanUtils.toSellPoolXTokenAdded(eventEnvelope);
        if (sellPoolEventRepository.findById(sellPoolXTokenAdded.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(sellPoolXTokenAdded);
    }

    @Transactional
    public void pullSellPoolXTokenRemovedEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolXTokenRemovedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolXTokenRemoved> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_SELL_POOL_X_TOKEN_REMOVED,
                    cursor, limit, false, SellPoolXTokenRemoved.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolXTokenRemoved> eventEnvelope : eventPage.getData()) {
                    saveSellPoolXTokenRemoved(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolXTokenRemovedEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstSellPoolXTokenRemovedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolXTokenRemoved(SuiMoveEventEnvelope<SellPoolXTokenRemoved> eventEnvelope) {
        AbstractSellPoolEvent.SellPoolXTokenRemoved sellPoolXTokenRemoved = DomainBeanUtils.toSellPoolXTokenRemoved(eventEnvelope);
        if (sellPoolEventRepository.findById(sellPoolXTokenRemoved.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(sellPoolXTokenRemoved);
    }

    @Transactional
    public void pullYReserveWithdrawnEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getYReserveWithdrawnEventNextCursor();
        while (true) {
            PaginatedMoveEvents<YReserveWithdrawn> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_Y_RESERVE_WITHDRAWN,
                    cursor, limit, false, YReserveWithdrawn.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<YReserveWithdrawn> eventEnvelope : eventPage.getData()) {
                    saveYReserveWithdrawn(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getYReserveWithdrawnEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstYReserveWithdrawnByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveYReserveWithdrawn(SuiMoveEventEnvelope<YReserveWithdrawn> eventEnvelope) {
        AbstractSellPoolEvent.YReserveWithdrawn yReserveWithdrawn = DomainBeanUtils.toYReserveWithdrawn(eventEnvelope);
        if (sellPoolEventRepository.findById(yReserveWithdrawn.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(yReserveWithdrawn);
    }

    @Transactional
    public void pullSellPoolDestroyedEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolDestroyedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolDestroyed> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_SELL_POOL_DESTROYED,
                    cursor, limit, false, SellPoolDestroyed.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolDestroyed> eventEnvelope : eventPage.getData()) {
                    saveSellPoolDestroyed(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolDestroyedEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstSellPoolDestroyedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolDestroyed(SuiMoveEventEnvelope<SellPoolDestroyed> eventEnvelope) {
        AbstractSellPoolEvent.SellPoolDestroyed sellPoolDestroyed = DomainBeanUtils.toSellPoolDestroyed(eventEnvelope);
        if (sellPoolEventRepository.findById(sellPoolDestroyed.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(sellPoolDestroyed);
    }

    @Transactional
    public void pullSellPoolYSwappedForXEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolYSwappedForXEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolYSwappedForX> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.SELL_POOL_MODULE_SELL_POOL_Y_SWAPPED_FOR_X,
                    cursor, limit, false, SellPoolYSwappedForX.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolYSwappedForX> eventEnvelope : eventPage.getData()) {
                    saveSellPoolYSwappedForX(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolYSwappedForXEventNextCursor() {
        AbstractSellPoolEvent lastEvent = sellPoolEventRepository.findFirstSellPoolYSwappedForXByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolYSwappedForX(SuiMoveEventEnvelope<SellPoolYSwappedForX> eventEnvelope) {
        AbstractSellPoolEvent.SellPoolYSwappedForX sellPoolYSwappedForX = DomainBeanUtils.toSellPoolYSwappedForX(eventEnvelope);
        if (sellPoolEventRepository.findById(sellPoolYSwappedForX.getSellPoolEventId()).isPresent()) {
            return;
        }
        sellPoolEventRepository.save(sellPoolYSwappedForX);
    }


    private String getDefaultSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.DEFAULT_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }
}
