#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_update_fee_rate_logic {
    use sui::tx_context::TxContext;

    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        fee_numerator: u64,
        fee_denominator: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        _ctx: &TxContext,
    ): token_pair::FeeRateUpdated {
        token_pair::new_fee_rate_updated(
            token_pair,
            fee_numerator,
            fee_denominator,
        )
    }

    public(friend) fun mutate<X, Y>(
        fee_rate_updated: &token_pair::FeeRateUpdated,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let fee_numerator = token_pair::fee_rate_updated_fee_numerator(fee_rate_updated);
        let fee_denominator = token_pair::fee_rate_updated_fee_denominator(fee_rate_updated);
        //let id = token_pair::id(token_pair);
        token_pair::set_fee_numerator(token_pair, fee_numerator);
        token_pair::set_fee_denominator(token_pair, fee_denominator);
    }
}
