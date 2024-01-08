module sui_swap_example::liquidity_token_destroy_logic {
    use sui::tx_context::TxContext;
    use sui_swap_example::liquidity_token;

    friend sui_swap_example::liquidity_token_aggregate;

    public(friend) fun verify<Y>(
        liquidity_token: &liquidity_token::LiquidityToken<Y>,
        ctx: &TxContext,
    ): liquidity_token::LiquidityTokenDestroyed {
        let _ = ctx;
        liquidity_token::new_liquidity_token_destroyed<Y>(
            liquidity_token,
            liquidity_token::amount(liquidity_token),
        )
    }

    public(friend) fun mutate<Y>(
        liquidity_token_destroyed: &liquidity_token::LiquidityTokenDestroyed,
        liquidity_token: liquidity_token::LiquidityToken<Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): liquidity_token::LiquidityToken<Y> {
        //let amount = liquidity_token_destroyed::amount(liquidity_token_destroyed);
        let id = liquidity_token::id(&liquidity_token);
        let _ = ctx;
        let _ = id;
        let _ = liquidity_token_destroyed;
        liquidity_token
    }

}
