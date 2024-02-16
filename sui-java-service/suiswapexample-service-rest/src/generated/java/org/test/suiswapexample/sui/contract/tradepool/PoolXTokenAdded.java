// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.tradepool;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.test.suiswapexample.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoolXTokenAdded {
    private String id;

    private BigInteger version;

    private String liquidityTokenId;

    private String provider;

    private String x_TokenType;

    private String y_TokenType;

    private BigInteger x_Amount;

    private String x_Id;

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

    public String getX_Id() {
        return x_Id;
    }

    public void setX_Id(String x_Id) {
        this.x_Id = x_Id;
    }

    @Override
    public String toString() {
        return "PoolXTokenAdded{" +
                "id=" + '\'' + id + '\'' +
                ", version=" + version +
                ", liquidityTokenId=" + '\'' + liquidityTokenId + '\'' +
                ", provider=" + '\'' + provider + '\'' +
                ", x_TokenType=" + '\'' + x_TokenType + '\'' +
                ", y_TokenType=" + '\'' + y_TokenType + '\'' +
                ", x_Amount=" + x_Amount +
                ", x_Id=" + '\'' + x_Id + '\'' +
                '}';
    }

}
