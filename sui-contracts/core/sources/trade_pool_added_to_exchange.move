// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::trade_pool_added_to_exchange {

    use std::string::String;
    use sui::object::{Self, ID};
    use sui_swap_example::exchange::{Self, TradePoolAddedToExchange};

    public fun id(trade_pool_added_to_exchange: &TradePoolAddedToExchange): object::ID {
        exchange::trade_pool_added_to_exchange_id(trade_pool_added_to_exchange)
    }

    public fun trade_pool_id(trade_pool_added_to_exchange: &TradePoolAddedToExchange): ID {
        exchange::trade_pool_added_to_exchange_trade_pool_id(trade_pool_added_to_exchange)
    }

    public fun x_token_type(trade_pool_added_to_exchange: &TradePoolAddedToExchange): String {
        exchange::trade_pool_added_to_exchange_x_token_type(trade_pool_added_to_exchange)
    }

    public fun y_token_type(trade_pool_added_to_exchange: &TradePoolAddedToExchange): String {
        exchange::trade_pool_added_to_exchange_y_token_type(trade_pool_added_to_exchange)
    }

}
