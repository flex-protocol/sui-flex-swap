#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_remove_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::liquidity_removed;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        liquidity_amount: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::LiquidityRemoved {
        let total_liquidity = token_pair::total_liquidity(token_pair);
        let x_reserve = balance::value(token_pair::borrow_x_reserve(token_pair));
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        let (x_amount, y_amount) = liquidity_util::get_pair_amounts(
            total_liquidity,
            x_reserve,
            y_reserve,
            liquidity_amount
        );
        token_pair::new_liquidity_removed(
            token_pair,
            liquidity_amount,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount,
            y_amount,
        )
    }

    public(friend) fun mutate<X, Y>(
        liquidity_removed: &token_pair::LiquidityRemoved,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): (Balance<X>, Balance<Y>) {
        let liquidity_amount_removed = liquidity_removed::liquidity_amount(liquidity_removed);
        let provider = liquidity_removed::provider(liquidity_removed);
        let x_token_type = liquidity_removed::x_token_type(liquidity_removed);
        let y_token_type = liquidity_removed::y_token_type(liquidity_removed);
        let x_amount = liquidity_removed::x_amount(liquidity_removed);
        let y_amount = liquidity_removed::y_amount(liquidity_removed);
        let id = token_pair::id(token_pair);
        token_pair::set_total_liquidity(
            token_pair,
            token_pair::total_liquidity(token_pair) - liquidity_amount_removed,
        );
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        let x_out = balance::split(x_reserve, x_amount);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        let y_out = balance::split(y_reserve, y_amount);
        (x_out, y_out)
    }
}
