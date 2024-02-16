// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tradepool;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;

public class TradePoolCommands {
    private TradePoolCommands() {
    }

    public static class InitializeTradePool extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "InitializeTradePool";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Exchange
         */
        private String exchange;

        public String getExchange() {
            return this.exchange;
        }

        public void setExchange(String exchange) {
            this.exchange = exchange;
        }

        /**
         * X_ Amount
         */
        private BigInteger x_Amount;

        public BigInteger getX_Amount() {
            return this.x_Amount;
        }

        public void setX_Amount(BigInteger x_Amount) {
            this.x_Amount = x_Amount;
        }

        /**
         * Exchange Rate Numerator
         */
        private BigInteger exchangeRateNumerator;

        public BigInteger getExchangeRateNumerator() {
            return this.exchangeRateNumerator;
        }

        public void setExchangeRateNumerator(BigInteger exchangeRateNumerator) {
            this.exchangeRateNumerator = exchangeRateNumerator;
        }

        /**
         * Exchange Rate Denominator
         */
        private BigInteger exchangeRateDenominator;

        public BigInteger getExchangeRateDenominator() {
            return this.exchangeRateDenominator;
        }

        public void setExchangeRateDenominator(BigInteger exchangeRateDenominator) {
            this.exchangeRateDenominator = exchangeRateDenominator;
        }

        /**
         * Price Curve Type
         */
        private Integer priceCurveType;

        public Integer getPriceCurveType() {
            return this.priceCurveType;
        }

        public void setPriceCurveType(Integer priceCurveType) {
            this.priceCurveType = priceCurveType;
        }

        /**
         * Price Delta X_ Amount
         */
        private BigInteger priceDeltaX_Amount;

        public BigInteger getPriceDeltaX_Amount() {
            return this.priceDeltaX_Amount;
        }

        public void setPriceDeltaX_Amount(BigInteger priceDeltaX_Amount) {
            this.priceDeltaX_Amount = priceDeltaX_Amount;
        }

        /**
         * Price Delta Numerator
         */
        private BigInteger priceDeltaNumerator;

        public BigInteger getPriceDeltaNumerator() {
            return this.priceDeltaNumerator;
        }

        public void setPriceDeltaNumerator(BigInteger priceDeltaNumerator) {
            this.priceDeltaNumerator = priceDeltaNumerator;
        }

        /**
         * Price Delta Denominator
         */
        private BigInteger priceDeltaDenominator;

        public BigInteger getPriceDeltaDenominator() {
            return this.priceDeltaDenominator;
        }

