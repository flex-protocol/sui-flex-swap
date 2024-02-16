module sui_swap_example::pool_type {
    const TRADE_POOL: u8 = 0;
    const SELL_POOL: u8 = 1;
    const BUY_POOL: u8 = 2;

    public fun trade_pool(): u8 {
        TRADE_POOL
    }

    public fun sell_pool(): u8 {
        SELL_POOL
    }

    public fun buy_pool(): u8 {
        BUY_POOL
    }

    public fun is_valid_pool_type(pool: u8): bool {
        pool == TRADE_POOL || pool == SELL_POOL || pool == BUY_POOL
    }

    public fun is_trade_pool_or_sell_pool(pool: u8): bool {
        pool == TRADE_POOL || pool == SELL_POOL
    }

    public fun is_trade_pool_or_buy_pool(pool: u8): bool {
        pool == TRADE_POOL || pool == BUY_POOL
    }
}
