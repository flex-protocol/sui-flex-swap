#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::buy_pool_destroy_logic {
    use sui::balance;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::TxContext;

    use sui_swap_example::buy_pool;
    use sui_swap_example::buy_pool_destroyed;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;

    friend sui_swap_example::buy_pool_aggregate;


    const EInvalidLiquidityToken: u64 = 10;
    const EObjectTableNotEmpty: u64 = 11;
    const ETableNotEmpty: u64 = 12;
    const EBalanceNotZero: u64 = 13;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        buy_pool: &buy_pool::BuyPool<X, Y>,
        ctx: &TxContext,
    ): buy_pool::BuyPoolDestroyed {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(buy_pool::liquidity_token_id(buy_pool) == liquidity_token_id, EInvalidLiquidityToken);

        let x_reserve = buy_pool::borrow_x_reserve(buy_pool);
        assert!(object_table::is_empty(x_reserve), EObjectTableNotEmpty);
        let x_amounts = buy_pool::borrow_x_amounts(buy_pool);
        assert!(table::is_empty(x_amounts), ETableNotEmpty);
        let y_reserve = buy_pool::borrow_y_reserve(buy_pool);
        assert!(balance::value(y_reserve) == 0, EBalanceNotZero);

        buy_pool::new_buy_pool_destroyed(buy_pool, liquidity_token_id)
    }

    public(friend) fun mutate<X: key + store, Y>(
        buy_pool_destroyed: &buy_pool::BuyPoolDestroyed,
        buy_pool: buy_pool::BuyPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): buy_pool::BuyPool<X, Y> {
        let _liquidity_token_id = buy_pool_destroyed::liquidity_token_id(buy_pool_destroyed);
        buy_pool
    }
}
