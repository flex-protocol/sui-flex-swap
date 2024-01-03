#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_initialize_liquidity_logic {
    use std::string;
    use std::type_name;
    use sui::balance;
    use sui::balance::Balance;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::exchange_aggregate;
    use sui_swap_example::token_util;
    use sui_swap_example::exchange::{Self, Exchange};
    use sui_swap_example::liquidity::{Self, Liquidity};
    use sui_swap_example::liquidity_initialized;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        exchange: &mut Exchange,
        x_amount: &Balance<X>,
        y_amount: &Balance<Y>,
        ctx: &mut TxContext,
    ): token_pair::LiquidityInitialized {
        token_util::assert_type_less_than<X, Y>();
        token_pair::new_liquidity_initialized<X, Y>(
            object::id(exchange),
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            balance::value(x_amount),
            balance::value(y_amount),
            0,//todo liquidity_amount
        )
    }

    public(friend) fun mutate<X, Y>(
        liquidity_initialized: &token_pair::LiquidityInitialized,
        x_amount: Balance<X>,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): token_pair::TokenPair<X, Y> {
        let exchange_id = liquidity_initialized::exchange_id(liquidity_initialized);
        let provider = liquidity_initialized::provider(liquidity_initialized);
        let x_token_type = liquidity_initialized::x_token_type(liquidity_initialized);
        let y_token_type = liquidity_initialized::y_token_type(liquidity_initialized);
        // let x_amount = liquidity_initialized::x_amount(liquidity_initialized);
        // let y_amount = liquidity_initialized::y_amount(liquidity_initialized);
        let liquidity_amount = liquidity_initialized::liquidity_amount(liquidity_initialized);
        let token_pair = token_pair::new_token_pair(
            liquidity_amount,
            ctx,
        );
        //
        exchange_aggregate::add_token_pair<X, Y>(exchange, token_pair::id(&token_pair), ctx);
        //
        let x_reserve = token_pair::borrow_mut_x_reserve(&mut token_pair);
        sui::balance::join(x_reserve, x_amount);
        let y_reserve = token_pair::borrow_mut_y_reserve(&mut token_pair);
        sui::balance::join(y_reserve, y_amount);
        token_pair
    }

}
