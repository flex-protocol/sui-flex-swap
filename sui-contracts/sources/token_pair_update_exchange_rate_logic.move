#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_update_exchange_rate_logic {
    use std::string;
    use std::type_name;

    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::exchange_rate_updated;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidLiquidityToken: u64 = 10;

    public(friend) fun verify<X, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::ExchangeRateUpdated {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(token_pair::liquidity_token_id(token_pair) == liquidity_token_id, EInvalidLiquidityToken);

        token_pair::new_exchange_rate_updated(
            token_pair,
            liquidity_token_id,
            exchange_rate_numerator,
            exchange_rate_denominator,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
        )
    }

    public(friend) fun mutate<X, Y>(
        exchange_rate_updated: &token_pair::ExchangeRateUpdated,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let liquidity_token_id = exchange_rate_updated::liquidity_token_id(exchange_rate_updated);
        let exchange_rate_numerator = exchange_rate_updated::exchange_rate_numerator(exchange_rate_updated);
        let exchange_rate_denominator = exchange_rate_updated::exchange_rate_denominator(exchange_rate_updated);
        let provider = exchange_rate_updated::provider(exchange_rate_updated);
        let x_token_type = exchange_rate_updated::x_token_type(exchange_rate_updated);
        let y_token_type = exchange_rate_updated::y_token_type(exchange_rate_updated);
        let id = token_pair::id(token_pair);
        token_pair::set_exchange_rate_numerator(token_pair, exchange_rate_numerator);
        token_pair::set_exchange_rate_denominator(token_pair, exchange_rate_denominator);
    }
}
