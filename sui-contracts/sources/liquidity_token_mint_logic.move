module sui_swap_example::liquidity_token_mint_logic {
    use std::string::String;
    use sui::tx_context::TxContext;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token_minted;

    friend sui_swap_example::liquidity_token_aggregate;

    #[allow(unused_mut_parameter)]
    public(friend) fun verify<Y>(
        x_token_type: String,
        amount: u64,
        ctx: &mut TxContext,
    ): liquidity_token::LiquidityTokenMinted {
        let _ = ctx;
        liquidity_token::new_liquidity_token_minted<Y>(
            x_token_type,
            amount,
        )
    }

    public(friend) fun mutate<Y>(
        liquidity_token_minted: &liquidity_token::LiquidityTokenMinted,
        ctx: &mut TxContext,
    ): liquidity_token::LiquidityToken<Y> {
        let x_token_type = liquidity_token_minted::x_token_type(liquidity_token_minted);
        let amount = liquidity_token_minted::amount(liquidity_token_minted);
        liquidity_token::new_liquidity_token(
            x_token_type,
            amount,
            ctx,
        )
    }

}
