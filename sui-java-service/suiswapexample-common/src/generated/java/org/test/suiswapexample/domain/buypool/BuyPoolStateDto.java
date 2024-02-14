// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.buypool;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;


public class BuyPoolStateDto {

    private String id;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    private BigInteger version;

    public BigInteger getVersion()
    {
        return this.version;
    }

    public void setVersion(BigInteger version)
    {
        this.version = version;
    }

    private ObjectTable x_Reserve;

    public ObjectTable getX_Reserve()
    {
        return this.x_Reserve;
    }

    public void setX_Reserve(ObjectTable x_Reserve)
    {
        this.x_Reserve = x_Reserve;
    }

    private Table x_Amounts;

    public Table getX_Amounts()
    {
        return this.x_Amounts;
    }

    public void setX_Amounts(Table x_Amounts)
    {
        this.x_Amounts = x_Amounts;
    }

    private BigInteger x_TotalAmount;

    public BigInteger getX_TotalAmount()
    {
        return this.x_TotalAmount;
    }

    public void setX_TotalAmount(BigInteger x_TotalAmount)
    {
        this.x_TotalAmount = x_TotalAmount;
    }

    private java.math.BigInteger y_Reserve;

    public java.math.BigInteger getY_Reserve()
    {
        return this.y_Reserve;
    }

    public void setY_Reserve(java.math.BigInteger y_Reserve)
    {
        this.y_Reserve = y_Reserve;
    }

    private String liquidityTokenId;

    public String getLiquidityTokenId()
    {
        return this.liquidityTokenId;
    }

    public void setLiquidityTokenId(String liquidityTokenId)
    {
        this.liquidityTokenId = liquidityTokenId;
    }

    private BigInteger x_BoughtAmount;

    public BigInteger getX_BoughtAmount()
    {
        return this.x_BoughtAmount;
    }

    public void setX_BoughtAmount(BigInteger x_BoughtAmount)
    {
        this.x_BoughtAmount = x_BoughtAmount;
    }

    private BigInteger startExchangeRateNumerator;

    public BigInteger getStartExchangeRateNumerator()
    {
        return this.startExchangeRateNumerator;
    }

    public void setStartExchangeRateNumerator(BigInteger startExchangeRateNumerator)
    {
        this.startExchangeRateNumerator = startExchangeRateNumerator;
    }

    private BigInteger exchangeRateNumerator;

    public BigInteger getExchangeRateNumerator()
    {
        return this.exchangeRateNumerator;
    }

    public void setExchangeRateNumerator(BigInteger exchangeRateNumerator)
    {
        this.exchangeRateNumerator = exchangeRateNumerator;
    }

    private BigInteger exchangeRateDenominator;

    public BigInteger getExchangeRateDenominator()
    {
        return this.exchangeRateDenominator;
    }

    public void setExchangeRateDenominator(BigInteger exchangeRateDenominator)
    {
        this.exchangeRateDenominator = exchangeRateDenominator;
    }

    private Integer priceCurveType;

    public Integer getPriceCurveType()
    {
        return this.priceCurveType;
    }

    public void setPriceCurveType(Integer priceCurveType)
    {
        this.priceCurveType = priceCurveType;
    }

    private BigInteger priceDeltaX_Amount;

    public BigInteger getPriceDeltaX_Amount()
    {
        return this.priceDeltaX_Amount;
    }

    public void setPriceDeltaX_Amount(BigInteger priceDeltaX_Amount)
    {
        this.priceDeltaX_Amount = priceDeltaX_Amount;
    }

    private BigInteger priceDeltaNumerator;

    public BigInteger getPriceDeltaNumerator()
    {
        return this.priceDeltaNumerator;
    }

    public void setPriceDeltaNumerator(BigInteger priceDeltaNumerator)
    {
        this.priceDeltaNumerator = priceDeltaNumerator;
    }

    private BigInteger priceDeltaDenominator;

    public BigInteger getPriceDeltaDenominator()
    {
        return this.priceDeltaDenominator;
    }

    public void setPriceDeltaDenominator(BigInteger priceDeltaDenominator)
    {
        this.priceDeltaDenominator = priceDeltaDenominator;
    }

    private Boolean active;

    public Boolean getActive()
    {
        return this.active;
    }

    public void setActive(Boolean active)
    {
        this.active = active;
    }

    private String x_TokenType;

    public String getX_TokenType()
    {
        return this.x_TokenType;
    }

    public void setX_TokenType(String x_TokenType)
    {
        this.x_TokenType = x_TokenType;
    }

    private String y_TokenType;

    public String getY_TokenType()
    {
        return this.y_TokenType;
    }

    public void setY_TokenType(String y_TokenType)
    {
        this.y_TokenType = y_TokenType;
    }

    private Long offChainVersion;

    public Long getOffChainVersion()
    {
        return this.offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion)
    {
        this.offChainVersion = offChainVersion;
    }

    private String createdBy;

