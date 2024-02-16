// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::pool_exchange_rate_updated {

    use std::string::String;
    use sui::object::{Self, ID};
    use sui_swap_example::trade_pool::{Self, PoolExchangeRateUpdated};

    public fun id(pool_exchange_rate_updated: &PoolExchangeRateUpdated): object::ID {
        trade_pool::pool_exchange_rate_updated_id(pool_exchange_rate_updated)
    }

    public fun liquidity_token_id(pool_exchange_rate_updated: &PoolExchangeRateUpdated): ID {
        trade_pool::pool_exchange_rate_updated_liquidity_token_id(pool_exchange_rate_updated)
    }

    public fun start_exchange_rate_numerator(pool_exchange_rate_updated: &PoolExchangeRateUpdated): u64 {
        trade_pool::pool_exchange_rate_updated_start_exchange_rate_numerator(pool_exchange_rate_updated)
    }

    public fun exchange_rate_numerator(pool_exchange_rate_updated: &PoolExchangeRateUpdated): u64 {
        trade_pool::pool_exchange_rate_updated_exchange_rate_numerator(pool_exchange_rate_updated)
    }

    public fun exchange_rate_denominator(pool_exchange_rate_updated: &PoolExchangeRateUpdated): u64 {
        trade_pool::pool_exchange_rate_updated_exchange_rate_denominator(pool_exchange_rate_updated)
    }

    public fun price_delta_x_amount(pool_exchange_rate_updated: &PoolExchangeRateUpdated): u64 {
        trade_pool::pool_exchange_rate_updated_price_delta_x_amount(pool_exchange_rate_updated)
    }

    public fun price_delta_numerator(pool_exchange_rate_updated: &PoolExchangeRateUpdated): u64 {
        trade_pool::pool_exchange_rate_updated_price_delta_numerator(pool_exchange_rate_updated)
    }

    public fun price_delta_denominator(pool_exchange_rate_updated: &PoolExchangeRateUpdated): u64 {
        trade_pool::pool_exchange_rate_updated_price_delta_denominator(pool_exchange_rate_updated)
    }

    public fun provider(pool_exchange_rate_updated: &PoolExchangeRateUpdated): address {
        trade_pool::pool_exchange_rate_updated_provider(pool_exchange_rate_updated)
    }

    public fun x_token_type(pool_exchange_rate_updated: &PoolExchangeRateUpdated): String {
        trade_pool::pool_exchange_rate_updated_x_token_type(pool_exchange_rate_updated)
    }

    public fun y_token_type(pool_exchange_rate_updated: &PoolExchangeRateUpdated): String {
        trade_pool::pool_exchange_rate_updated_y_token_type(pool_exchange_rate_updated)
    }

}
