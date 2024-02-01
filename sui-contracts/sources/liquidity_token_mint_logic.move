module sui_swap_example::liquidity_token_mint_logic {
    use sui::tx_context::TxContext;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token_minted;

    friend sui_swap_example::liquidity_token_aggregate;

    #[allow(unused_mut_parameter)]
    public(friend) fun verify<X, Y>(
        ctx: &mut TxContext,
    ): liquidity_token::LiquidityTokenMinted {
        let _ = ctx;
        liquidity_token::new_liquidity_token_minted<X, Y>(
        )
    }

    public(friend) fun mutate<X, Y>(
        liquidity_token_minted: &liquidity_token::LiquidityTokenMinted,
        ctx: &mut TxContext,
    ): liquidity_token::LiquidityToken<X, Y> {
        //let amount = liquidity_token_minted::amount(liquidity_token_minted);
        liquidity_token::new_liquidity_token(
            ctx,
        )
    }

}
