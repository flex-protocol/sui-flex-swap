// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_core::pool_x_token_removed {

    use std::string::String;
    use sui::object::{Self, ID};
    use sui_swap_core::trade_pool::{Self, PoolXTokenRemoved};

    public fun id(pool_x_token_removed: &PoolXTokenRemoved): object::ID {
        trade_pool::pool_x_token_removed_id(pool_x_token_removed)
    }

    public fun liquidity_token_id(pool_x_token_removed: &PoolXTokenRemoved): ID {
        trade_pool::pool_x_token_removed_liquidity_token_id(pool_x_token_removed)
    }

    public fun x_id(pool_x_token_removed: &PoolXTokenRemoved): ID {
        trade_pool::pool_x_token_removed_x_id(pool_x_token_removed)
    }

    public fun provider(pool_x_token_removed: &PoolXTokenRemoved): address {
        trade_pool::pool_x_token_removed_provider(pool_x_token_removed)
    }

    public fun x_token_type(pool_x_token_removed: &PoolXTokenRemoved): String {
        trade_pool::pool_x_token_removed_x_token_type(pool_x_token_removed)
    }

    public fun y_token_type(pool_x_token_removed: &PoolXTokenRemoved): String {
        trade_pool::pool_x_token_removed_y_token_type(pool_x_token_removed)
    }

    public fun x_amount(pool_x_token_removed: &PoolXTokenRemoved): u64 {
        trade_pool::pool_x_token_removed_x_amount(pool_x_token_removed)
    }

}
