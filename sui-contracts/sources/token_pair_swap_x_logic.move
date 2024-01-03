#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_swap_x_logic {
    use std::type_name;
    use std::string;
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::liquidity::{Self, Liquidity};
    use sui_swap_example::token_pair;
    use sui_swap_example::x_swapped_for_y;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        x_amount: &Balance<X>,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::XSwappedForY {
        token_pair::new_x_swapped_for_y(
            token_pair,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            balance::value(x_amount),
            0,//todo calculate y_amount
        )
    }

    public(friend) fun mutate<X, Y>(
        x_swapped_for_y: &token_pair::XSwappedForY,
        x_amount: Balance<X>,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        let sender = x_swapped_for_y::sender(x_swapped_for_y);
        let x_token_type = x_swapped_for_y::x_token_type(x_swapped_for_y);
        let y_token_type = x_swapped_for_y::y_token_type(x_swapped_for_y);
        // let x_amount = x_swapped_for_y::x_amount(x_swapped_for_y);
        let y_amount = x_swapped_for_y::y_amount(x_swapped_for_y);
        let id = token_pair::id(token_pair);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        sui::balance::join(x_reserve, x_amount);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::split(y_reserve, y_amount)
    }

}
