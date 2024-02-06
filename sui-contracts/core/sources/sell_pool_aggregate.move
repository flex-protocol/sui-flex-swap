// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::sell_pool_aggregate {
    use sui::balance::Balance;
    use sui::object::ID;
    use sui::tx_context;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::sell_pool;
    use sui_swap_example::sell_pool_add_x_token_logic;
    use sui_swap_example::sell_pool_buy_x_logic;
    use sui_swap_example::sell_pool_destroy_logic;
    use sui_swap_example::sell_pool_initialize_sell_pool_logic;
    use sui_swap_example::sell_pool_remove_x_token_logic;
    use sui_swap_example::sell_pool_update_exchange_rate_logic;
    use sui_swap_example::sell_pool_withdraw_y_reserve_logic;

    friend sui_swap_example::token_pair_service;
    friend sui_swap_example::token_pair_service_process;
    friend sui_swap_example::sell_pool_service;
    friend sui_swap_example::sell_pool_service_process;
    friend sui_swap_example::nft_service;

    #[allow(unused_mut_parameter)]
    public(friend) fun initialize_sell_pool<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        x_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut tx_context::TxContext,
    ): (sell_pool::SellPool<X, Y>, LiquidityToken<X, Y>) {
        let sell_pool_initialized = sell_pool_initialize_sell_pool_logic::verify<X, Y>(
            exchange,
            &x,
            x_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            ctx,
        );
        let (sell_pool, liquidity_token) = sell_pool_initialize_sell_pool_logic::mutate<X, Y>(
            &mut sell_pool_initialized,
            x,
            exchange,
            ctx,
        );
        sell_pool::set_sell_pool_initialized_id(&mut sell_pool_initialized, sell_pool::id(&sell_pool));
        sell_pool::emit_sell_pool_initialized(sell_pool_initialized);
        (sell_pool, liquidity_token)
    }

    #[allow(unused_mut_parameter)]
    public entry fun update_exchange_rate<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        sell_pool::assert_schema_version(sell_pool);
        let sell_pool_exchange_rate_updated = sell_pool_update_exchange_rate_logic::verify<X, Y>(
            liquidity_token,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            sell_pool,
            ctx,
        );
        sell_pool_update_exchange_rate_logic::mutate<X, Y>(
            &sell_pool_exchange_rate_updated,
            sell_pool,
            ctx,
        );
        sell_pool::update_object_version(sell_pool);
        sell_pool::emit_sell_pool_exchange_rate_updated(sell_pool_exchange_rate_updated);
    }

    #[allow(unused_mut_parameter)]
    public(friend) fun add_x_token<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        x_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        sell_pool::assert_schema_version(sell_pool);
        let sell_pool_x_token_added = sell_pool_add_x_token_logic::verify<X, Y>(
            liquidity_token,
            &x,
            x_amount,
            sell_pool,
            ctx,
        );
        sell_pool_add_x_token_logic::mutate<X, Y>(
            &sell_pool_x_token_added,
            x,
            sell_pool,
            ctx,
        );
        sell_pool::update_object_version(sell_pool);
        sell_pool::emit_sell_pool_x_token_added(sell_pool_x_token_added);
    }

    #[allow(unused_mut_parameter)]
    public fun remove_x_token<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ): X {
        sell_pool::assert_schema_version(sell_pool);
        let sell_pool_x_token_removed = sell_pool_remove_x_token_logic::verify<X, Y>(
            liquidity_token,
            x_id,
            sell_pool,
            ctx,
        );
        let remove_x_token_return = sell_pool_remove_x_token_logic::mutate<X, Y>(
            &sell_pool_x_token_removed,
            sell_pool,
            ctx,
        );
        sell_pool::update_object_version(sell_pool);
        sell_pool::emit_sell_pool_x_token_removed(sell_pool_x_token_removed);
        remove_x_token_return
    }

    #[allow(unused_mut_parameter)]
    public fun withdraw_y_reserve<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ): Balance<Y> {
        sell_pool::assert_schema_version(sell_pool);
        let y_reserve_withdrawn = sell_pool_withdraw_y_reserve_logic::verify<X, Y>(
            liquidity_token,
            y_amount,
            sell_pool,
            ctx,
        );
        let withdraw_y_reserve_return = sell_pool_withdraw_y_reserve_logic::mutate<X, Y>(
            &y_reserve_withdrawn,
            sell_pool,
            ctx,
        );
        sell_pool::update_object_version(sell_pool);
        sell_pool::emit_y_reserve_withdrawn(y_reserve_withdrawn);
        withdraw_y_reserve_return
    }

    #[allow(unused_mut_parameter)]
    public entry fun destroy<X: key + store, Y>(
        sell_pool: sell_pool::SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        sell_pool::assert_schema_version(&sell_pool);
        let sell_pool_destroyed = sell_pool_destroy_logic::verify<X, Y>(
            liquidity_token,
            &sell_pool,
            ctx,
        );
        let updated_sell_pool = sell_pool_destroy_logic::mutate<X, Y>(
            &sell_pool_destroyed,
            sell_pool,
            ctx,
        );
        sell_pool::drop_sell_pool(updated_sell_pool);
        sell_pool::emit_sell_pool_destroyed(sell_pool_destroyed);
    }

    #[allow(unused_mut_parameter)]
    public fun buy_x<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        y_amount: Balance<Y>,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ): X {
        sell_pool::assert_schema_version(sell_pool);
        let sell_pool_y_swapped_for_x = sell_pool_buy_x_logic::verify<X, Y>(
            &y_amount,
            x_id,
            sell_pool,
            ctx,
        );
        let buy_x_return = sell_pool_buy_x_logic::mutate<X, Y>(
            &sell_pool_y_swapped_for_x,
            y_amount,
            sell_pool,
            ctx,
        );
        sell_pool::update_object_version(sell_pool);
        sell_pool::emit_sell_pool_y_swapped_for_x(sell_pool_y_swapped_for_x);
        buy_x_return
    }

}
