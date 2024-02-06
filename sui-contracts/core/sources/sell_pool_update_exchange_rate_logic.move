#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::sell_pool_update_exchange_rate_logic {
    use std::string;
    use std::type_name;

    use sui::tx_context;
    use sui::tx_context::TxContext;

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::sell_pool;
    use sui_swap_example::sell_pool_exchange_rate_updated;

    friend sui_swap_example::sell_pool_aggregate;

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
        sell_pool: &sell_pool::SellPool<X, Y>,
        ctx: &TxContext,
    ): sell_pool::SellPoolExchangeRateUpdated {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(sell_pool::liquidity_token_id(sell_pool) == liquidity_token_id, EInvalidLiquidityToken);

        assert!(start_exchange_rate_numerator > 0, EInvalidStartExchangeRateNumerator);
        assert!(exchange_rate_numerator > 0, EInvalidExchangeRateNumerator);
        assert!(exchange_rate_denominator > 0, EInvalidExchangeRateDenominator);
        assert!(price_delta_x_amount > 0, EInvalidPriceDeltaXAmount);
        assert!(price_delta_denominator > 0, EInvalidPriceDeltaDenominator);

        sell_pool::new_sell_pool_exchange_rate_updated(
            sell_pool,
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
        sell_pool_exchange_rate_updated: &sell_pool::SellPoolExchangeRateUpdated,
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let liquidity_token_id = sell_pool_exchange_rate_updated::liquidity_token_id(sell_pool_exchange_rate_updated);
        let exchange_rate_numerator = sell_pool_exchange_rate_updated::exchange_rate_numerator(
            sell_pool_exchange_rate_updated
        );
        let exchange_rate_denominator = sell_pool_exchange_rate_updated::exchange_rate_denominator(
            sell_pool_exchange_rate_updated
        );
        let price_delta_x_amount = sell_pool_exchange_rate_updated::price_delta_x_amount(
            sell_pool_exchange_rate_updated
        );
        let price_delta_numerator = sell_pool_exchange_rate_updated::price_delta_numerator(
            sell_pool_exchange_rate_updated
        );
        let price_delta_denominator = sell_pool_exchange_rate_updated::price_delta_denominator(
            sell_pool_exchange_rate_updated
        );
        // let provider = sell_pool_exchange_rate_updated::provider(sell_pool_exchange_rate_updated);
        // let x_token_type = sell_pool_exchange_rate_updated::x_token_type(sell_pool_exchange_rate_updated);
        // let y_token_type = sell_pool_exchange_rate_updated::y_token_type(sell_pool_exchange_rate_updated);
        // let id = sell_pool::id(sell_pool);

        sell_pool::set_exchange_rate_numerator(sell_pool, exchange_rate_numerator);
        sell_pool::set_exchange_rate_denominator(sell_pool, exchange_rate_denominator);
        sell_pool::set_price_delta_x_amount(sell_pool, price_delta_x_amount);
        sell_pool::set_price_delta_numerator(sell_pool, price_delta_numerator);
        sell_pool::set_price_delta_denominator(sell_pool, price_delta_denominator);
    }
}
