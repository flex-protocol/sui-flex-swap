module sui_swap_example::exchange_update_logic {
    use std::string::String;
    use sui::object::ID;
    use sui::tx_context::TxContext;
    use sui_swap_example::exchange;
    use sui_swap_example::exchange_updated;

    friend sui_swap_example::exchange_aggregate;

    public(friend) fun verify(
        name: String,
        exchange: &exchange::Exchange,
        ctx: &TxContext,
    ): exchange::ExchangeUpdated {
        let _ = ctx;
        exchange::new_exchange_updated(
            exchange,
            name,
            // token_pairs,
            // x_token_types,
            // y_token_types,
        )
    }

    public(friend) fun mutate(
        exchange_updated: &exchange::ExchangeUpdated,
        exchange: &mut exchange::Exchange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let name = exchange_updated::name(exchange_updated);
        // let token_pairs = exchange_updated::token_pairs(exchange_updated);
        // let x_token_types = exchange_updated::x_token_types(exchange_updated);
        // let y_token_types = exchange_updated::y_token_types(exchange_updated);
        let _ = ctx;
        exchange::set_name(exchange, name);
        // exchange::set_token_pairs(exchange, token_pairs);
        // exchange::set_x_token_types(exchange, x_token_types);
        // exchange::set_y_token_types(exchange, y_token_types);
    }

}
