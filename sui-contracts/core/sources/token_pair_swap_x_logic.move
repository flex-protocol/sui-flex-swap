#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_swap_x_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::object;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::swap_util;
    use sui_swap_example::token_pair;
    use sui_swap_example::x_swapped_for_y;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X: key + store, Y>(
        x: &X,
        x_amount: u64,
        expected_y_amount_out: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::XSwappedForY {
        let _ = x;
        let x_reserve_amount = token_pair::x_total_amount(token_pair);
        let y_reserve_amount = balance::value(token_pair::borrow_y_reserve(token_pair));
        let fee_numerator = token_pair::fee_numerator(token_pair);
        let fee_denominator = token_pair::fee_denominator(token_pair);
        let y_amount_out = swap_util::swap(
            x_reserve_amount,
            y_reserve_amount,
            x_amount,
            expected_y_amount_out,
            fee_numerator,
            fee_denominator
        );
        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        token_pair::new_x_swapped_for_y(
            token_pair,
            x_amount,
            expected_y_amount_out,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            y_amount_out,
            object::id(x),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        x_swapped_for_y: &token_pair::XSwappedForY,
        x: X,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        //let sender = x_swapped_for_y::sender(x_swapped_for_y);
        //let x_token_type = x_swapped_for_y::x_token_type(x_swapped_for_y);
        //let y_token_type = x_swapped_for_y::y_token_type(x_swapped_for_y);
        let x_amount = x_swapped_for_y::x_amount(x_swapped_for_y);
        let y_amount = x_swapped_for_y::y_amount(x_swapped_for_y);

        let x_id = object::id(&x);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        object_table::add(x_reserve, x_id, x);
        let x_amounts = token_pair::borrow_mut_x_amounts(token_pair);
        table::add(x_amounts, x_id, x_amount);
        let x_total_amount = token_pair::x_total_amount(token_pair);
        token_pair::set_x_total_amount(token_pair, x_total_amount + x_amount);

        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::split(y_reserve, y_amount)
    }
}
