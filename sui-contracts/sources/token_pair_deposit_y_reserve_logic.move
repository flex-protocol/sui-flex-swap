#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_deposit_y_reserve_logic {
    use std::string;
    use std::type_name;

    use sui::balance::Balance;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        y_amount: &Balance<Y>,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::YReserveDeposited {
        token_pair::new_y_reserve_deposited(
            token_pair,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            sui::balance::value(y_amount),
        )
    }

    public(friend) fun mutate<X, Y>(
        y_reserve_deposited: &token_pair::YReserveDeposited,
        y_amount: Balance<Y>,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let provider = y_reserve_deposited::provider(y_reserve_deposited);
        //let x_token_type = y_reserve_deposited::x_token_type(y_reserve_deposited);
        //let y_token_type = y_reserve_deposited::y_token_type(y_reserve_deposited);
        //let y_amount_i = y_reserve_deposited::y_amount(y_reserve_deposited);
        //let id = token_pair::id(token_pair);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::join(y_reserve, y_amount);
    }
}