        public void setPriceDeltaDenominator(BigInteger priceDeltaDenominator) {
            this.priceDeltaDenominator = priceDeltaDenominator;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class InitializeSellPool extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "InitializeSellPool";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Exchange
         */
        private String exchange;

        public String getExchange() {
            return this.exchange;
        }

        public void setExchange(String exchange) {
            this.exchange = exchange;
        }

        /**
         * X_ Amount
         */
        private BigInteger x_Amount;

        public BigInteger getX_Amount() {
            return this.x_Amount;
        }

        public void setX_Amount(BigInteger x_Amount) {
            this.x_Amount = x_Amount;
        }

        /**
         * Exchange Rate Numerator
         */
        private BigInteger exchangeRateNumerator;

        public BigInteger getExchangeRateNumerator() {
            return this.exchangeRateNumerator;
        }

        public void setExchangeRateNumerator(BigInteger exchangeRateNumerator) {
            this.exchangeRateNumerator = exchangeRateNumerator;
        }

        /**
         * Exchange Rate Denominator
         */
        private BigInteger exchangeRateDenominator;

        public BigInteger getExchangeRateDenominator() {
            return this.exchangeRateDenominator;
        }

        public void setExchangeRateDenominator(BigInteger exchangeRateDenominator) {
            this.exchangeRateDenominator = exchangeRateDenominator;
        }

        /**
         * Price Curve Type
         */
        private Integer priceCurveType;

        public Integer getPriceCurveType() {
            return this.priceCurveType;
        }

        public void setPriceCurveType(Integer priceCurveType) {
            this.priceCurveType = priceCurveType;
        }

        /**
         * Price Delta X_ Amount
         */
        private BigInteger priceDeltaX_Amount;

        public BigInteger getPriceDeltaX_Amount() {
            return this.priceDeltaX_Amount;
        }

        public void setPriceDeltaX_Amount(BigInteger priceDeltaX_Amount) {
            this.priceDeltaX_Amount = priceDeltaX_Amount;
        }

        /**
         * Price Delta Numerator
         */
        private BigInteger priceDeltaNumerator;

        public BigInteger getPriceDeltaNumerator() {
            return this.priceDeltaNumerator;
        }

        public void setPriceDeltaNumerator(BigInteger priceDeltaNumerator) {
            this.priceDeltaNumerator = priceDeltaNumerator;
        }

        /**
         * Price Delta Denominator
         */
        private BigInteger priceDeltaDenominator;

        public BigInteger getPriceDeltaDenominator() {
            return this.priceDeltaDenominator;
        }

        public void setPriceDeltaDenominator(BigInteger priceDeltaDenominator) {
            this.priceDeltaDenominator = priceDeltaDenominator;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class InitializeBuyPool extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "InitializeBuyPool";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Exchange
         */
        private String exchange;

        public String getExchange() {
            return this.exchange;
        }

        public void setExchange(String exchange) {
            this.exchange = exchange;
        }

        /**
         * Exchange Rate Numerator
         */
        private BigInteger exchangeRateNumerator;

        public BigInteger getExchangeRateNumerator() {
            return this.exchangeRateNumerator;
        }

        public void setExchangeRateNumerator(BigInteger exchangeRateNumerator) {
            this.exchangeRateNumerator = exchangeRateNumerator;
        }

        /**
         * Exchange Rate Denominator
         */
        private BigInteger exchangeRateDenominator;

        public BigInteger getExchangeRateDenominator() {
            return this.exchangeRateDenominator;
        }

        public void setExchangeRateDenominator(BigInteger exchangeRateDenominator) {
            this.exchangeRateDenominator = exchangeRateDenominator;
        }

        /**
         * Price Curve Type
         */
        private Integer priceCurveType;

        public Integer getPriceCurveType() {
            return this.priceCurveType;
        }

        public void setPriceCurveType(Integer priceCurveType) {
            this.priceCurveType = priceCurveType;
        }

        /**
         * Price Delta X_ Amount
         */
        private BigInteger priceDeltaX_Amount;

        public BigInteger getPriceDeltaX_Amount() {
            return this.priceDeltaX_Amount;
        }

        public void setPriceDeltaX_Amount(BigInteger priceDeltaX_Amount) {
            this.priceDeltaX_Amount = priceDeltaX_Amount;
        }

        /**
         * Price Delta Numerator
         */
        private BigInteger priceDeltaNumerator;

        public BigInteger getPriceDeltaNumerator() {
            return this.priceDeltaNumerator;
        }

        public void setPriceDeltaNumerator(BigInteger priceDeltaNumerator) {
            this.priceDeltaNumerator = priceDeltaNumerator;
        }

        /**
         * Price Delta Denominator
         */
        private BigInteger priceDeltaDenominator;

        public BigInteger getPriceDeltaDenominator() {
            return this.priceDeltaDenominator;
        }

        public void setPriceDeltaDenominator(BigInteger priceDeltaDenominator) {
            this.priceDeltaDenominator = priceDeltaDenominator;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class UpdateExchangeRate extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "UpdateExchangeRate";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Liquidity Token
         */
        private String liquidityToken;

        public String getLiquidityToken() {
            return this.liquidityToken;
        }

        public void setLiquidityToken(String liquidityToken) {
            this.liquidityToken = liquidityToken;
        }

        /**
         * Start Exchange Rate Numerator
         */
        private BigInteger startExchangeRateNumerator;

        public BigInteger getStartExchangeRateNumerator() {
            return this.startExchangeRateNumerator;
        }

        public void setStartExchangeRateNumerator(BigInteger startExchangeRateNumerator) {
            this.startExchangeRateNumerator = startExchangeRateNumerator;
        }

        /**
         * Exchange Rate Numerator
         */
        private BigInteger exchangeRateNumerator;

        public BigInteger getExchangeRateNumerator() {
            return this.exchangeRateNumerator;
        }

        public void setExchangeRateNumerator(BigInteger exchangeRateNumerator) {
            this.exchangeRateNumerator = exchangeRateNumerator;
        }

        /**
         * Exchange Rate Denominator
         */
        private BigInteger exchangeRateDenominator;

        public BigInteger getExchangeRateDenominator() {
            return this.exchangeRateDenominator;
        }

        public void setExchangeRateDenominator(BigInteger exchangeRateDenominator) {
            this.exchangeRateDenominator = exchangeRateDenominator;
        }

        /**
         * Price Delta X_ Amount
         */
        private BigInteger priceDeltaX_Amount;

        public BigInteger getPriceDeltaX_Amount() {
            return this.priceDeltaX_Amount;
        }

        public void setPriceDeltaX_Amount(BigInteger priceDeltaX_Amount) {
            this.priceDeltaX_Amount = priceDeltaX_Amount;
        }

        /**
         * Price Delta Numerator
         */
        private BigInteger priceDeltaNumerator;

        public BigInteger getPriceDeltaNumerator() {
            return this.priceDeltaNumerator;
        }

        public void setPriceDeltaNumerator(BigInteger priceDeltaNumerator) {
            this.priceDeltaNumerator = priceDeltaNumerator;
        }

        /**
         * Price Delta Denominator
         */
        private BigInteger priceDeltaDenominator;

        public BigInteger getPriceDeltaDenominator() {
            return this.priceDeltaDenominator;
        }

        public void setPriceDeltaDenominator(BigInteger priceDeltaDenominator) {
            this.priceDeltaDenominator = priceDeltaDenominator;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class AddXToken extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "AddXToken";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Liquidity Token
         */
        private String liquidityToken;

        public String getLiquidityToken() {
            return this.liquidityToken;
        }

        public void setLiquidityToken(String liquidityToken) {
            this.liquidityToken = liquidityToken;
        }

        /**
         * X_ Amount
         */
        private BigInteger x_Amount;

        public BigInteger getX_Amount() {
            return this.x_Amount;
        }

        public void setX_Amount(BigInteger x_Amount) {
            this.x_Amount = x_Amount;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class RemoveXToken extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "RemoveXToken";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Liquidity Token
         */
        private String liquidityToken;

        public String getLiquidityToken() {
            return this.liquidityToken;
        }

        public void setLiquidityToken(String liquidityToken) {
            this.liquidityToken = liquidityToken;
        }

        /**
         * X_ Id
         */
        private String x_Id;

        public String getX_Id() {
            return this.x_Id;
        }

        public void setX_Id(String x_Id) {
            this.x_Id = x_Id;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class DepositYReserve extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "DepositYReserve";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Liquidity Token
         */
        private String liquidityToken;

        public String getLiquidityToken() {
            return this.liquidityToken;
        }

        public void setLiquidityToken(String liquidityToken) {
            this.liquidityToken = liquidityToken;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class WithdrawYReserve extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "WithdrawYReserve";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Liquidity Token
         */
        private String liquidityToken;

        public String getLiquidityToken() {
            return this.liquidityToken;
        }

        public void setLiquidityToken(String liquidityToken) {
            this.liquidityToken = liquidityToken;
        }

        /**
         * Y_ Amount
         */
        private BigInteger y_Amount;

        public BigInteger getY_Amount() {
            return this.y_Amount;
        }

        public void setY_Amount(BigInteger y_Amount) {
            this.y_Amount = y_Amount;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class Destroy extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "Destroy";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Liquidity Token
         */
        private String liquidityToken;

        public String getLiquidityToken() {
            return this.liquidityToken;
        }

        public void setLiquidityToken(String liquidityToken) {
            this.liquidityToken = liquidityToken;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class BuyX extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "BuyX";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * X_ Id
         */
        private String x_Id;

        public String getX_Id() {
            return this.x_Id;
        }

        public void setX_Id(String x_Id) {
            this.x_Id = x_Id;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class SellX extends AbstractTradePoolCommand implements TradePoolCommand {

        public String getCommandType() {
            return "SellX";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * X_ Amount
         */
        private BigInteger x_Amount;

        public BigInteger getX_Amount() {
            return this.x_Amount;
        }

        public void setX_Amount(BigInteger x_Amount) {
            this.x_Amount = x_Amount;
        }

        /**
         * Expected Y_ Amount Out
         */
        private BigInteger expectedY_AmountOut;

        public BigInteger getExpectedY_AmountOut() {
            return this.expectedY_AmountOut;
        }

        public void setExpectedY_AmountOut(BigInteger expectedY_AmountOut) {
            this.expectedY_AmountOut = expectedY_AmountOut;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

}

