#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::trade_pool_withdraw_y_reserve_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::tx_context::TxContext;

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::pool_y_reserve_withdrawn;
    use sui_swap_example::trade_pool;

    friend sui_swap_example::trade_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EInsufficientYReserve: u64 = 11;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        pool: &trade_pool::TradePool<X, Y>,
        _ctx: &TxContext,
    ): trade_pool::PoolYReserveWithdrawn {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(trade_pool::liquidity_token_id(pool) == liquidity_token_id, EInvalidLiquidityToken);

        let y_reserve_amount = balance::value(trade_pool::borrow_y_reserve(pool));
        assert!(y_reserve_amount >= y_amount, EInsufficientYReserve);

        trade_pool::new_pool_y_reserve_withdrawn(
            pool,
            liquidity_token_id,
            y_amount,
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        y_reserve_withdrawn: &trade_pool::PoolYReserveWithdrawn,
        pool: &mut trade_pool::TradePool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        let y_amount = pool_y_reserve_withdrawn::y_amount(y_reserve_withdrawn);

        let y_reserve = trade_pool::borrow_mut_y_reserve(pool);
        balance::split(y_reserve, y_amount)
    }
}
