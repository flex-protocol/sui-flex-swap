#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::buy_pool_deposit_y_reserve_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::tx_context::TxContext;

    use sui_swap_example::buy_pool;
    use sui_swap_example::buy_pool_y_reserve_deposited;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;

    friend sui_swap_example::buy_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: &Balance<Y>,
        buy_pool: &buy_pool::BuyPool<X, Y>,
        ctx: &TxContext,
    ): buy_pool::BuyPoolYReserveDeposited {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(buy_pool::liquidity_token_id(buy_pool) == liquidity_token_id, EInvalidLiquidityToken);

        buy_pool::new_buy_pool_y_reserve_deposited(
            buy_pool,
            liquidity_token_id,
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            balance::value(y_amount),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        buy_pool_y_reserve_deposited: &buy_pool::BuyPoolYReserveDeposited,
        y_amount: Balance<Y>,
        buy_pool: &mut buy_pool::BuyPool<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let liquidity_token_id = buy_pool_y_reserve_deposited::liquidity_token_id(buy_pool_y_reserve_deposited);
        //let x_token_type = buy_pool_y_reserve_deposited::x_token_type(buy_pool_y_reserve_deposited);
        //let y_token_type = buy_pool_y_reserve_deposited::y_token_type(buy_pool_y_reserve_deposited);
        let _y_amount_i = buy_pool_y_reserve_deposited::y_amount(buy_pool_y_reserve_deposited);
        //let id = buy_pool::id(buy_pool);
        let y_reserve = buy_pool::borrow_mut_y_reserve(buy_pool);
        sui::balance::join(y_reserve, y_amount);
    }
}
