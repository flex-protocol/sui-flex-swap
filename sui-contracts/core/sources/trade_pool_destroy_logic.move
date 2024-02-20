#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::trade_pool_destroy_logic {
    use sui::balance;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::TxContext;

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::trade_pool;

    friend sui_swap_example::trade_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EObjectTableNotEmpty: u64 = 11;
    const ETableNotEmpty: u64 = 12;
    const EBalanceNotZero: u64 = 13;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        trade_pool: &trade_pool::TradePool<X, Y>,
        _ctx: &TxContext,
    ): trade_pool::PoolDestroyed {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(trade_pool::liquidity_token_id(trade_pool) == liquidity_token_id, EInvalidLiquidityToken);

        let x_reserve = trade_pool::borrow_x_reserve(trade_pool);
        assert!(object_table::is_empty(x_reserve), EObjectTableNotEmpty);
        let x_amounts = trade_pool::borrow_x_amounts(trade_pool);
        assert!(table::is_empty(x_amounts), ETableNotEmpty);
        let y_reserve = trade_pool::borrow_y_reserve(trade_pool);
        assert!(balance::value(y_reserve) == 0, EBalanceNotZero);

        trade_pool::new_pool_destroyed(trade_pool, liquidity_token_id)
    }

    public(friend) fun mutate<X: key + store, Y>(
        _pool_destroyed: &trade_pool::PoolDestroyed,
        trade_pool: trade_pool::TradePool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): trade_pool::TradePool<X, Y> {
        //let _liquidity_token_id = trade_pool::pool_destroyed_liquidity_token_id(pool_destroyed);
        trade_pool
    }
}
