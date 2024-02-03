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
import org.test.suiswapexample.domain.AbstractEvent;

public abstract class AbstractExchangeEvent extends AbstractEvent implements ExchangeEvent.SqlExchangeEvent, SuiEventEnvelope.MutableSuiEventEnvelope, SuiMoveEvent.MutableSuiMoveEvent, HasStatus.MutableHasStatus {
    private ExchangeEventId exchangeEventId = new ExchangeEventId();

    public ExchangeEventId getExchangeEventId() {
        return this.exchangeEventId;
    }

    public void setExchangeEventId(ExchangeEventId eventId) {
        this.exchangeEventId = eventId;
    }
    
    public String getId() {
        return getExchangeEventId().getId();
    }

    public void setId(String id) {
        getExchangeEventId().setId(id);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    public BigInteger getVersion() {
        return getExchangeEventId().getVersion();
    }
    
    public void setVersion(BigInteger version) {
        getExchangeEventId().setVersion(version);
    }

    private Long suiTimestamp;

    public Long getSuiTimestamp() {
        return this.suiTimestamp;
    }
    
    public void setSuiTimestamp(Long suiTimestamp) {
        this.suiTimestamp = suiTimestamp;
    }

    private String suiTxDigest;

    public String getSuiTxDigest() {
        return this.suiTxDigest;
    }
    
    public void setSuiTxDigest(String suiTxDigest) {
        this.suiTxDigest = suiTxDigest;
    }

    private BigInteger suiEventSeq;

    public BigInteger getSuiEventSeq() {
        return this.suiEventSeq;
    }
    
    public void setSuiEventSeq(BigInteger suiEventSeq) {
        this.suiEventSeq = suiEventSeq;
    }

    private String suiPackageId;

    public String getSuiPackageId() {
        return this.suiPackageId;
    }
    
    public void setSuiPackageId(String suiPackageId) {
        this.suiPackageId = suiPackageId;
    }

    private String suiTransactionModule;

    public String getSuiTransactionModule() {
        return this.suiTransactionModule;
    }
    
    public void setSuiTransactionModule(String suiTransactionModule) {
        this.suiTransactionModule = suiTransactionModule;
    }

    private String suiSender;

    public String getSuiSender() {
        return this.suiSender;
    }
    
    public void setSuiSender(String suiSender) {
        this.suiSender = suiSender;
    }

    private String suiType;

    public String getSuiType() {
        return this.suiType;
    }
    
    public void setSuiType(String suiType) {
        this.suiType = suiType;
    }

    private String status;

    public String getStatus() {
        return this.status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }

    private String createdBy;

    public String getCreatedBy() {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    private Date createdAt;

    public Date getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }


    private String commandId;

    public String getCommandId() {
        return commandId;
    }

    public void setCommandId(String commandId) {
        this.commandId = commandId;
    }

    private String commandType;

    public String getCommandType() {
        return commandType;
    }

    public void setCommandType(String commandType) {
        this.commandType = commandType;
    }

    protected AbstractExchangeEvent() {
    }

    protected AbstractExchangeEvent(ExchangeEventId eventId) {
        this.exchangeEventId = eventId;
    }


    public abstract String getEventType();

    public static class ExchangeClobEvent extends AbstractExchangeEvent {

        protected Map<String, Object> getDynamicProperties() {
            return dynamicProperties;
        }

        protected void setDynamicProperties(Map<String, Object> dynamicProperties) {
            if (dynamicProperties == null) {
                throw new IllegalArgumentException("dynamicProperties is null.");
            }
            this.dynamicProperties = dynamicProperties;
        }

        private Map<String, Object> dynamicProperties = new HashMap<>();

        protected String getDynamicPropertiesLob() {
            return ApplicationContext.current.getClobConverter().toString(getDynamicProperties());
        }

        protected void setDynamicPropertiesLob(String text) {
            getDynamicProperties().clear();
            Map<String, Object> ps = ApplicationContext.current.getClobConverter().parseLobProperties(text);
            if (ps != null) {
                for (Map.Entry<String, Object> kv : ps.entrySet()) {
                    getDynamicProperties().put(kv.getKey(), kv.getValue());
                }
            }
        }

        @Override
        public String getEventType() {
            return "ExchangeClobEvent";
        }

    }

    public static class InitExchangeEvent extends ExchangeClobEvent implements ExchangeEvent.InitExchangeEvent {

        @Override
        public String getEventType() {
            return "InitExchangeEvent";
        }

    }

    public static class TokenPairAddedToExchange extends ExchangeClobEvent implements ExchangeEvent.TokenPairAddedToExchange {

        @Override
        public String getEventType() {
            return "TokenPairAddedToExchange";
        }

        public String getTokenPairId() {
            Object val = getDynamicProperties().get("tokenPairId");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setTokenPairId(String value) {
            getDynamicProperties().put("tokenPairId", value);
        }

        public String getX_TokenType() {
            Object val = getDynamicProperties().get("x_TokenType");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setX_TokenType(String value) {
            getDynamicProperties().put("x_TokenType", value);
        }

        public String getY_TokenType() {
            Object val = getDynamicProperties().get("y_TokenType");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setY_TokenType(String value) {
            getDynamicProperties().put("y_TokenType", value);
        }

    }

    public static class SellPoolAddedToExchange extends ExchangeClobEvent implements ExchangeEvent.SellPoolAddedToExchange {

        @Override
        public String getEventType() {
            return "SellPoolAddedToExchange";
        }

        public String getSellPoolId() {
            Object val = getDynamicProperties().get("sellPoolId");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setSellPoolId(String value) {
            getDynamicProperties().put("sellPoolId", value);
        }

        public String getX_TokenType() {
            Object val = getDynamicProperties().get("x_TokenType");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setX_TokenType(String value) {
            getDynamicProperties().put("x_TokenType", value);
        }

        public String getY_TokenType() {
            Object val = getDynamicProperties().get("y_TokenType");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setY_TokenType(String value) {
            getDynamicProperties().put("y_TokenType", value);
        }

    }

    public static class ExchangeUpdated extends ExchangeClobEvent implements ExchangeEvent.ExchangeUpdated {

        @Override
        public String getEventType() {
            return "ExchangeUpdated";
        }

        public String getName() {
            Object val = getDynamicProperties().get("name");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setName(String value) {
            getDynamicProperties().put("name", value);
        }

    }


}

