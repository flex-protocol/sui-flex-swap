#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_swap_x_logic {
    use std::type_name;
    use std::string;
    use sui::balance::{Self, Balance};
    use sui::object;
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::swap_util;
    use sui_swap_example::token_pair;
    use sui_swap_example::x_swapped_for_y;

    friend sui_swap_example::token_pair_aggregate;

    const ENotSameTick: u64 = 10;

    public(friend) fun verify<X: key + store, Y>(
        x: &X,
        x_amount: u64,
        expected_y_amount_out: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::XSwappedForY {
        // assert!(
        //     movescription::tick(x_movescription) == movescription::tick(token_pair::borrow_x_reserve(token_pair)),
        //     ENotSameTick
        // );
        //let x_reserve = movescription::amount(token_pair::borrow_x_reserve(token_pair));
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        //let x_amount_in = movescription::amount(x_movescription);
        //let y_amount_out = swap_util::swap(x_reserve, y_reserve, x_amount_in, expected_y_amount_out);
        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        token_pair::new_x_swapped_for_y(
            token_pair,
            x_amount,
            expected_y_amount_out,
            tx_context::sender(ctx),
            x_token_type,
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            0, //todo //y_amount_out,
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
        // let x_amount_i = x_swapped_for_y::x_amount(x_swapped_for_y);
        let y_amount = x_swapped_for_y::y_amount(x_swapped_for_y);
        //let id = token_pair::id(token_pair);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        let x_id = object::id(&x);
        object_table::add(x_reserve, x_id, x);
        //todo movescription::merge(x_reserve, x_movescription);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::split(y_reserve, y_amount)
    }

}
