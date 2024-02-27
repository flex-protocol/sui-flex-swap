// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.restful.resource;

import java.util.*;
import java.util.stream.*;
import javax.servlet.http.*;
import javax.validation.constraints.*;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import org.dddml.support.criterion.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.*;
import org.test.suiswapexample.domain.tokenpair.*;
import static org.test.suiswapexample.domain.meta.M.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.dddml.support.criterion.TypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RequestMapping(path = "TokenPairs", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class TokenPairResource {
    private Logger logger = LoggerFactory.getLogger(this.getClass());


    @Autowired
    private TokenPairApplicationService tokenPairApplicationService;


    /**
     * Retrieve.
     * Retrieve TokenPairs
     */
    @GetMapping
    @Transactional(readOnly = true)
    public TokenPairStateDto[] getAll( HttpServletRequest request,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "firstResult", defaultValue = "0") Integer firstResult,
                    @RequestParam(value = "maxResults", defaultValue = "2147483647") Integer maxResults,
                    @RequestParam(value = "filter", required = false) String filter) {
        try {
        if (firstResult < 0) { firstResult = 0; }
        if (maxResults == null || maxResults < 1) { maxResults = Integer.MAX_VALUE; }

            Iterable<TokenPairState> states = null; 
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> TokenPairResourceUtils.getFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (TokenPairMetadata.aliasMap.containsKey(n) ? TokenPairMetadata.aliasMap.get(n) : n));
            states = tokenPairApplicationService.get(
                c,
                TokenPairResourceUtils.getQuerySorts(request.getParameterMap()),
                firstResult, maxResults);

            TokenPairStateDto.DtoConverter dtoConverter = new TokenPairStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toTokenPairStateDtoArray(states);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve in pages.
     * Retrieve TokenPairs in pages.
     */
    @GetMapping("_page")
    @Transactional(readOnly = true)
    public Page<TokenPairStateDto> getPage( HttpServletRequest request,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "page", defaultValue = "0") Integer page,
                    @RequestParam(value = "size", defaultValue = "20") Integer size,
                    @RequestParam(value = "filter", required = false) String filter) {
        try {
            Integer firstResult = (page == null ? 0 : page) * (size == null ? 20 : size);
            Integer maxResults = (size == null ? 20 : size);
            Iterable<TokenPairState> states = null; 
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> TokenPairResourceUtils.getFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (TokenPairMetadata.aliasMap.containsKey(n) ? TokenPairMetadata.aliasMap.get(n) : n));
            states = tokenPairApplicationService.get(
                c,
                TokenPairResourceUtils.getQuerySorts(request.getParameterMap()),
                firstResult, maxResults);
            long count = tokenPairApplicationService.getCount(c);

            TokenPairStateDto.DtoConverter dtoConverter = new TokenPairStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            Page.PageImpl<TokenPairStateDto> statePage =  new Page.PageImpl<>(dtoConverter.toTokenPairStateDtoList(states), count);
            statePage.setSize(size);
            statePage.setNumber(page);
            return statePage;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves TokenPair with the specified ID.
     */
    @GetMapping("{id}")
    @Transactional(readOnly = true)
    public TokenPairStateDto get(@PathVariable("id") String id, @RequestParam(value = "fields", required = false) String fields) {
        try {
            String idObj = id;
            TokenPairState state = tokenPairApplicationService.get(idObj);
            if (state == null) { return null; }

            TokenPairStateDto.DtoConverter dtoConverter = new TokenPairStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toTokenPairStateDto(state);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("_count")
    @Transactional(readOnly = true)
    public long getCount( HttpServletRequest request,
                         @RequestParam(value = "filter", required = false) String filter) {
        try {
            long count = 0;
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap());
            }
            Criterion c = CriterionDto.toSubclass(criterion,
                getCriterionTypeConverter(), 
                getPropertyTypeResolver(), 
                n -> (TokenPairMetadata.aliasMap.containsKey(n) ? TokenPairMetadata.aliasMap.get(n) : n));
            count = tokenPairApplicationService.getCount(c);
            return count;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{id}/_commands/Destroy")
    public void destroy(@PathVariable("id") String id, @RequestBody TokenPairCommands.Destroy content) {
        try {

            TokenPairCommands.Destroy cmd = content;//.toDestroy();
            String idObj = id;
            if (cmd.getId() == null) {
                cmd.setId(idObj);
            } else if (!cmd.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, cmd.getId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            tokenPairApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{id}/_commands/UpdateFeeRate")
    public void updateFeeRate(@PathVariable("id") String id, @RequestBody TokenPairCommands.UpdateFeeRate content) {
        try {

            TokenPairCommands.UpdateFeeRate cmd = content;//.toUpdateFeeRate();
            String idObj = id;
            if (cmd.getId() == null) {
                cmd.setId(idObj);
            } else if (!cmd.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, cmd.getId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            tokenPairApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("_metadata/filteringFields")
    public List<PropertyMetadataDto> getMetadataFilteringFields() {
        try {

            List<PropertyMetadataDto> filtering = new ArrayList<>();
            TokenPairMetadata.propertyTypeMap.forEach((key, value) -> {
                filtering.add(new PropertyMetadataDto(key, value, true));
            });
            return filtering;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("{id}/_events/{version}")
    @Transactional(readOnly = true)
    public TokenPairEvent getEvent(@PathVariable("id") String id, @PathVariable("version") long version) {
        try {

            String idObj = id;
            //TokenPairStateEventDtoConverter dtoConverter = getTokenPairStateEventDtoConverter();
            return tokenPairApplicationService.getEvent(idObj, version);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("{id}/_historyStates/{version}")
    @Transactional(readOnly = true)
    public TokenPairStateDto getHistoryState(@PathVariable("id") String id, @PathVariable("version") long version, @RequestParam(value = "fields", required = false) String fields) {
        try {

            String idObj = id;
            TokenPairStateDto.DtoConverter dtoConverter = new TokenPairStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toTokenPairStateDto(tokenPairApplicationService.getHistoryState(idObj, version));

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves TokenPairX_ReserveItem with the specified Key.
     */
    @GetMapping("{id}/TokenPairX_ReserveItems/{key}")
    @Transactional(readOnly = true)
    public TokenPairX_ReserveItemStateDto getTokenPairX_ReserveItem(@PathVariable("id") String id, @PathVariable("key") String key) {
        try {

            TokenPairX_ReserveItemState state = tokenPairApplicationService.getTokenPairX_ReserveItem(id, key);
            if (state == null) { return null; }
            TokenPairX_ReserveItemStateDto.DtoConverter dtoConverter = new TokenPairX_ReserveItemStateDto.DtoConverter();
            TokenPairX_ReserveItemStateDto stateDto = dtoConverter.toTokenPairX_ReserveItemStateDto(state);
            dtoConverter.setAllFieldsReturned(true);
            return stateDto;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * TokenPairX_ReserveItem List
     */
    @GetMapping("{id}/TokenPairX_ReserveItems")
    @Transactional(readOnly = true)
    public TokenPairX_ReserveItemStateDto[] getTokenPairX_ReserveItems(@PathVariable("id") String id,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "filter", required = false) String filter,
                     HttpServletRequest request) {
        try {
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> TokenPairResourceUtils.getTokenPairX_ReserveItemFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (TokenPairX_ReserveItemMetadata.aliasMap.containsKey(n) ? TokenPairX_ReserveItemMetadata.aliasMap.get(n) : n));
            Iterable<TokenPairX_ReserveItemState> states = tokenPairApplicationService.getTokenPairX_ReserveItems(id, c,
                    TokenPairResourceUtils.getTokenPairX_ReserveItemQuerySorts(request.getParameterMap()));
            if (states == null) { return null; }
            TokenPairX_ReserveItemStateDto.DtoConverter dtoConverter = new TokenPairX_ReserveItemStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toTokenPairX_ReserveItemStateDtoArray(states);
        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves TokenPairX_AmountsItem with the specified Key.
     */
    @GetMapping("{id}/TokenPairX_AmountsItems/{key}")
    @Transactional(readOnly = true)
    public TokenPairX_AmountsItemStateDto getTokenPairX_AmountsItem(@PathVariable("id") String id, @PathVariable("key") String key) {
        try {

            TokenPairX_AmountsItemState state = tokenPairApplicationService.getTokenPairX_AmountsItem(id, key);
            if (state == null) { return null; }
            TokenPairX_AmountsItemStateDto.DtoConverter dtoConverter = new TokenPairX_AmountsItemStateDto.DtoConverter();
            TokenPairX_AmountsItemStateDto stateDto = dtoConverter.toTokenPairX_AmountsItemStateDto(state);
            dtoConverter.setAllFieldsReturned(true);
            return stateDto;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * TokenPairX_AmountsItem List
     */
    @GetMapping("{id}/TokenPairX_AmountsItems")
    @Transactional(readOnly = true)
    public TokenPairX_AmountsItemStateDto[] getTokenPairX_AmountsItems(@PathVariable("id") String id,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "filter", required = false) String filter,
                     HttpServletRequest request) {
        try {
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> TokenPairResourceUtils.getTokenPairX_AmountsItemFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (TokenPairX_AmountsItemMetadata.aliasMap.containsKey(n) ? TokenPairX_AmountsItemMetadata.aliasMap.get(n) : n));
            Iterable<TokenPairX_AmountsItemState> states = tokenPairApplicationService.getTokenPairX_AmountsItems(id, c,
                    TokenPairResourceUtils.getTokenPairX_AmountsItemQuerySorts(request.getParameterMap()));
            if (states == null) { return null; }
            TokenPairX_AmountsItemStateDto.DtoConverter dtoConverter = new TokenPairX_AmountsItemStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toTokenPairX_AmountsItemStateDtoArray(states);
        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }



    //protected  TokenPairStateEventDtoConverter getTokenPairStateEventDtoConverter() {
    //    return new TokenPairStateEventDtoConverter();
    //}

    protected TypeConverter getCriterionTypeConverter() {
        return new DefaultTypeConverter();
    }

    protected PropertyTypeResolver getPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return TokenPairResourceUtils.getFilterPropertyType(propertyName);
            }
        };
    }

    protected PropertyTypeResolver getTokenPairX_ReserveItemPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return TokenPairResourceUtils.getTokenPairX_ReserveItemFilterPropertyType(propertyName);
            }
        };
    }

    protected PropertyTypeResolver getTokenPairX_AmountsItemPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return TokenPairResourceUtils.getTokenPairX_AmountsItemFilterPropertyType(propertyName);
            }
        };
    }

    // ////////////////////////////////
 
    public static class TokenPairResourceUtils {

        public static void setNullIdOrThrowOnInconsistentIds(String id, TokenPairCommand value) {
            String idObj = id;
            if (value.getId() == null) {
                value.setId(idObj);
            } else if (!value.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, value.getId());
            }
        }
    
        public static List<String> getQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, TokenPairMetadata.aliasMap);
        }

        public static List<String> getQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, TokenPairMetadata.aliasMap);
        }

        public static String getFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (TokenPairMetadata.aliasMap.containsKey(fieldName)) {
                return TokenPairMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getFilterPropertyType(String propertyName) {
            if (TokenPairMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = TokenPairMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static List<String> getTokenPairX_ReserveItemQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, TokenPairX_ReserveItemMetadata.aliasMap);
        }

        public static List<String> getTokenPairX_ReserveItemQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, TokenPairX_ReserveItemMetadata.aliasMap);
        }

        public static String getTokenPairX_ReserveItemFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (TokenPairX_ReserveItemMetadata.aliasMap.containsKey(fieldName)) {
                return TokenPairX_ReserveItemMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getTokenPairX_ReserveItemFilterPropertyType(String propertyName) {
            if (TokenPairX_ReserveItemMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = TokenPairX_ReserveItemMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getTokenPairX_ReserveItemQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getTokenPairX_ReserveItemFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getTokenPairX_ReserveItemFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static List<String> getTokenPairX_AmountsItemQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, TokenPairX_AmountsItemMetadata.aliasMap);
        }

        public static List<String> getTokenPairX_AmountsItemQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, TokenPairX_AmountsItemMetadata.aliasMap);
        }

        public static String getTokenPairX_AmountsItemFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (TokenPairX_AmountsItemMetadata.aliasMap.containsKey(fieldName)) {
                return TokenPairX_AmountsItemMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getTokenPairX_AmountsItemFilterPropertyType(String propertyName) {
            if (TokenPairX_AmountsItemMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = TokenPairX_AmountsItemMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getTokenPairX_AmountsItemQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getTokenPairX_AmountsItemFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getTokenPairX_AmountsItemFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static TokenPairStateDto[] toTokenPairStateDtoArray(Iterable<String> ids) {
            List<TokenPairStateDto> states = new ArrayList<>();
            ids.forEach(i -> {
                TokenPairStateDto dto = new TokenPairStateDto();
                dto.setId(i);
                states.add(dto);
            });
            return states.toArray(new TokenPairStateDto[0]);
        }

    }

}

