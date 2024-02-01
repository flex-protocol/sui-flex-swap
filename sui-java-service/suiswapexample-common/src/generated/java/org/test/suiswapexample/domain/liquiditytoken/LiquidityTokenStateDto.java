// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.liquiditytoken;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;


public class LiquidityTokenStateDto {

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

        public LiquidityTokenStateDto[] toLiquidityTokenStateDtoArray(Iterable<LiquidityTokenState> states) {
            return toLiquidityTokenStateDtoList(states).toArray(new LiquidityTokenStateDto[0]);
        }

        public List<LiquidityTokenStateDto> toLiquidityTokenStateDtoList(Iterable<LiquidityTokenState> states) {
            ArrayList<LiquidityTokenStateDto> stateDtos = new ArrayList();
            for (LiquidityTokenState s : states) {
                LiquidityTokenStateDto dto = toLiquidityTokenStateDto(s);
                stateDtos.add(dto);
            }
            return stateDtos;
        }

        public LiquidityTokenStateDto toLiquidityTokenStateDto(LiquidityTokenState state)
        {
            if(state == null) {
                return null;
            }
            LiquidityTokenStateDto dto = new LiquidityTokenStateDto();
            if (returnedFieldsContains("Id")) {
                dto.setId(state.getId());
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

