// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.tokenpair;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.test.suiswapexample.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class TokenPairInitialized {
    private String id;

    private String exchangeId;

    private BigInteger exchangeRateNumerator;

    private BigInteger exchangeRateDenominator;

    private String provider;

    private String x_TokenType;

    private String y_TokenType;

    private BigInteger x_Amount;

    private BigInteger y_Amount;

    private String liquidityTokenId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getExchangeId() {
        return exchangeId;
    }

    public void setExchangeId(String exchangeId) {
        this.exchangeId = exchangeId;
    }

    public BigInteger getExchangeRateNumerator() {
        return exchangeRateNumerator;
    }

    public void setExchangeRateNumerator(BigInteger exchangeRateNumerator) {
        this.exchangeRateNumerator = exchangeRateNumerator;
    }

    public BigInteger getExchangeRateDenominator() {
        return exchangeRateDenominator;
    }

    public void setExchangeRateDenominator(BigInteger exchangeRateDenominator) {
        this.exchangeRateDenominator = exchangeRateDenominator;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getX_TokenType() {
        return x_TokenType;
    }

    public void setX_TokenType(String x_TokenType) {
        this.x_TokenType = x_TokenType;
    }

    public String getY_TokenType() {
        return y_TokenType;
    }

    public void setY_TokenType(String y_TokenType) {
        this.y_TokenType = y_TokenType;
    }

    public BigInteger getX_Amount() {
        return x_Amount;
    }

    public void setX_Amount(BigInteger x_Amount) {
        this.x_Amount = x_Amount;
    }

    public BigInteger getY_Amount() {
        return y_Amount;
    }

    public void setY_Amount(BigInteger y_Amount) {
        this.y_Amount = y_Amount;
    }

    public String getLiquidityTokenId() {
        return liquidityTokenId;
    }

    public void setLiquidityTokenId(String liquidityTokenId) {
        this.liquidityTokenId = liquidityTokenId;
    }

    @Override
    public String toString() {
        return "TokenPairInitialized{" +
                "id=" + '\'' + id + '\'' +
                ", exchangeId=" + '\'' + exchangeId + '\'' +
                ", exchangeRateNumerator=" + exchangeRateNumerator +
                ", exchangeRateDenominator=" + exchangeRateDenominator +
                ", provider=" + '\'' + provider + '\'' +
                ", x_TokenType=" + '\'' + x_TokenType + '\'' +
                ", y_TokenType=" + '\'' + y_TokenType + '\'' +
                ", x_Amount=" + x_Amount +
                ", y_Amount=" + y_Amount +
                ", liquidityTokenId=" + '\'' + liquidityTokenId + '\'' +
                '}';
    }

}
