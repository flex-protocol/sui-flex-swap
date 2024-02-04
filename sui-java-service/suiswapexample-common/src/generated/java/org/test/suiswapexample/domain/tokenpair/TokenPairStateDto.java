// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;


public class TokenPairStateDto {

    private String id;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
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

    private BigInteger totalLiquidity;

    public BigInteger getTotalLiquidity()
    {
        return this.totalLiquidity;
    }

    public void setTotalLiquidity(BigInteger totalLiquidity)
    {
        this.totalLiquidity = totalLiquidity;
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

    private BigInteger feeNumerator;

    public BigInteger getFeeNumerator()
    {
        return this.feeNumerator;
    }

    public void setFeeNumerator(BigInteger feeNumerator)
    {
        this.feeNumerator = feeNumerator;
    }

    private BigInteger feeDenominator;

    public BigInteger getFeeDenominator()
    {
        return this.feeDenominator;
    }

    public void setFeeDenominator(BigInteger feeDenominator)
    {
        this.feeDenominator = feeDenominator;
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

        public TokenPairStateDto[] toTokenPairStateDtoArray(Iterable<TokenPairState> states) {
            return toTokenPairStateDtoList(states).toArray(new TokenPairStateDto[0]);
        }

        public List<TokenPairStateDto> toTokenPairStateDtoList(Iterable<TokenPairState> states) {
            ArrayList<TokenPairStateDto> stateDtos = new ArrayList();
            for (TokenPairState s : states) {
                TokenPairStateDto dto = toTokenPairStateDto(s);
                stateDtos.add(dto);
            }
            return stateDtos;
        }

        public TokenPairStateDto toTokenPairStateDto(TokenPairState state)
        {
            if(state == null) {
                return null;
            }
            TokenPairStateDto dto = new TokenPairStateDto();
            if (returnedFieldsContains("Id")) {
                dto.setId(state.getId());
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
            if (returnedFieldsContains("TotalLiquidity")) {
                dto.setTotalLiquidity(state.getTotalLiquidity());
            }
            if (returnedFieldsContains("LiquidityTokenId")) {
                dto.setLiquidityTokenId(state.getLiquidityTokenId());
            }
            if (returnedFieldsContains("FeeNumerator")) {
                dto.setFeeNumerator(state.getFeeNumerator());
            }
            if (returnedFieldsContains("FeeDenominator")) {
                dto.setFeeDenominator(state.getFeeDenominator());
            }
            if (returnedFieldsContains("Version")) {
                dto.setVersion(state.getVersion());
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

