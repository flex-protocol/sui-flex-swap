// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::exchange_buy_pools_updated {

    use std::string::String;
    use sui::object::{Self, ID};
    use sui_swap_example::exchange::{Self, ExchangeBuyPoolsUpdated};

    public fun id(exchange_buy_pools_updated: &ExchangeBuyPoolsUpdated): object::ID {
        exchange::exchange_buy_pools_updated_id(exchange_buy_pools_updated)
    }

    public fun ids(exchange_buy_pools_updated: &ExchangeBuyPoolsUpdated): vector<ID> {
        exchange::exchange_buy_pools_updated_ids(exchange_buy_pools_updated)
    }

    public fun x_token_types(exchange_buy_pools_updated: &ExchangeBuyPoolsUpdated): vector<String> {
        exchange::exchange_buy_pools_updated_x_token_types(exchange_buy_pools_updated)
    }

    public fun y_token_types(exchange_buy_pools_updated: &ExchangeBuyPoolsUpdated): vector<String> {
        exchange::exchange_buy_pools_updated_y_token_types(exchange_buy_pools_updated)
    }

}
