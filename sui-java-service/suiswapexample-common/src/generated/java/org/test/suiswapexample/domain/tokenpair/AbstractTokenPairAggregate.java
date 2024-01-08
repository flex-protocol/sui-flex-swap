// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair;

import java.util.*;
import org.test.suiswapexample.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.specialization.*;

public abstract class AbstractTokenPairAggregate extends AbstractAggregate implements TokenPairAggregate {
    private TokenPairState.MutableTokenPairState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractTokenPairAggregate(TokenPairState state) {
        this.state = (TokenPairState.MutableTokenPairState)state;
    }

    public TokenPairState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        TokenPairCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleTokenPairAggregate extends AbstractTokenPairAggregate {
        public SimpleTokenPairAggregate(TokenPairState state) {
            super(state);
        }

        protected TokenPairEvent.LiquidityInitialized verifyInitializeLiquidity(java.util.function.Supplier<TokenPairEvent.LiquidityInitialized> eventFactory, String exchange, TokenPairCommands.InitializeLiquidity c) {
            String Exchange = exchange;

            TokenPairEvent.LiquidityInitialized e = (TokenPairEvent.LiquidityInitialized) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.InitializeLiquidityLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, String.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), exchange, VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class InitializeLiquidityLogic {
//    public static TokenPairEvent.LiquidityInitialized verify(java.util.function.Supplier<TokenPairEvent.LiquidityInitialized> eventFactory, TokenPairState tokenPairState, String exchange, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected TokenPairEvent.LiquidityAdded verifyAddLiquidity(java.util.function.Supplier<TokenPairEvent.LiquidityAdded> eventFactory, TokenPairCommands.AddLiquidity c) {

            TokenPairEvent.LiquidityAdded e = (TokenPairEvent.LiquidityAdded) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.AddLiquidityLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class AddLiquidityLogic {
//    public static TokenPairEvent.LiquidityAdded verify(java.util.function.Supplier<TokenPairEvent.LiquidityAdded> eventFactory, TokenPairState tokenPairState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected TokenPairEvent.LiquidityRemoved verifyRemoveLiquidity(java.util.function.Supplier<TokenPairEvent.LiquidityRemoved> eventFactory, String liquidityToken, TokenPairCommands.RemoveLiquidity c) {
            String LiquidityToken = liquidityToken;

            TokenPairEvent.LiquidityRemoved e = (TokenPairEvent.LiquidityRemoved) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.RemoveLiquidityLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, String.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), liquidityToken, VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class RemoveLiquidityLogic {
//    public static TokenPairEvent.LiquidityRemoved verify(java.util.function.Supplier<TokenPairEvent.LiquidityRemoved> eventFactory, TokenPairState tokenPairState, String liquidityToken, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected TokenPairEvent.XSwappedForY verifySwapX(java.util.function.Supplier<TokenPairEvent.XSwappedForY> eventFactory, BigInteger expectedY_AmountOut, TokenPairCommands.SwapX c) {
            BigInteger ExpectedY_AmountOut = expectedY_AmountOut;

            TokenPairEvent.XSwappedForY e = (TokenPairEvent.XSwappedForY) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.SwapXLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, BigInteger.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), expectedY_AmountOut, VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class SwapXLogic {
//    public static TokenPairEvent.XSwappedForY verify(java.util.function.Supplier<TokenPairEvent.XSwappedForY> eventFactory, TokenPairState tokenPairState, BigInteger expectedY_AmountOut, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected TokenPairEvent.YSwappedForX verifySwapY(java.util.function.Supplier<TokenPairEvent.YSwappedForX> eventFactory, BigInteger expectedX_AmountOut, TokenPairCommands.SwapY c) {
            BigInteger ExpectedX_AmountOut = expectedX_AmountOut;

            TokenPairEvent.YSwappedForX e = (TokenPairEvent.YSwappedForX) ReflectUtils.invokeStaticMethod(
                    "org.test.suiswapexample.domain.tokenpair.SwapYLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, BigInteger.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), expectedX_AmountOut, VerificationContext.forCommand(c)}
            );

//package org.test.suiswapexample.domain.tokenpair;
//
//public class SwapYLogic {
//    public static TokenPairEvent.YSwappedForX verify(java.util.function.Supplier<TokenPairEvent.YSwappedForX> eventFactory, TokenPairState tokenPairState, BigInteger expectedX_AmountOut, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

    }

}

