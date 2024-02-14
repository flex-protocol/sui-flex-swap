#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::buy_pool_withdraw_y_reserve_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::tx_context::TxContext;

    use sui_swap_example::buy_pool;
    use sui_swap_example::buy_pool_y_reserve_withdrawn;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;

    friend sui_swap_example::buy_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EInsufficientYReserve: u64 = 11;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        buy_pool: &buy_pool::BuyPool<X, Y>,
        _ctx: &TxContext,
    ): buy_pool::BuyPoolYReserveWithdrawn {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(buy_pool::liquidity_token_id(buy_pool) == liquidity_token_id, EInvalidLiquidityToken);

        let y_reserve_amount = balance::value(buy_pool::borrow_y_reserve(buy_pool));
        assert!(y_reserve_amount >= y_amount, EInsufficientYReserve);

        buy_pool::new_buy_pool_y_reserve_withdrawn(
            buy_pool,
            liquidity_token_id,
            y_amount,
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        y_reserve_withdrawn: &buy_pool::BuyPoolYReserveWithdrawn,
        buy_pool: &mut buy_pool::BuyPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        let y_amount = buy_pool_y_reserve_withdrawn::y_amount(y_reserve_withdrawn);

        let y_reserve = buy_pool::borrow_mut_y_reserve(buy_pool);
        balance::split(y_reserve, y_amount)
    }
}
