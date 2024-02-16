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
import org.test.suiswapexample.domain.exchange.AbstractExchangeEvent;
import org.test.suiswapexample.sui.contract.ContractConstants;
import org.test.suiswapexample.sui.contract.DomainBeanUtils;
import org.test.suiswapexample.sui.contract.SuiPackage;
import org.test.suiswapexample.sui.contract.exchange.InitExchangeEvent;
import org.test.suiswapexample.sui.contract.exchange.TokenPairAddedToExchange;
import org.test.suiswapexample.sui.contract.exchange.TradePoolAddedToExchange;
import org.test.suiswapexample.sui.contract.exchange.SellPoolAddedToExchange;
import org.test.suiswapexample.sui.contract.exchange.BuyPoolAddedToExchange;
import org.test.suiswapexample.sui.contract.exchange.ExchangeUpdated;
import org.test.suiswapexample.sui.contract.repository.ExchangeEventRepository;
import org.test.suiswapexample.sui.contract.repository.SuiPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ExchangeEventService {

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private ExchangeEventRepository exchangeEventRepository;

    @Transactional
    public void updateStatusToProcessed(AbstractExchangeEvent event) {
        event.setStatus("D");
        exchangeEventRepository.save(event);
    }

    @Transactional
    public void pullInitExchangeEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getInitExchangeEventNextCursor();
        while (true) {
            PaginatedMoveEvents<InitExchangeEvent> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.EXCHANGE_MODULE_INIT_EXCHANGE_EVENT,
                    cursor, limit, false, InitExchangeEvent.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<InitExchangeEvent> eventEnvelope : eventPage.getData()) {
                    saveInitExchangeEvent(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getInitExchangeEventNextCursor() {
        AbstractExchangeEvent lastEvent = exchangeEventRepository.findFirstInitExchangeEventByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveInitExchangeEvent(SuiMoveEventEnvelope<InitExchangeEvent> eventEnvelope) {
        AbstractExchangeEvent.InitExchangeEvent initExchangeEvent = DomainBeanUtils.toInitExchangeEvent(eventEnvelope);
        if (exchangeEventRepository.findById(initExchangeEvent.getExchangeEventId()).isPresent()) {
            return;
        }
        exchangeEventRepository.save(initExchangeEvent);
    }

    @Transactional
    public void pullTokenPairAddedToExchangeEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getTokenPairAddedToExchangeEventNextCursor();
        while (true) {
            PaginatedMoveEvents<TokenPairAddedToExchange> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.EXCHANGE_MODULE_TOKEN_PAIR_ADDED_TO_EXCHANGE,
                    cursor, limit, false, TokenPairAddedToExchange.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<TokenPairAddedToExchange> eventEnvelope : eventPage.getData()) {
                    saveTokenPairAddedToExchange(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getTokenPairAddedToExchangeEventNextCursor() {
        AbstractExchangeEvent lastEvent = exchangeEventRepository.findFirstTokenPairAddedToExchangeByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveTokenPairAddedToExchange(SuiMoveEventEnvelope<TokenPairAddedToExchange> eventEnvelope) {
        AbstractExchangeEvent.TokenPairAddedToExchange tokenPairAddedToExchange = DomainBeanUtils.toTokenPairAddedToExchange(eventEnvelope);
        if (exchangeEventRepository.findById(tokenPairAddedToExchange.getExchangeEventId()).isPresent()) {
            return;
        }
        exchangeEventRepository.save(tokenPairAddedToExchange);
    }

    @Transactional
    public void pullTradePoolAddedToExchangeEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getTradePoolAddedToExchangeEventNextCursor();
        while (true) {
            PaginatedMoveEvents<TradePoolAddedToExchange> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.EXCHANGE_MODULE_TRADE_POOL_ADDED_TO_EXCHANGE,
                    cursor, limit, false, TradePoolAddedToExchange.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<TradePoolAddedToExchange> eventEnvelope : eventPage.getData()) {
                    saveTradePoolAddedToExchange(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getTradePoolAddedToExchangeEventNextCursor() {
        AbstractExchangeEvent lastEvent = exchangeEventRepository.findFirstTradePoolAddedToExchangeByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveTradePoolAddedToExchange(SuiMoveEventEnvelope<TradePoolAddedToExchange> eventEnvelope) {
        AbstractExchangeEvent.TradePoolAddedToExchange tradePoolAddedToExchange = DomainBeanUtils.toTradePoolAddedToExchange(eventEnvelope);
        if (exchangeEventRepository.findById(tradePoolAddedToExchange.getExchangeEventId()).isPresent()) {
            return;
        }
        exchangeEventRepository.save(tradePoolAddedToExchange);
    }

    @Transactional
    public void pullSellPoolAddedToExchangeEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getSellPoolAddedToExchangeEventNextCursor();
        while (true) {
            PaginatedMoveEvents<SellPoolAddedToExchange> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.EXCHANGE_MODULE_SELL_POOL_ADDED_TO_EXCHANGE,
                    cursor, limit, false, SellPoolAddedToExchange.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<SellPoolAddedToExchange> eventEnvelope : eventPage.getData()) {
                    saveSellPoolAddedToExchange(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getSellPoolAddedToExchangeEventNextCursor() {
        AbstractExchangeEvent lastEvent = exchangeEventRepository.findFirstSellPoolAddedToExchangeByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveSellPoolAddedToExchange(SuiMoveEventEnvelope<SellPoolAddedToExchange> eventEnvelope) {
        AbstractExchangeEvent.SellPoolAddedToExchange sellPoolAddedToExchange = DomainBeanUtils.toSellPoolAddedToExchange(eventEnvelope);
        if (exchangeEventRepository.findById(sellPoolAddedToExchange.getExchangeEventId()).isPresent()) {
            return;
        }
        exchangeEventRepository.save(sellPoolAddedToExchange);
    }

    @Transactional
    public void pullBuyPoolAddedToExchangeEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getBuyPoolAddedToExchangeEventNextCursor();
        while (true) {
            PaginatedMoveEvents<BuyPoolAddedToExchange> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.EXCHANGE_MODULE_BUY_POOL_ADDED_TO_EXCHANGE,
                    cursor, limit, false, BuyPoolAddedToExchange.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<BuyPoolAddedToExchange> eventEnvelope : eventPage.getData()) {
                    saveBuyPoolAddedToExchange(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getBuyPoolAddedToExchangeEventNextCursor() {
        AbstractExchangeEvent lastEvent = exchangeEventRepository.findFirstBuyPoolAddedToExchangeByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveBuyPoolAddedToExchange(SuiMoveEventEnvelope<BuyPoolAddedToExchange> eventEnvelope) {
        AbstractExchangeEvent.BuyPoolAddedToExchange buyPoolAddedToExchange = DomainBeanUtils.toBuyPoolAddedToExchange(eventEnvelope);
        if (exchangeEventRepository.findById(buyPoolAddedToExchange.getExchangeEventId()).isPresent()) {
            return;
        }
        exchangeEventRepository.save(buyPoolAddedToExchange);
    }

    @Transactional
    public void pullExchangeUpdatedEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getExchangeUpdatedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<ExchangeUpdated> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.EXCHANGE_MODULE_EXCHANGE_UPDATED,
                    cursor, limit, false, ExchangeUpdated.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<ExchangeUpdated> eventEnvelope : eventPage.getData()) {
                    saveExchangeUpdated(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getExchangeUpdatedEventNextCursor() {
        AbstractExchangeEvent lastEvent = exchangeEventRepository.findFirstExchangeUpdatedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveExchangeUpdated(SuiMoveEventEnvelope<ExchangeUpdated> eventEnvelope) {
        AbstractExchangeEvent.ExchangeUpdated exchangeUpdated = DomainBeanUtils.toExchangeUpdated(eventEnvelope);
        if (exchangeEventRepository.findById(exchangeUpdated.getExchangeEventId()).isPresent()) {
            return;
        }
        exchangeEventRepository.save(exchangeUpdated);
    }


    private String getDefaultSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.DEFAULT_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }
}
