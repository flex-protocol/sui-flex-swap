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
public class ExchangeRateUpdated {
    private String id;

    private BigInteger version;

    private String liquidityTokenId;

    private BigInteger exchangeRateNumerator;

    private BigInteger exchangeRateDenominator;

    private String provider;

    private String x_TokenType;

    private String y_TokenType;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public BigInteger getVersion() {
        return version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
    }

    public String getLiquidityTokenId() {
        return liquidityTokenId;
    }

    public void setLiquidityTokenId(String liquidityTokenId) {
        this.liquidityTokenId = liquidityTokenId;
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

    @Override
    public String toString() {
        return "ExchangeRateUpdated{" +
                "id=" + '\'' + id + '\'' +
                ", version=" + version +
                ", liquidityTokenId=" + '\'' + liquidityTokenId + '\'' +
                ", exchangeRateNumerator=" + exchangeRateNumerator +
                ", exchangeRateDenominator=" + exchangeRateDenominator +
                ", provider=" + '\'' + provider + '\'' +
                ", x_TokenType=" + '\'' + x_TokenType + '\'' +
                ", y_TokenType=" + '\'' + y_TokenType + '\'' +
                '}';
    }

}
