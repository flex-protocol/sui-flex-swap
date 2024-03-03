// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.sui.contract.service;

import com.github.wubuku.sui.bean.*;
import com.github.wubuku.sui.utils.*;
import org.test.suiswapexample.domain.tokenpair.*;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.sui.contract.DomainBeanUtils;
import org.test.suiswapexample.sui.contract.TokenPair;

import java.util.*;
import java.math.*;
import java.util.function.*;

public class SuiTokenPairStateRetriever {

    private SuiJsonRpcClient suiJsonRpcClient;

    private Function<String, TokenPairState.MutableTokenPairState> tokenPairStateFactory;
    private BiFunction<TokenPairState, String, TokenPairX_ReserveItemState.MutableTokenPairX_ReserveItemState> tokenPairX_ReserveItemStateFactory;
    private BiFunction<TokenPairState, String, TokenPairX_AmountsItemState.MutableTokenPairX_AmountsItemState> tokenPairX_AmountsItemStateFactory;

    public SuiTokenPairStateRetriever(SuiJsonRpcClient suiJsonRpcClient,
                                  Function<String, TokenPairState.MutableTokenPairState> tokenPairStateFactory,
                                  BiFunction<TokenPairState, String, TokenPairX_ReserveItemState.MutableTokenPairX_ReserveItemState> tokenPairX_ReserveItemStateFactory,
                                  BiFunction<TokenPairState, String, TokenPairX_AmountsItemState.MutableTokenPairX_AmountsItemState> tokenPairX_AmountsItemStateFactory
    ) {
        this.suiJsonRpcClient = suiJsonRpcClient;
        this.tokenPairStateFactory = tokenPairStateFactory;
        this.tokenPairX_ReserveItemStateFactory = tokenPairX_ReserveItemStateFactory;
        this.tokenPairX_AmountsItemStateFactory = tokenPairX_AmountsItemStateFactory;
    }

