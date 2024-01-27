#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_swap_y_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::swap_util;
    use sui_swap_example::token_pair;
    use sui_swap_example::y_swapped_for_x;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidXTokenId: u64 = 11;
    const ESwapLastXToken: u64 = 12;
    const EInconsistentXAmount: u64 = 101;

    public(friend) fun verify<X: key + store, Y>(
        y_amount: &Balance<Y>,
        x_id: ID,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::YSwappedForX {
        let x_amounts = token_pair::borrow_x_amounts(token_pair);
        assert!(table::contains(x_amounts, x_id), EInvalidXTokenId);
        assert!(table::length(x_amounts) > 1, ESwapLastXToken); // Cannot Swap the last token.
        let x_amount = *table::borrow(x_amounts, x_id);

        let x_reserve_amount = token_pair::x_total_amount(token_pair);
        let y_reserve_amount = balance::value(token_pair::borrow_y_reserve(token_pair));
        let y_amount_in = balance::value(y_amount);
        //let expected_x_amount_out = x_amount;
        let _max_x_amount_out = swap_util::swap(y_reserve_amount, x_reserve_amount, y_amount_in, x_amount);

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        token_pair::new_y_swapped_for_x(
            token_pair,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
            balance::value(y_amount),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        y_swapped_for_x: &token_pair::YSwappedForX,
        y_amount: Balance<Y>,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): X {
        //let sender = y_swapped_for_x::sender(y_swapped_for_x);
        //let x_token_type = y_swapped_for_x::x_token_type(y_swapped_for_x);
        //let y_token_type = y_swapped_for_x::y_token_type(y_swapped_for_x);
        let x_amount = y_swapped_for_x::x_amount(y_swapped_for_x);
        //let y_amount = y_swapped_for_x::y_amount(y_swapped_for_x);

        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::join(y_reserve, y_amount);

        let x_id = y_swapped_for_x::x_id(y_swapped_for_x);
        let (x, _x_total_amount) = remove_x_token<X, Y>(
            token_pair,
            x_id,
            x_amount
        );
        x
    }

    fun remove_x_token<X: key + store, Y>(
        token_pair: &mut token_pair::TokenPair<X, Y>,
        x_id: ID,
        x_amount: u64
    ): (X, u64) {
        let x_amounts = token_pair::borrow_mut_x_amounts(token_pair);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        let x = object_table::remove(x_reserve, x_id);
        let x_total_amount = token_pair::x_total_amount(token_pair);
        x_total_amount = x_total_amount - x_amount;
        token_pair::set_x_total_amount(token_pair, x_total_amount);
        (x, x_total_amount)
    }
}
