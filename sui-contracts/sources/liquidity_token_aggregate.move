// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::liquidity_token_aggregate {
    use sui::tx_context;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token_destroy_logic;
    use sui_swap_example::liquidity_token_mint_logic;

    friend sui_swap_example::token_pair_initialize_token_pair_logic;
    friend sui_swap_example::token_pair_service;

    #[allow(unused_mut_parameter)]
    public(friend) fun mint<X, Y>(
        ctx: &mut tx_context::TxContext,
    ): liquidity_token::LiquidityToken<X, Y> {
        let liquidity_token_minted = liquidity_token_mint_logic::verify<X, Y>(
            ctx,
        );
        let liquidity_token = liquidity_token_mint_logic::mutate<X, Y>(
            &liquidity_token_minted,
            ctx,
        );
        liquidity_token::set_liquidity_token_minted_id(&mut liquidity_token_minted, liquidity_token::id(&liquidity_token));
        liquidity_token::emit_liquidity_token_minted(liquidity_token_minted);
        liquidity_token
    }

    #[allow(unused_mut_parameter)]
    public(friend) fun destroy<X, Y>(
        liquidity_token: liquidity_token::LiquidityToken<X, Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let liquidity_token_destroyed = liquidity_token_destroy_logic::verify<X, Y>(
            &liquidity_token,
            ctx,
        );
        let updated_liquidity_token = liquidity_token_destroy_logic::mutate<X, Y>(
            &liquidity_token_destroyed,
            liquidity_token,
            ctx,
        );
        liquidity_token::drop_liquidity_token(updated_liquidity_token);
        liquidity_token::emit_liquidity_token_destroyed(liquidity_token_destroyed);
    }

}
