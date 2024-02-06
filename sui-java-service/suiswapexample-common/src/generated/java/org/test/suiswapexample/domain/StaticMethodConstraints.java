// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain;

import org.test.suiswapexample.specialization.ReflectUtils;
import org.test.suiswapexample.specialization.MutationContext;
import org.test.suiswapexample.specialization.VerificationContext;
import org.test.suiswapexample.domain.tokenpair.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.sellpool.*;
import org.test.suiswapexample.domain.liquiditytoken.*;
import org.test.suiswapexample.domain.exchange.*;

public class StaticMethodConstraints {

    public static void assertStaticVerificationAndMutationMethods() {

        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.InitializeLiquidityLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, String.class, BigInteger.class, BigInteger.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "exchange", "x_Amount", "feeNumerator", "feeDenominator"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.AddLiquidityLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Amount"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.RemoveLiquidityLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Id"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.DestroyLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, VerificationContext.class},
                    new String[]{"_", "_"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.SwapXLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, BigInteger.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Amount", "expectedY_AmountOut"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.SwapYLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Id"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.UpdateFeeRateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, TokenPairState.class, BigInteger.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "feeNumerator", "feeDenominator"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.InitializeSellPoolLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, String.class, BigInteger.class, BigInteger.class, BigInteger.class, Integer.class, BigInteger.class, BigInteger.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "exchange", "x_Amount", "exchangeRateNumerator", "exchangeRateDenominator", "priceCurveType", "priceDeltaX_Amount", "priceDeltaNumerator", "priceDeltaDenominator"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.UpdateExchangeRateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, BigInteger.class, BigInteger.class, BigInteger.class, BigInteger.class, BigInteger.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "startExchangeRateNumerator", "exchangeRateNumerator", "exchangeRateDenominator", "priceDeltaX_Amount", "priceDeltaNumerator", "priceDeltaDenominator"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.AddXTokenLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Amount"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.RemoveXTokenLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Id"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.WithdrawYReserveLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, BigInteger.class, VerificationContext.class},
                    new String[]{"_", "_", "y_Amount"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.DestroyLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, VerificationContext.class},
                    new String[]{"_", "_"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.BuyXLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SellPoolState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "x_Id"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.liquiditytoken.MintLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, LiquidityTokenState.class, VerificationContext.class},
                    new String[]{"_", "_"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.liquiditytoken.DestroyLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, LiquidityTokenState.class, VerificationContext.class},
                    new String[]{"_", "_"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.__Init__Logic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, VerificationContext.class},
                    new String[]{"_", "_"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.AddTokenPairLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "tokenPairId"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.AddSellPoolLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "sellPoolId"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.UpdateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ExchangeState.class, String.class, VerificationContext.class},
                    new String[]{"_", "_", "name"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.DestroyLogic",
                    "mutate",
                    new Class[]{TokenPairState.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "liquidityTokenId", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.tokenpair.UpdateFeeRateLogic",
                    "mutate",
                    new Class[]{TokenPairState.class, String.class, BigInteger.class, BigInteger.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "liquidityTokenId", "feeNumerator", "feeDenominator", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.UpdateExchangeRateLogic",
                    "mutate",
                    new Class[]{SellPoolState.class, String.class, BigInteger.class, BigInteger.class, BigInteger.class, BigInteger.class, BigInteger.class, BigInteger.class, String.class, String.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "liquidityTokenId", "startExchangeRateNumerator", "exchangeRateNumerator", "exchangeRateDenominator", "priceDeltaX_Amount", "priceDeltaNumerator", "priceDeltaDenominator", "provider", "x_TokenType", "y_TokenType", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.sellpool.DestroyLogic",
                    "mutate",
                    new Class[]{SellPoolState.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "liquidityTokenId", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.liquiditytoken.MintLogic",
                    "mutate",
                    new Class[]{LiquidityTokenState.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.liquiditytoken.DestroyLogic",
                    "mutate",
                    new Class[]{LiquidityTokenState.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.__Init__Logic",
                    "mutate",
                    new Class[]{ExchangeState.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.AddTokenPairLogic",
                    "mutate",
                    new Class[]{ExchangeState.class, String.class, String.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "tokenPairId", "x_TokenType", "y_TokenType", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.AddSellPoolLogic",
                    "mutate",
                    new Class[]{ExchangeState.class, String.class, String.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "sellPoolId", "x_TokenType", "y_TokenType", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );


        ReflectUtils.assertStaticMethodIfClassExists(
                    "org.test.suiswapexample.domain.exchange.UpdateLogic",
                    "mutate",
                    new Class[]{ExchangeState.class, String.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new String[]{"_", "name", "suiTimestamp", "suiTxDigest", "suiEventSeq", "suiPackageId", "suiTransactionModule", "suiSender", "suiType", "status"}
            );



    }

}


