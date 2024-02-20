#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_destroy_logic {
    use sui::balance;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::TxContext;

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EObjectTableNotEmpty: u64 = 11;
    const ETableNotEmpty: u64 = 12;
    const EBalanceNotZero: u64 = 13;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        token_pair: &token_pair::TokenPair<X, Y>,
        _ctx: &TxContext,
    ): token_pair::TokenPairDestroyed {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(token_pair::liquidity_token_id(token_pair) == liquidity_token_id, EInvalidLiquidityToken);

        let x_reserve = token_pair::borrow_x_reserve(token_pair);
        assert!(object_table::is_empty(x_reserve), EObjectTableNotEmpty);
        let x_amounts = token_pair::borrow_x_amounts(token_pair);
        assert!(table::is_empty(x_amounts), ETableNotEmpty);
        let y_reserve = token_pair::borrow_y_reserve(token_pair);
        assert!(balance::value(y_reserve) == 0, EBalanceNotZero);

        token_pair::new_token_pair_destroyed(token_pair, liquidity_token_id)
    }

    public(friend) fun mutate<X: key + store, Y>(
        _token_pair_destroyed: &token_pair::TokenPairDestroyed,
        token_pair: token_pair::TokenPair<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): token_pair::TokenPair<X, Y> {
        //let _liquidity_token_id = token_pair::token_pair_destroyed_liquidity_token_id(token_pair_destroyed);
        token_pair
    }
}
