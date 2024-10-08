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

    public SuiTokenPairStateRetriever(SuiJsonRpcClient suiJsonRpcClient,
                                  Function<String, TokenPairState.MutableTokenPairState> tokenPairStateFactory
    ) {
        this.suiJsonRpcClient = suiJsonRpcClient;
        this.tokenPairStateFactory = tokenPairStateFactory;
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
        tokenPairState.setX_Reserve(tokenPair.getX_Reserve());
        tokenPairState.setY_Reserve(tokenPair.getY_Reserve());
        tokenPairState.setTotalLiquidity(tokenPair.getTotalLiquidity());
        tokenPairState.setFeeNumerator(tokenPair.getFeeNumerator());
        tokenPairState.setFeeDenominator(tokenPair.getFeeDenominator());
        tokenPairState.setX_TokenType(typeArgs.get(0));
        tokenPairState.setY_TokenType(typeArgs.get(1));
        return tokenPairState;
    }

    
}