    public TokenPairState retrieveTokenPairState(String objectId) {
        SuiMoveObjectResponse<TokenPair> getObjectDataResponse = suiJsonRpcClient.getMoveObject(
                objectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), TokenPair.class
        );
        if (getObjectDataResponse.getData() == null) {
            return null;
        }
        TokenPair tokenPair = getObjectDataResponse.getData().getContent().getFields();
        List<String> typeArgs = DomainBeanUtils.extractTypeArguments(getObjectDataResponse.getData().getContent().getType());
        return toTokenPairState(tokenPair, typeArgs);
    }

    private TokenPairState toTokenPairState(TokenPair tokenPair , List<String> typeArgs) {
        TokenPairState.MutableTokenPairState tokenPairState = tokenPairStateFactory.apply(tokenPair.getId().getId());
        tokenPairState.setVersion(tokenPair.getVersion());
        tokenPairState.setX_Reserve(DomainBeanUtils.toObjectTable(tokenPair.getX_Reserve()));
        tokenPairState.setX_Amounts(DomainBeanUtils.toTable(tokenPair.getX_Amounts()));
        tokenPairState.setX_TotalAmount(tokenPair.getX_TotalAmount());
        tokenPairState.setY_Reserve(tokenPair.getY_Reserve());
        tokenPairState.setTotalLiquidity(tokenPair.getTotalLiquidity());
        tokenPairState.setLiquidityTokenId(tokenPair.getLiquidityTokenId());
        tokenPairState.setFeeNumerator(tokenPair.getFeeNumerator());
        tokenPairState.setFeeDenominator(tokenPair.getFeeDenominator());
        tokenPairState.setX_TokenType(typeArgs.get(0));
        tokenPairState.setY_TokenType(typeArgs.get(1));
        if (tokenPair.getX_Reserve() != null) {
            String tokenPairX_ReserveItemTableId = tokenPair.getX_Reserve().getFields().getId().getId();
            List<TokenPairX_ReserveItemState> tokenPairX_ReserveItems = getTokenPairX_ReserveItems(tokenPairState, tokenPairX_ReserveItemTableId);
            for (TokenPairX_ReserveItemState i : tokenPairX_ReserveItems) {
                ((EntityStateCollection.ModifiableEntityStateCollection)tokenPairState.getTokenPairX_ReserveItems()).add(i);
            }
        }

        if (tokenPair.getX_Amounts() != null) {
            String tokenPairX_AmountsItemTableId = tokenPair.getX_Amounts().getFields().getId().getId();
            List<TokenPairX_AmountsItemState> tokenPairX_AmountsItems = getTokenPairX_AmountsItems(tokenPairState, tokenPairX_AmountsItemTableId);
            for (TokenPairX_AmountsItemState i : tokenPairX_AmountsItems) {
                ((EntityStateCollection.ModifiableEntityStateCollection)tokenPairState.getTokenPairX_AmountsItems()).add(i);
            }
        }

        return tokenPairState;
    }

    private TokenPairX_ReserveItemState toTokenPairX_ReserveItemState(TokenPairState tokenPairState, String key, java.util.Map<String, Object> value) {
        TokenPairX_ReserveItemState.MutableTokenPairX_ReserveItemState tokenPairX_ReserveItemState = tokenPairX_ReserveItemStateFactory.apply(tokenPairState, key);
        tokenPairX_ReserveItemState.setValue(value);
        return tokenPairX_ReserveItemState;
    }

    private TokenPairX_AmountsItemState toTokenPairX_AmountsItemState(TokenPairState tokenPairState, String key, BigInteger value) {
        TokenPairX_AmountsItemState.MutableTokenPairX_AmountsItemState tokenPairX_AmountsItemState = tokenPairX_AmountsItemStateFactory.apply(tokenPairState, key);
        tokenPairX_AmountsItemState.setValue(value);
        return tokenPairX_AmountsItemState;
    }

    private List<TokenPairX_ReserveItemState> getTokenPairX_ReserveItems(TokenPairState tokenPairState, String tokenPairX_ReserveItemTableId) {
        List<TokenPairX_ReserveItemState> tokenPairX_ReserveItems = new ArrayList<>();
        String cursor = null;
        while (true) {
            DynamicFieldPage<String> tokenPairX_ReserveItemFieldPage = suiJsonRpcClient.getDynamicFields(tokenPairX_ReserveItemTableId, cursor, null, String.class);
            for (DynamicFieldInfo<String> tokenPairX_ReserveItemFieldInfo : tokenPairX_ReserveItemFieldPage.getData()) {
                String fieldObjectId = tokenPairX_ReserveItemFieldInfo.getObjectId();
                SuiMoveObjectResponse<java.util.Map<String, Object>> getTokenPairX_ReserveItemObjectResponse
                        = suiJsonRpcClient.getMoveObject(fieldObjectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), new com.fasterxml.jackson.core.type.TypeReference<SuiMoveObjectResponse<java.util.Map<String, Object>>>() {});
                String key = tokenPairX_ReserveItemFieldInfo.getName().getValue();
                java.util.Map<String, Object> value = getTokenPairX_ReserveItemObjectResponse.getData().getContent().getFields();
                TokenPairX_ReserveItemState tokenPairX_ReserveItemState = toTokenPairX_ReserveItemState(tokenPairState, key, value);
                tokenPairX_ReserveItems.add(tokenPairX_ReserveItemState);
            }
            cursor = tokenPairX_ReserveItemFieldPage.getNextCursor();
            if (!Page.hasNextPage(tokenPairX_ReserveItemFieldPage)) {
                break;
            }
        }
        return tokenPairX_ReserveItems;
    }

    private List<TokenPairX_AmountsItemState> getTokenPairX_AmountsItems(TokenPairState tokenPairState, String tokenPairX_AmountsItemTableId) {
        List<TokenPairX_AmountsItemState> tokenPairX_AmountsItems = new ArrayList<>();
        String cursor = null;
        while (true) {
            DynamicFieldPage<?> tokenPairX_AmountsItemFieldPage = suiJsonRpcClient.getDynamicFields(tokenPairX_AmountsItemTableId, cursor, null);
            for (DynamicFieldInfo tokenPairX_AmountsItemFieldInfo : tokenPairX_AmountsItemFieldPage.getData()) {
                String fieldObjectId = tokenPairX_AmountsItemFieldInfo.getObjectId();
                SuiMoveObjectResponse<SimpleDynamicField<String, BigInteger>> getTokenPairX_AmountsItemFieldResponse
                        = suiJsonRpcClient.getMoveObject(fieldObjectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), new com.fasterxml.jackson.core.type.TypeReference<SuiMoveObjectResponse<SimpleDynamicField<String, BigInteger>>>() {});
                String key = getTokenPairX_AmountsItemFieldResponse.getData().getContent().getFields().getName();
                BigInteger value = getTokenPairX_AmountsItemFieldResponse.getData().getContent().getFields().getValue();
                TokenPairX_AmountsItemState tokenPairX_AmountsItemState = toTokenPairX_AmountsItemState(tokenPairState, key, value);
                tokenPairX_AmountsItems.add(tokenPairX_AmountsItemState);
            }
            cursor = tokenPairX_AmountsItemFieldPage.getNextCursor();
            if (!Page.hasNextPage(tokenPairX_AmountsItemFieldPage)) {
                break;
            }
        }
        return tokenPairX_AmountsItems;
    }

    
}

