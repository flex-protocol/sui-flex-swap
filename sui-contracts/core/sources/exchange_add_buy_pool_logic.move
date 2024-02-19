#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::exchange_add_buy_pool_logic {
    use std::string;
    use std::type_name;
    use std::vector;

    use sui::object::ID;
    use sui::tx_context::TxContext;

    use sui_swap_example::exchange;

    friend sui_swap_example::exchange_aggregate;

    public(friend) fun verify<X: key + store, Y>(
        buy_pool_id: ID,
        exchange: &exchange::Exchange,
        _ctx: &TxContext,
    ): exchange::BuyPoolAddedToExchange {
        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        //assert_token_pair_not_exists(exchange, x_token_type, y_token_type);
        exchange::new_buy_pool_added_to_exchange(
            exchange,
            buy_pool_id,
            x_token_type,
            y_token_type,
        )
    }

    #[allow(unused_type_parameter)]
    public(friend) fun mutate<X: key + store, Y>(
        buy_pool_added_to_exchange: &exchange::BuyPoolAddedToExchange,
        exchange: &mut exchange::Exchange,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let buy_pool_id = exchange::buy_pool_added_to_exchange_buy_pool_id(buy_pool_added_to_exchange);
        let x_token_type = exchange::buy_pool_added_to_exchange_x_token_type(buy_pool_added_to_exchange);
        let y_token_type = exchange::buy_pool_added_to_exchange_y_token_type(buy_pool_added_to_exchange);
        let ids = exchange::buy_pools(exchange);
        let x_token_types = exchange::buy_pool_x_token_types(exchange);
        let y_token_types = exchange::buy_pool_y_token_types(exchange);
        vector::push_back(&mut ids, buy_pool_id);
        vector::push_back(&mut x_token_types, x_token_type);
        vector::push_back(&mut y_token_types, y_token_type);
        exchange::set_buy_pools(exchange, ids);
        exchange::set_buy_pool_x_token_types(exchange, x_token_types);
        exchange::set_buy_pool_y_token_types(exchange, y_token_types);
    }
}
