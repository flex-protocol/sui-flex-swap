module sui_swap_example::liquidity_util {
    use sui::math;

    const MINIMUM_LIQUIDITY: u128 = 1000;

    public fun calculate_liquidity(total_liquidity: u64, x_reserve: u64, y_reserve: u64, x_amount: u64, y_amount: u64): u64 {
        let liquidity = if (total_liquidity == 0) {
            math::sqrt_u128((x_amount as u128) * (y_amount as u128)) - MINIMUM_LIQUIDITY
        } else {
            let x_liquidity = (x_amount as u128) * (total_liquidity as u128) / (x_reserve as u128);
            let y_liquidity = (y_amount as u128) * (total_liquidity as u128) / (y_reserve as u128);
            // use smaller one.
            if (x_liquidity < y_liquidity) {
                x_liquidity
            } else {
                y_liquidity
            }
        };
        (liquidity as u64)
    }
}
