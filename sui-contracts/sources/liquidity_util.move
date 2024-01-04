module sui_swap_example::liquidity_util {
    use sui::math;

    const MINIMUM_LIQUIDITY: u128 = 1000;

    public fun calculate_liquidity(
        total_supplied: u64,
        x_reserve: u64,
        y_reserve: u64,
        x_amount: u64,
        y_amount: u64
    ): u64//, u64, u64)
    {
        //let x_remaining = 0;
        //let y_remaining = 0;
        let liquidity = if (total_supplied == 0) {
            math::sqrt_u128((x_amount as u128) * (y_amount as u128)) - MINIMUM_LIQUIDITY
        } else {
            let x_liquidity = (x_amount as u128) * (total_supplied as u128) / (x_reserve as u128);
            let y_liquidity = (y_amount as u128) * (total_supplied as u128) / (y_reserve as u128);
            // use smaller one.
            if (x_liquidity < y_liquidity) {
                //y_remaining = y_amount - ((x_liquidity * (y_reserve as u128) / (total_supplied as u128)) as u64);
                x_liquidity
            } else {
                //x_remaining = x_amount - ((y_liquidity * (x_reserve as u128) / (total_supplied as u128)) as u64);
                y_liquidity
            }
        };
        (liquidity as u64)//, x_remaining, y_remaining
    }
}
