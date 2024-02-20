module sui_swap_utils::fixed_point32_util {
    use std::fixed_point32::{Self, FixedPoint32};

    const SCALING_FACTOR: u64 = 1 << 32;

    /// Return integer part and fractional of a fixed point number
    public fun integer_and_fractional(value: FixedPoint32): (u64, u64) {
        let raw_value = fixed_point32::get_raw_value(value);
        (raw_value / SCALING_FACTOR, raw_value % SCALING_FACTOR)
    }

    /// Return the value of a base raised to a power
    public fun pow(base: FixedPoint32, exponent: u64): FixedPoint32 {
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

    public fun divide(value: FixedPoint32, divisor: FixedPoint32): FixedPoint32 {
        let d = (fixed_point32::get_raw_value(value) as u128)
            * (SCALING_FACTOR as u128)
            / (fixed_point32::get_raw_value(divisor) as u128);
        fixed_point32::create_from_raw_value((d as u64))
    }

    public fun multiply(value: FixedPoint32, multiplier: FixedPoint32): FixedPoint32 {
        let m = (fixed_point32::get_raw_value(value) as u128)
            * (fixed_point32::get_raw_value(multiplier) as u128)
            / (SCALING_FACTOR as u128);
        fixed_point32::create_from_raw_value((m as u64))
    }

    /// multiplicative inverse
    public fun reciprocal(value: FixedPoint32): FixedPoint32 {
        fixed_point32::create_from_rational(
            SCALING_FACTOR, fixed_point32::get_raw_value(value)
        )
    }

    public fun plus_one(value: FixedPoint32): FixedPoint32 {
        fixed_point32::create_from_raw_value(
            fixed_point32::get_raw_value(value) + SCALING_FACTOR
        )
    }

    public fun minus_one(value: FixedPoint32): FixedPoint32 {
        fixed_point32::create_from_raw_value(
            fixed_point32::get_raw_value(value) - SCALING_FACTOR
        )
    }

    public fun one_minus(value: FixedPoint32): FixedPoint32 {
        fixed_point32::create_from_raw_value(
            SCALING_FACTOR - fixed_point32::get_raw_value(value)
        )
    }

    public fun greater_or_equal_than_one(value: FixedPoint32): bool {
        fixed_point32::get_raw_value(value) >= SCALING_FACTOR
    }

    public fun greater_than_one(value: FixedPoint32): bool {
        fixed_point32::get_raw_value(value) > SCALING_FACTOR
    }

    public fun less_than_one(value: FixedPoint32): bool {
        fixed_point32::get_raw_value(value) < SCALING_FACTOR
    }
}
