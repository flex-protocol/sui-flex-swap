#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::exchange_update_logic {
    use std::string::String;

    use sui::object::ID;
    use sui::tx_context::TxContext;

    use sui_swap_example::exchange;

    friend sui_swap_example::exchange_aggregate;

    public(friend) fun verify(
        name: String,
        update_token_pairs: bool,
        token_pairs: vector<ID>,
        token_pair_x_token_types: vector<String>,
        token_pair_y_token_types: vector<String>,
        update_trade_pools: bool,
        trade_pools: vector<ID>,
        trade_pool_x_token_types: vector<String>,
        trade_pool_y_token_types: vector<String>,
        update_sell_pools: bool,
        sell_pools: vector<ID>,
        sell_pool_x_token_types: vector<String>,
        sell_pool_y_token_types: vector<String>,
        update_buy_pools: bool,
        buy_pools: vector<ID>,
        buy_pool_x_token_types: vector<String>,
        buy_pool_y_token_types: vector<String>,
        exchange: &exchange::Exchange,
        ctx: &TxContext,
    ): exchange::ExchangeUpdated {
        exchange::new_exchange_updated(
            exchange,
            name,
            update_token_pairs,
            token_pairs,
            token_pair_x_token_types,
            token_pair_y_token_types,
            update_trade_pools,
            trade_pools,
            trade_pool_x_token_types,
            trade_pool_y_token_types,
            update_sell_pools,
            sell_pools,
            sell_pool_x_token_types,
            sell_pool_y_token_types,
            update_buy_pools,
            buy_pools,
            buy_pool_x_token_types,
            buy_pool_y_token_types,
        )
    }

    public(friend) fun mutate(
        exchange_updated: &exchange::ExchangeUpdated,
        exchange: &mut exchange::Exchange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let name = exchange::exchange_updated_name(exchange_updated);
        let update_token_pairs = exchange::exchange_updated_update_token_pairs(exchange_updated);
        let token_pairs = exchange::exchange_updated_token_pairs(exchange_updated);
        let token_pair_x_token_types = exchange::exchange_updated_token_pair_x_token_types(exchange_updated);
        let token_pair_y_token_types = exchange::exchange_updated_token_pair_y_token_types(exchange_updated);
        let update_trade_pools = exchange::exchange_updated_update_trade_pools(exchange_updated);
        let trade_pools = exchange::exchange_updated_trade_pools(exchange_updated);
        let trade_pool_x_token_types = exchange::exchange_updated_trade_pool_x_token_types(exchange_updated);
        let trade_pool_y_token_types = exchange::exchange_updated_trade_pool_y_token_types(exchange_updated);
        let update_sell_pools = exchange::exchange_updated_update_sell_pools(exchange_updated);
        let sell_pools = exchange::exchange_updated_sell_pools(exchange_updated);
        let sell_pool_x_token_types = exchange::exchange_updated_sell_pool_x_token_types(exchange_updated);
        let sell_pool_y_token_types = exchange::exchange_updated_sell_pool_y_token_types(exchange_updated);
        let update_buy_pools = exchange::exchange_updated_update_buy_pools(exchange_updated);
        let buy_pools = exchange::exchange_updated_buy_pools(exchange_updated);
        let buy_pool_x_token_types = exchange::exchange_updated_buy_pool_x_token_types(exchange_updated);
        let buy_pool_y_token_types = exchange::exchange_updated_buy_pool_y_token_types(exchange_updated);

        exchange::set_name(exchange, name);
        if (update_token_pairs) {
            update_token_pairs(exchange, token_pairs, token_pair_x_token_types, token_pair_y_token_types);
        };
        if (update_trade_pools) {
            update_trade_pools(exchange, trade_pools, trade_pool_x_token_types, trade_pool_y_token_types);
        };
        if (update_sell_pools) {
            update_sell_pools(exchange, sell_pools, sell_pool_x_token_types, sell_pool_y_token_types);
        };
        if (update_buy_pools) {
            udpate_buy_pools(exchange, buy_pools, buy_pool_x_token_types, buy_pool_y_token_types);
        };
    }

    fun update_token_pairs(
        exchange: &mut exchange::Exchange,
        ids: vector<ID>,
        x_token_types: vector<String>,
        y_token_types: vector<String>,
    ) {
        exchange::set_token_pairs(exchange, ids);
        exchange::set_token_pair_x_token_types(exchange, x_token_types);
        exchange::set_token_pair_y_token_types(exchange, y_token_types);
    }

    fun update_trade_pools(
        exchange: &mut exchange::Exchange,
        ids: vector<ID>,
        x_token_types: vector<String>,
        y_token_types: vector<String>,
    ) {
        exchange::set_trade_pools(exchange, ids);
        exchange::set_trade_pool_x_token_types(exchange, x_token_types);
        exchange::set_trade_pool_y_token_types(exchange, y_token_types);
    }

    fun update_sell_pools(
        exchange: &mut exchange::Exchange,
        ids: vector<ID>,
        x_token_types: vector<String>,
        y_token_types: vector<String>,
    ) {
        exchange::set_sell_pools(exchange, ids);
        exchange::set_sell_pool_x_token_types(exchange, x_token_types);
        exchange::set_sell_pool_y_token_types(exchange, y_token_types);
    }

    fun udpate_buy_pools(
        exchange: &mut exchange::Exchange,
        ids: vector<ID>,
        x_token_types: vector<String>,
        y_token_types: vector<String>,
    ) {
        exchange::set_buy_pools(exchange, ids);
        exchange::set_buy_pool_x_token_types(exchange, x_token_types);
        exchange::set_buy_pool_y_token_types(exchange, y_token_types);
    }
}
