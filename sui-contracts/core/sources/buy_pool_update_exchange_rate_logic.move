#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::buy_pool_update_exchange_rate_logic {
    use std::string;
    use std::type_name;

    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::buy_pool;
    use sui_swap_example::buy_pool_exchange_rate_updated;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;

    friend sui_swap_example::buy_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EInvalidExchangeRateNumerator: u64 = 11;
    const EInvalidExchangeRateDenominator: u64 = 12;
    const EInvalidPriceDeltaXAmount: u64 = 13;
    const EInvalidPriceDeltaDenominator: u64 = 14;
    const EInvalidStartExchangeRateNumerator: u64 = 15;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        start_exchange_rate_numerator: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        buy_pool: &buy_pool::BuyPool<X, Y>,
        ctx: &TxContext,
    ): buy_pool::BuyPoolExchangeRateUpdated {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(buy_pool::liquidity_token_id(buy_pool) == liquidity_token_id, EInvalidLiquidityToken);

        assert!(start_exchange_rate_numerator > 0, EInvalidStartExchangeRateNumerator);
        assert!(exchange_rate_numerator > 0, EInvalidExchangeRateNumerator);
        assert!(exchange_rate_denominator > 0, EInvalidExchangeRateDenominator);
        assert!(price_delta_x_amount > 0, EInvalidPriceDeltaXAmount);
        assert!(price_delta_denominator > 0, EInvalidPriceDeltaDenominator);

        buy_pool::new_buy_pool_exchange_rate_updated(
            buy_pool,
            liquidity_token_id,
            start_exchange_rate_numerator,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        buy_pool_exchange_rate_updated: &buy_pool::BuyPoolExchangeRateUpdated,
        buy_pool: &mut buy_pool::BuyPool<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let start_exchange_rate_numerator = buy_pool_exchange_rate_updated::start_exchange_rate_numerator(
            buy_pool_exchange_rate_updated
        );
        let exchange_rate_numerator = buy_pool_exchange_rate_updated::exchange_rate_numerator(
            buy_pool_exchange_rate_updated
        );
        let exchange_rate_denominator = buy_pool_exchange_rate_updated::exchange_rate_denominator(
            buy_pool_exchange_rate_updated
        );
        let price_delta_x_amount = buy_pool_exchange_rate_updated::price_delta_x_amount(
            buy_pool_exchange_rate_updated
        );
        let price_delta_numerator = buy_pool_exchange_rate_updated::price_delta_numerator(
            buy_pool_exchange_rate_updated
        );
        let price_delta_denominator = buy_pool_exchange_rate_updated::price_delta_denominator(
            buy_pool_exchange_rate_updated
        );
        // let provider = buy_pool_exchange_rate_updated::provider(buy_pool_exchange_rate_updated);
        // let x_token_type = buy_pool_exchange_rate_updated::x_token_type(buy_pool_exchange_rate_updated);
        // let y_token_type = buy_pool_exchange_rate_updated::y_token_type(buy_pool_exchange_rate_updated);
        // let id = buy_pool::id(buy_pool);

        buy_pool::set_start_exchange_rate_numerator(buy_pool, start_exchange_rate_numerator);
        buy_pool::set_exchange_rate_numerator(buy_pool, exchange_rate_numerator);
        buy_pool::set_exchange_rate_denominator(buy_pool, exchange_rate_denominator);
        buy_pool::set_price_delta_x_amount(buy_pool, price_delta_x_amount);
        buy_pool::set_price_delta_numerator(buy_pool, price_delta_numerator);
        buy_pool::set_price_delta_denominator(buy_pool, price_delta_denominator);
    }
}
