module sui_swap_example::fixed_point32_util {
    use std::fixed_point32::{Self, FixedPoint32};

    const SCALING_FACTOR: u64 = 1 << 32;

    /// Return the value of a base raised to a power
    public fun pow(base: FixedPoint32, exponent: u8): FixedPoint32 {
        let res = SCALING_FACTOR; // 1
        while (exponent >= 1) {
            if (exponent % 2 == 0) {
                //base = base * base;
                base = fixed_point32::create_from_rational(
                    fixed_point32::multiply_u64(fixed_point32::get_raw_value(base), base),
                    SCALING_FACTOR
                );
                exponent = exponent / 2;
            } else {
                //res = res * base;
                res = fixed_point32::multiply_u64(res, base);
                exponent = exponent - 1;
            }
        };
        fixed_point32::create_from_raw_value(res)
    }

    public fun plus_one(value: FixedPoint32): FixedPoint32 {
        fixed_point32::create_from_raw_value(
            fixed_point32::get_raw_value(value) + SCALING_FACTOR
        )
    }

    public fun greater_than_one(value: FixedPoint32): bool {
        fixed_point32::get_raw_value(value) > SCALING_FACTOR
    }
}
