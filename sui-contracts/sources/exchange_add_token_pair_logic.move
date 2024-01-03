#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::exchange_add_token_pair_logic {
    use std::string;
    use std::type_name;
    use std::vector;
    use sui::object::ID;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::exchange;
    use sui_swap_example::token_pair_added_to_exchange;

    friend sui_swap_example::exchange_aggregate;

    const ETokenPairExists: u64 = 100;

    public(friend) fun verify<X, Y>(
        token_pair_id: ID,
        exchange: &exchange::Exchange,
        ctx: &TxContext,
    ): exchange::TokenPairAddedToExchange {
        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        let exists: bool = false;
        let x_len = vector::length(&exchange::x_token_types(exchange));
        let i = 0;
        while (i < x_len) {
            let x = vector::borrow(&exchange::x_token_types(exchange), i);
            if (*x == x_token_type) {
                let y = vector::borrow(&exchange::y_token_types(exchange), i);
                if (*y == y_token_type) {
                   exists = true;
                    break
                };
            };
            i = i + 1;
        };
        assert!(!exists, ETokenPairExists);
        exchange::new_token_pair_added_to_exchange(
            exchange,
            token_pair_id,
            x_token_type,
            y_token_type,
        )
    }

    #[allow(unused_type_parameter)]
    public(friend) fun mutate<X, Y>(
        token_pair_added_to_exchange: &exchange::TokenPairAddedToExchange,
        exchange: &mut exchange::Exchange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let token_pair_id = token_pair_added_to_exchange::token_pair_id(token_pair_added_to_exchange);
        let x_token_type = token_pair_added_to_exchange::x_token_type(token_pair_added_to_exchange);
        let y_token_type = token_pair_added_to_exchange::y_token_type(token_pair_added_to_exchange);
        let ids = exchange::token_pairs(exchange);
        let x_token_types = exchange::x_token_types(exchange);
        let y_token_types = exchange::y_token_types(exchange);
        vector::push_back(&mut ids, token_pair_id);
        vector::push_back(&mut x_token_types, x_token_type);
        vector::push_back(&mut y_token_types, y_token_type);
    }

}
