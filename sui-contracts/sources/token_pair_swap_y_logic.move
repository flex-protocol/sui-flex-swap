#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_swap_y_logic {
    use std::string;
    use std::type_name;
    use sui::balance;
    use sui::balance::Balance;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::swap_util;
    use sui_swap_example::liquidity::{Self, Liquidity};
    use sui_swap_example::token_pair;
    use sui_swap_example::y_swapped_for_x;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        y_amount: &Balance<Y>,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::YSwappedForX {
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        let x_reserve = balance::value(token_pair::borrow_x_reserve(token_pair));
        let y_amount_in = balance::value(y_amount);
        let expected_x_amount_out: u64 = 0;//todo?
        let x_amount_out = swap_util::swap(y_reserve, x_reserve, y_amount_in, expected_x_amount_out);
        token_pair::new_y_swapped_for_x(
            token_pair,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount_out,
            balance::value(y_amount),
        )
    }

    public(friend) fun mutate<X, Y>(
        y_swapped_for_x: &token_pair::YSwappedForX,
        y_amount: Balance<Y>,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<X> {
        let sender = y_swapped_for_x::sender(y_swapped_for_x);
        let x_token_type = y_swapped_for_x::x_token_type(y_swapped_for_x);
        let y_token_type = y_swapped_for_x::y_token_type(y_swapped_for_x);
        let x_amount = y_swapped_for_x::x_amount(y_swapped_for_x);
        //let y_amount = y_swapped_for_x::y_amount(y_swapped_for_x);
        let id = token_pair::id(token_pair);

        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::join(y_reserve, y_amount);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        sui::balance::split(x_reserve, x_amount)
    }

}
