#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_update_fee_rate_logic {
    use sui::tx_context::TxContext;

    use sui_swap_example::fee_rate_updated;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidLiquidityToken: u64 = 10;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        fee_numerator: u64,
        fee_denominator: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        _ctx: &TxContext,
    ): token_pair::FeeRateUpdated {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(token_pair::liquidity_token_id(token_pair) == liquidity_token_id, EInvalidLiquidityToken);

        token_pair::new_fee_rate_updated(
            token_pair,
            liquidity_token_id,
            fee_numerator,
            fee_denominator,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        fee_rate_updated: &token_pair::FeeRateUpdated,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let liquidity_token_id = fee_rate_updated::liquidity_token_id(fee_rate_updated);
        let fee_numerator = fee_rate_updated::fee_numerator(fee_rate_updated);
        let fee_denominator = fee_rate_updated::fee_denominator(fee_rate_updated);
        //let id = token_pair::id(token_pair);

        token_pair::set_fee_numerator(token_pair, fee_numerator);
        token_pair::set_fee_denominator(token_pair, fee_denominator);
    }
}
