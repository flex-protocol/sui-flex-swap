#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::exchange_update_buy_pools_logic {
    use std::string::String;

    use sui::object::ID;
    use sui::tx_context::TxContext;

    use sui_swap_example::exchange;
    use sui_swap_example::exchange_buy_pools_updated;

    friend sui_swap_example::exchange_aggregate;

    public(friend) fun verify(
        ids: vector<ID>,
        x_token_types: vector<String>,
        y_token_types: vector<String>,
        exchange: &exchange::Exchange,
        ctx: &TxContext,
    ): exchange::ExchangeBuyPoolsUpdated {
        exchange::new_exchange_buy_pools_updated(exchange, ids, x_token_types, y_token_types)
    }

    public(friend) fun mutate(
        exchange_buy_pools_updated: &exchange::ExchangeBuyPoolsUpdated,
        exchange: &mut exchange::Exchange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ids = exchange_buy_pools_updated::ids(exchange_buy_pools_updated);
        let x_token_types = exchange_buy_pools_updated::x_token_types(exchange_buy_pools_updated);
        let y_token_types = exchange_buy_pools_updated::y_token_types(exchange_buy_pools_updated);

        // replace all pools' info with the new ones
        exchange::set_buy_pools(exchange, ids);
        exchange::set_buy_pool_x_token_types(exchange, x_token_types);
        exchange::set_buy_pool_y_token_types(exchange, y_token_types);
    }
}
