#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::sell_pool_destroy_logic {
    use sui::balance;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::TxContext;

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::sell_pool;
    use sui_swap_example::sell_pool_destroyed;

    friend sui_swap_example::sell_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EObjectTableNotEmpty: u64 = 11;
    const ETableNotEmpty: u64 = 12;
    const EBalanceNotZero: u64 = 13;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        sell_pool: &sell_pool::SellPool<X, Y>,
        _ctx: &TxContext,
    ): sell_pool::SellPoolDestroyed {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(sell_pool::liquidity_token_id(sell_pool) == liquidity_token_id, EInvalidLiquidityToken);

        let x_reserve = sell_pool::borrow_x_reserve(sell_pool);
        assert!(object_table::is_empty(x_reserve), EObjectTableNotEmpty);
        let x_amounts = sell_pool::borrow_x_amounts(sell_pool);
        assert!(table::is_empty(x_amounts), ETableNotEmpty);
        let y_reserve = sell_pool::borrow_y_reserve(sell_pool);
        assert!(balance::value(y_reserve) == 0, EBalanceNotZero);

        sell_pool::new_sell_pool_destroyed(sell_pool, liquidity_token_id)
    }

    public(friend) fun mutate<X: key + store, Y>(
        sell_pool_destroyed: &sell_pool::SellPoolDestroyed,
        sell_pool: sell_pool::SellPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): sell_pool::SellPool<X, Y> {
        let _liquidity_token_id = sell_pool_destroyed::liquidity_token_id(sell_pool_destroyed);
        sell_pool
    }
}