    public String getCreatedBy()
    {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy)
    {
        this.createdBy = createdBy;
    }

    private Date createdAt;

    public Date getCreatedAt()
    {
        return this.createdAt;
    }

    public void setCreatedAt(Date createdAt)
    {
        this.createdAt = createdAt;
    }

    private String updatedBy;

    public String getUpdatedBy()
    {
        return this.updatedBy;
    }

    public void setUpdatedBy(String updatedBy)
    {
        this.updatedBy = updatedBy;
    }

    private Date updatedAt;

    public Date getUpdatedAt()
    {
        return this.updatedAt;
    }

    public void setUpdatedAt(Date updatedAt)
    {
        this.updatedAt = updatedAt;
    }


    public static class DtoConverter extends AbstractStateDtoConverter
    {
        public static Collection<String> collectionFieldNames = Arrays.asList(new String[]{});

        @Override
        protected boolean isCollectionField(String fieldName) {
            return CollectionUtils.collectionContainsIgnoringCase(collectionFieldNames, fieldName);
        }

        public BuyPoolStateDto[] toBuyPoolStateDtoArray(Iterable<BuyPoolState> states) {
            return toBuyPoolStateDtoList(states).toArray(new BuyPoolStateDto[0]);
        }

        public List<BuyPoolStateDto> toBuyPoolStateDtoList(Iterable<BuyPoolState> states) {
            ArrayList<BuyPoolStateDto> stateDtos = new ArrayList();
            for (BuyPoolState s : states) {
                BuyPoolStateDto dto = toBuyPoolStateDto(s);
                stateDtos.add(dto);
            }
            return stateDtos;
        }

        public BuyPoolStateDto toBuyPoolStateDto(BuyPoolState state)
        {
            if(state == null) {
                return null;
            }
            BuyPoolStateDto dto = new BuyPoolStateDto();
            if (returnedFieldsContains("Id")) {
                dto.setId(state.getId());
            }
            if (returnedFieldsContains("Version")) {
                dto.setVersion(state.getVersion());
            }
            if (returnedFieldsContains("X_Reserve")) {
                dto.setX_Reserve(state.getX_Reserve());
            }
            if (returnedFieldsContains("X_Amounts")) {
                dto.setX_Amounts(state.getX_Amounts());
            }
            if (returnedFieldsContains("X_TotalAmount")) {
                dto.setX_TotalAmount(state.getX_TotalAmount());
            }
            if (returnedFieldsContains("Y_Reserve")) {
                dto.setY_Reserve(state.getY_Reserve());
            }
            if (returnedFieldsContains("LiquidityTokenId")) {
                dto.setLiquidityTokenId(state.getLiquidityTokenId());
            }
            if (returnedFieldsContains("X_BoughtAmount")) {
                dto.setX_BoughtAmount(state.getX_BoughtAmount());
            }
            if (returnedFieldsContains("StartExchangeRateNumerator")) {
                dto.setStartExchangeRateNumerator(state.getStartExchangeRateNumerator());
            }
            if (returnedFieldsContains("ExchangeRateNumerator")) {
                dto.setExchangeRateNumerator(state.getExchangeRateNumerator());
            }
            if (returnedFieldsContains("ExchangeRateDenominator")) {
                dto.setExchangeRateDenominator(state.getExchangeRateDenominator());
            }
            if (returnedFieldsContains("PriceCurveType")) {
                dto.setPriceCurveType(state.getPriceCurveType());
            }
            if (returnedFieldsContains("PriceDeltaX_Amount")) {
                dto.setPriceDeltaX_Amount(state.getPriceDeltaX_Amount());
            }
            if (returnedFieldsContains("PriceDeltaNumerator")) {
                dto.setPriceDeltaNumerator(state.getPriceDeltaNumerator());
            }
            if (returnedFieldsContains("PriceDeltaDenominator")) {
                dto.setPriceDeltaDenominator(state.getPriceDeltaDenominator());
            }
            if (returnedFieldsContains("Active")) {
                dto.setActive(state.getActive());
            }
            if (returnedFieldsContains("X_TokenType")) {
                dto.setX_TokenType(state.getX_TokenType());
            }
            if (returnedFieldsContains("Y_TokenType")) {
                dto.setY_TokenType(state.getY_TokenType());
            }
            if (returnedFieldsContains("OffChainVersion")) {
                dto.setOffChainVersion(state.getOffChainVersion());
            }
            if (returnedFieldsContains("CreatedBy")) {
                dto.setCreatedBy(state.getCreatedBy());
            }
            if (returnedFieldsContains("CreatedAt")) {
                dto.setCreatedAt(state.getCreatedAt());
            }
            if (returnedFieldsContains("UpdatedBy")) {
                dto.setUpdatedBy(state.getUpdatedBy());
            }
            if (returnedFieldsContains("UpdatedAt")) {
                dto.setUpdatedAt(state.getUpdatedAt());
            }
            return dto;
        }

    }
}

