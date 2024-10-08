// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.exchange;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;

public abstract class AbstractExchangeAggregate extends AbstractAggregate implements ExchangeAggregate {
    private ExchangeState.MutableExchangeState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractExchangeAggregate(ExchangeState state) {
        this.state = (ExchangeState.MutableExchangeState)state;
    }

    public ExchangeState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        ExchangeCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleExchangeAggregate extends AbstractExchangeAggregate {
        public SimpleExchangeAggregate(ExchangeState state) {
            super(state);
        }

        @Override
        public void addTokenPair(String tokenPair, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.AddTokenPair c) {
            java.util.function.Supplier<ExchangeEvent.TokenPairAddedToExchange> eventFactory = () -> newTokenPairAddedToExchange(tokenPair, offChainVersion, commandId, requesterId);
            ExchangeEvent.TokenPairAddedToExchange e;
            try {
                e = verifyAddTokenPair(eventFactory, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void update(String name, Long offChainVersion, String commandId, String requesterId, ExchangeCommands.Update c) {
            java.util.function.Supplier<ExchangeEvent.ExchangeUpdated> eventFactory = () -> newExchangeUpdated(name, offChainVersion, commandId, requesterId);
            ExchangeEvent.ExchangeUpdated e;
            try {
                e = verifyUpdate(eventFactory, name, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        protected ExchangeEvent.InitExchangeEvent verify__Init__(java.util.function.Supplier<ExchangeEvent.InitExchangeEvent> eventFactory, ExchangeCommands.__Init__ c) {

            ExchangeEvent.InitExchangeEvent e = (ExchangeEvent.InitExchangeEvent) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.exchange.__Init__Logic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.exchange;
//
//public class __Init__Logic {
//    public static ExchangeEvent.InitExchangeEvent verify(java.util.function.Supplier<ExchangeEvent.InitExchangeEvent> eventFactory, ExchangeState exchangeState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected ExchangeEvent.TokenPairAddedToExchange verifyAddTokenPair(java.util.function.Supplier<ExchangeEvent.TokenPairAddedToExchange> eventFactory, ExchangeCommands.AddTokenPair c) {

            ExchangeEvent.TokenPairAddedToExchange e = (ExchangeEvent.TokenPairAddedToExchange) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.exchange.AddTokenPairLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.exchange;
//
//public class AddTokenPairLogic {
//    public static ExchangeEvent.TokenPairAddedToExchange verify(java.util.function.Supplier<ExchangeEvent.TokenPairAddedToExchange> eventFactory, ExchangeState exchangeState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected ExchangeEvent.ExchangeUpdated verifyUpdate(java.util.function.Supplier<ExchangeEvent.ExchangeUpdated> eventFactory, String name, ExchangeCommands.Update c) {
            String Name = name;

            ExchangeEvent.ExchangeUpdated e = (ExchangeEvent.ExchangeUpdated) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.exchange.UpdateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, String.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), name, VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.exchange;
//
//public class UpdateLogic {
//    public static ExchangeEvent.ExchangeUpdated verify(java.util.function.Supplier<ExchangeEvent.ExchangeUpdated> eventFactory, ExchangeState exchangeState, String name, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AbstractExchangeEvent.InitExchangeEvent newInitExchangeEvent(Long offChainVersion, String commandId, String requesterId) {
            ExchangeEventId eventId = new ExchangeEventId(getState().getId(), null);
            AbstractExchangeEvent.InitExchangeEvent e = new AbstractExchangeEvent.InitExchangeEvent();

            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setExchangeEventId(eventId);
            return e;
        }

        protected AbstractExchangeEvent.TokenPairAddedToExchange newTokenPairAddedToExchange(String tokenPair, Long offChainVersion, String commandId, String requesterId) {
            ExchangeEventId eventId = new ExchangeEventId(getState().getId(), null);
            AbstractExchangeEvent.TokenPairAddedToExchange e = new AbstractExchangeEvent.TokenPairAddedToExchange();

            e.setTokenPairId(null);
            e.setX_TokenType(null);
            e.setY_TokenType(null);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setExchangeEventId(eventId);
            return e;
        }

        protected AbstractExchangeEvent.ExchangeUpdated newExchangeUpdated(String name, Long offChainVersion, String commandId, String requesterId) {
            ExchangeEventId eventId = new ExchangeEventId(getState().getId(), null);
            AbstractExchangeEvent.ExchangeUpdated e = new AbstractExchangeEvent.ExchangeUpdated();

            e.setName(name);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setExchangeEventId(eventId);
            return e;
        }

    }

}

