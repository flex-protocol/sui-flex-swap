package org.test.suiswapexample.sui.contract.utils;

import java.math.BigInteger;

public class PriceCurve {

    /*
    const LINEAR_CURVE: u8 = 0;
    const EXPONENTIAL_CURVE: u8 = 1;
    const MINIMUM_SPOT_PRICE: u64 = 1;
     */
    public static final byte LINEAR_CURVE = 0;
    public static final byte EXPONENTIAL_CURVE = 1;
    public static final BigInteger MINIMUM_SPOT_PRICE = BigInteger.ONE;

    /*
    public fun is_valid_curve_type(curve_type: u8): bool {
        curve_type == LINEAR_CURVE || curve_type == EXPONENTIAL_CURVE
    }
     */
    public static boolean isValidCurveType(byte curve_type) {
        return curve_type == LINEAR_CURVE || curve_type == EXPONENTIAL_CURVE;
    }

    /*
    /// This module accepts price type of u64,
    /// so if it is necessary to handle prices with decimals,
    /// the client code that calls it needs to pass in a "scaled price"
    /// and then perform decimal processing on the return value itself.
    public fun get_buy_info(
        curve_type: u8,
        amount: u64,
        item_amount: u64,
        spot_price: u64,
        start_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): (u64, u64) {
        assert!(is_valid_curve_type(curve_type), EInvalidCurveType);
        let (number_of_items, _remainder) = get_number_of_items_and_remainder(
            amount,
            item_amount
        );
        if (curve_type == LINEAR_CURVE) {
            let delta = get_linear_curve_price_delta(start_price, price_delta_numerator, price_delta_denominator);
            get_linear_curve_buy_info(
                number_of_items,
                item_amount,
                spot_price,
                delta,
                _remainder,
            )
        } else {
            //start_price is not used, all based on the current spot_price?
            let multiplier = get_exponential_curve_price_multiplier(price_delta_numerator, price_delta_denominator);
            get_exponential_curve_buy_info(
                number_of_items,
                item_amount,
                spot_price,
                multiplier,
                price_delta_numerator,
                price_delta_denominator,
                _remainder,
            )
        }
    }
     */
    public static Pair<BigInteger, BigInteger> getBuyInfo(
            byte curve_type,
            BigInteger amount,
            BigInteger item_amount,
            BigInteger spot_price,
            BigInteger start_price,
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator
    ) {
        if (!isValidCurveType(curve_type)) {
            throw new IllegalArgumentException("Invalid curve type");
        }
        Pair<FixedPoint32, BigInteger> number_of_items_remainder = get_number_of_items_and_remainder(amount, item_amount);
        FixedPoint32 number_of_items = number_of_items_remainder.getItem1();
        BigInteger remainder = number_of_items_remainder.getItem2();
        if (curve_type == LINEAR_CURVE) {
            BigInteger delta = get_linear_curve_price_delta(start_price, price_delta_numerator, price_delta_denominator);
            return get_linear_curve_buy_info(
                    number_of_items,
                    item_amount,
                    spot_price,
                    delta,
                    remainder
            );
        } else {
            FixedPoint32 multiplier = get_exponential_curve_price_multiplier(price_delta_numerator, price_delta_denominator);
            return get_exponential_curve_buy_info(
                    number_of_items,
                    item_amount,
                    spot_price,
                    multiplier,
                    price_delta_numerator,
                    price_delta_denominator,
                    remainder
            );
        }
    }

    /*
    public fun get_sell_info(
        curve_type: u8,
        amount: u64,
        item_amount: u64,
        spot_price: u64,
        start_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): (u64, u64) {
        let (number_of_items, _remainder) = get_number_of_items_and_remainder(
            amount,
            item_amount
        ); // _remainder is not used
        if (curve_type == LINEAR_CURVE) {
            assert!(is_valid_curve_type(curve_type), EInvalidCurveType);
            let delta = get_linear_curve_price_delta(start_price, price_delta_numerator, price_delta_denominator);
            get_linear_curve_sell_info(
                number_of_items,
                item_amount,
                spot_price,
                delta,
            )
        } else {
            //start_price is not used, all based on the current spot_price?
            let multiplier = get_exponential_curve_price_multiplier(price_delta_numerator, price_delta_denominator);
            get_exponential_curve_sell_info(
                number_of_items,
                item_amount,
                spot_price,
                multiplier,
                price_delta_numerator,
                price_delta_denominator
            )
        }
    }
     */
    public static Pair<BigInteger, BigInteger> getSellInfo(
            byte curve_type,
            BigInteger amount,
            BigInteger item_amount,
            BigInteger spot_price,
            BigInteger start_price,
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator
    ) {
        Pair<FixedPoint32, BigInteger> number_of_items_remainder = get_number_of_items_and_remainder(amount, item_amount);
        FixedPoint32 number_of_items = number_of_items_remainder.getItem1();
        BigInteger remainder = number_of_items_remainder.getItem2();
        if (curve_type == LINEAR_CURVE) {
            if (!isValidCurveType(curve_type)) {
                throw new IllegalArgumentException("Invalid curve type");
            }
            BigInteger delta = get_linear_curve_price_delta(start_price, price_delta_numerator, price_delta_denominator);
            return get_linear_curve_sell_info(
                    number_of_items,
                    item_amount,
                    spot_price,
                    delta
            );
        } else {
            FixedPoint32 multiplier = get_exponential_curve_price_multiplier(price_delta_numerator, price_delta_denominator);
            return get_exponential_curve_sell_info(
                    number_of_items,
                    item_amount,
                    spot_price,
                    multiplier,
                    price_delta_numerator,
                    price_delta_denominator
            );
        }
    }

    /*
    fun get_linear_curve_buy_info(
        number_of_items: FixedPoint32,
        item_amount: u64,
        spot_price: u64,
        delta: u64,
        amount_remainder: u64,
    ): (u64, u64) {
        let new_spot_price = spot_price + fixed_point32::multiply_u64(delta, number_of_items);
        let number_of_items_plus_one = fixed_point32_util::plus_one(number_of_items);
        let y_amount = item_amount * fixed_point32::multiply_u64(spot_price, number_of_items) +
            item_amount * fixed_point32::multiply_u64(
                fixed_point32::multiply_u64(
                    delta,
                    number_of_items
                ),
                number_of_items_plus_one
            ) / 2;
        if (amount_remainder > 0) {
            y_amount = amount_remainder * new_spot_price;
        };
        (y_amount, new_spot_price)
    }
     */
    private static Pair<BigInteger, BigInteger> get_linear_curve_buy_info(
            FixedPoint32 number_of_items,
            BigInteger item_amount,
            BigInteger spot_price,
            BigInteger delta,
            BigInteger amount_remainder
    ) {
        BigInteger new_spot_price = spot_price.add(FixedPoint32.multiplyU64(delta, number_of_items));
        FixedPoint32 number_of_items_plus_one = number_of_items.plusOne();
        BigInteger y_amount = item_amount.multiply(FixedPoint32.multiplyU64(spot_price, number_of_items))
                .add(item_amount.multiply(FixedPoint32.multiplyU64(
                        FixedPoint32.multiplyU64(delta, number_of_items),
                        number_of_items_plus_one
                )).divide(BigInteger.valueOf(2)));
        if (amount_remainder.compareTo(BigInteger.ZERO) > 0) {
            y_amount = amount_remainder.multiply(new_spot_price);
        }
        return Pair.of(y_amount, new_spot_price);
    }

    /*
    fun get_linear_curve_sell_info(
        number_of_items: FixedPoint32,
        item_amount: u64,
        spot_price: u64,
        delta: u64,
    ): (u64, u64) {
        // We first calculate the change in spot price after selling all of the items
        let total_price_decrease = fixed_point32::multiply_u64(delta, number_of_items);
        let new_spot_price = if (spot_price < total_price_decrease) {
            // If the current spot price is less than the total y_amount that the spot price should change by...
            // We calculate how many items we can sell into the linear curve until the spot price reaches 0
            let number_of_items_till_zero_price = fixed_point32::create_from_rational(spot_price, delta);
            number_of_items = number_of_items_till_zero_price;
            0
        } else {
            // Otherwise, the current spot price is greater than or equal to the total y_amount that the spot price changes
            // The new spot price is just the change between spot price and the total price change
            spot_price - total_price_decrease
        };
        let y_amount = item_amount * fixed_point32::multiply_u64(spot_price + new_spot_price, number_of_items) / 2;
        (y_amount, new_spot_price)
    }
     */
    private static Pair<BigInteger, BigInteger> get_linear_curve_sell_info(
            FixedPoint32 number_of_items,
            BigInteger item_amount,
            BigInteger spot_price,
            BigInteger delta
    ) {
        BigInteger total_price_decrease = FixedPoint32.multiplyU64(delta, number_of_items);
        BigInteger new_spot_price;
        if (spot_price.compareTo(total_price_decrease) < 0) {
            BigInteger number_of_items_till_zero_price = FixedPoint32.createFromRational(spot_price, delta).toBigInteger();
            number_of_items = FixedPoint32.createFromRawValue(number_of_items_till_zero_price);
            new_spot_price = BigInteger.ZERO;
        } else {
            new_spot_price = spot_price.subtract(total_price_decrease);
        }
        BigInteger y_amount = item_amount.multiply(
                FixedPoint32.multiplyU64(spot_price.add(new_spot_price), number_of_items)
        ).divide(BigInteger.valueOf(2));
        return Pair.of(y_amount, new_spot_price);
    }

    /*
    fun get_exponential_curve_buy_info(
        number_of_items: FixedPoint32,
        item_amount: u64,
        spot_price: u64,
        multiplier: FixedPoint32,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        amount_remainder: u64,
    ): (u64, u64) {
        assert!(fixed_point32_util::greater_or_equal_than_one(multiplier), EMultiplierLessThanOne);
        if (spot_price < MINIMUM_SPOT_PRICE) {
            spot_price = MINIMUM_SPOT_PRICE;
        };
        let (n, f) = fixed_point32_util::integer_and_fractional(number_of_items);
        let multiplier_pow_n = fixed_point32_util::pow(multiplier, n);
        let buy_spot_price = fixed_point32::multiply_u64(spot_price, multiplier);
        let y_amount = item_amount * fixed_point32::multiply_u64(
            buy_spot_price,
            fixed_point32_util::divide(
                fixed_point32_util::minus_one(multiplier_pow_n),
                fixed_point32_util::minus_one(multiplier)
            )
        );
        // For an exponential curve, the spot price is multiplied by delta for each item bought
        let new_spot_price = fixed_point32::multiply_u64(spot_price, multiplier_pow_n);
        if (f > 0) {
            new_spot_price = get_fractional_spot_price(
                new_spot_price,
                price_delta_numerator,
                price_delta_denominator,
                f,
                false
            );
            y_amount = y_amount + item_amount * fixed_point32::multiply_u64(
                new_spot_price,
                fixed_point32::create_from_raw_value(f)
            );
        };
        if (amount_remainder > 0) {
            y_amount = amount_remainder * new_spot_price;
        };
        (y_amount, new_spot_price)
    }
     */
    private static Pair<BigInteger, BigInteger> get_exponential_curve_buy_info(
            FixedPoint32 number_of_items,
            BigInteger item_amount,
            BigInteger spot_price,
            FixedPoint32 multiplier,
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator,
            BigInteger amount_remainder
    ) {
        if (!multiplier.greaterOrEqualThanOne()) {
            throw new IllegalArgumentException("Multiplier less than one");
        }
        if (spot_price.compareTo(MINIMUM_SPOT_PRICE) < 0) {
            spot_price = MINIMUM_SPOT_PRICE;
        }
        BigInteger[] n_f = number_of_items.integerAndFractional();
        BigInteger n = n_f[0];
        BigInteger f = n_f[1];
        FixedPoint32 multiplier_pow_n = multiplier.pow(n);
        BigInteger buy_spot_price = FixedPoint32.multiplyU64(spot_price, multiplier);
        BigInteger y_amount = item_amount.multiply(FixedPoint32.multiplyU64(
                buy_spot_price,
                multiplier_pow_n.minusOne().divide(
                        multiplier.minusOne()
                )
        ));
        BigInteger new_spot_price = FixedPoint32.multiplyU64(spot_price, multiplier_pow_n);
        if (f.compareTo(BigInteger.ZERO) > 0) {
            new_spot_price = get_fractional_spot_price(
                    new_spot_price,
                    price_delta_numerator,
                    price_delta_denominator,
                    f,
                    false
            );
            y_amount = y_amount.add(item_amount.multiply(FixedPoint32.multiplyU64(
                    new_spot_price,
                    FixedPoint32.createFromRawValue(f)
            )));
        }
        if (amount_remainder.compareTo(BigInteger.ZERO) > 0) {
            y_amount = amount_remainder.multiply(new_spot_price);
        }
        return Pair.of(y_amount, new_spot_price);
    }

    /*
    fun get_exponential_curve_sell_info(
        number_of_items: FixedPoint32,
        item_amount: u64,
        spot_price: u64,
        multiplier: FixedPoint32,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
    ): (u64, u64) {
        assert!(fixed_point32_util::greater_or_equal_than_one(multiplier), EMultiplierLessThanOne);
        let inv_multiplier = fixed_point32_util::reciprocal(multiplier);
        let (n, f) = fixed_point32_util::integer_and_fractional(number_of_items);
        let inv_multiplier_pow_n = fixed_point32_util::pow(inv_multiplier, n);
        let sell_spot_price = fixed_point32::multiply_u64(spot_price, inv_multiplier);
        // If the user sells n items, then the total revenue is equal to:
        // spot_price + ((1 / multiplier) * spot_price) + ((1 / multiplier)^2 * spot_price) + ... ((1 / multiplier)^(numItems - 1) * spot_price)
        // This is equal to spot_price * (1 - (1 / multiplier^n)) / (1 - (1 / multiplier))
        let y_amount = item_amount * fixed_point32::multiply_u64(
            sell_spot_price, // ??? or just use this: spot_price,
            fixed_point32_util::divide(
                fixed_point32_util::one_minus(inv_multiplier_pow_n),
                fixed_point32_util::one_minus(inv_multiplier)
            )
        );
        let new_spot_price = fixed_point32::multiply_u64(spot_price, inv_multiplier_pow_n);
        if (f > 0) {
            new_spot_price = get_fractional_spot_price(
                new_spot_price,
                price_delta_numerator,
                price_delta_denominator,
                f,
                true
            );
            y_amount = y_amount + item_amount * fixed_point32::multiply_u64(
                new_spot_price,
                fixed_point32::create_from_raw_value(f)
            );
        };
        (y_amount, new_spot_price)
    }
     */
    private static Pair<BigInteger, BigInteger> get_exponential_curve_sell_info(
            FixedPoint32 number_of_items,
            BigInteger item_amount,
            BigInteger spot_price,
            FixedPoint32 multiplier,
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator
    ) {
        if (!multiplier.greaterOrEqualThanOne()) {
            throw new IllegalArgumentException("Multiplier less than one");
        }
        FixedPoint32 inv_multiplier = multiplier.reciprocal();
        BigInteger[] n_f = number_of_items.integerAndFractional();
        BigInteger n = n_f[0];
        BigInteger f = n_f[1];
        FixedPoint32 inv_multiplier_pow_n = inv_multiplier.pow(n);
        BigInteger sell_spot_price = FixedPoint32.multiplyU64(spot_price, inv_multiplier);
        BigInteger y_amount = item_amount.multiply(FixedPoint32.multiplyU64(
                sell_spot_price,
                FixedPoint32.oneMinus(inv_multiplier_pow_n).divide(
                        FixedPoint32.oneMinus(inv_multiplier)
                )
        ));
        BigInteger new_spot_price = FixedPoint32.multiplyU64(spot_price, inv_multiplier_pow_n);
        if (f.compareTo(BigInteger.ZERO) > 0) {
            new_spot_price = get_fractional_spot_price(
                    new_spot_price,
                    price_delta_numerator,
                    price_delta_denominator,
                    f,
                    true
            );
            y_amount = y_amount.add(item_amount.multiply(FixedPoint32.multiplyU64(
                    new_spot_price,
                    FixedPoint32.createFromRawValue(f)
            )));
        }
        return Pair.of(y_amount, new_spot_price);
    }

    /*
    fun get_exponential_curve_price_multiplier(
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): FixedPoint32 {
        fixed_point32_util::plus_one(fixed_point32::create_from_rational(
            price_delta_numerator,
            price_delta_denominator
        ))
    }
     */
    private static FixedPoint32 get_exponential_curve_price_multiplier(
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator
    ) {
        return FixedPoint32.createFromRational(
                price_delta_numerator, price_delta_denominator
        ).plusOne();
    }

    /*
    /// Need to apply an additional price adjustment if the presence of the fractional part.
    fun get_fractional_spot_price(
        spot_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        fractional: u64,
        downward: bool
    ): u64 {
        if (fractional == 0) {
            spot_price
        } else {
            let linear_delta = get_linear_curve_price_delta(
                spot_price,
                price_delta_numerator,
                price_delta_denominator
            );
            let d = fixed_point32::multiply_u64(linear_delta, fixed_point32::create_from_raw_value(fractional));
            let fsp = if (downward) {
                spot_price - if (d > spot_price) { spot_price } else { d }
            } else {
                spot_price + d
            };
            fsp
        }
    }
     */
    private static BigInteger get_fractional_spot_price(
            BigInteger spot_price,
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator,
            BigInteger fractional,
            boolean downward
    ) {
        if (fractional.compareTo(BigInteger.ZERO) == 0) {
            return spot_price;
        } else {
            BigInteger linear_delta = get_linear_curve_price_delta(spot_price, price_delta_numerator, price_delta_denominator);
            BigInteger d = FixedPoint32.multiplyU64(linear_delta, FixedPoint32.createFromRawValue(fractional));
            BigInteger fsp = downward
                    ? spot_price.subtract(d.compareTo(spot_price) > 0 ? spot_price : d)
                    : spot_price.add(d);
            return fsp;
        }
    }

    /*
    fun get_linear_curve_price_delta(
        start_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): u64 {
        let delta = fixed_point32::multiply_u64(start_price, fixed_point32::create_from_rational(
            price_delta_numerator,
            price_delta_denominator
        ));
        delta
    }
     */
    private static BigInteger get_linear_curve_price_delta(
            BigInteger start_price,
            BigInteger price_delta_numerator,
            BigInteger price_delta_denominator) {
        return FixedPoint32.multiplyU64(start_price, FixedPoint32.createFromRational(
                price_delta_numerator, price_delta_denominator
        ));
    }

    /*
    fun get_number_of_items_and_remainder(amount: u64, item_amount: u64): (FixedPoint32, u64) {
        let number_of_items = fixed_point32::create_from_rational(amount, item_amount);
        let remainder = amount - fixed_point32::multiply_u64(item_amount, number_of_items);
        (number_of_items, remainder)
    }
    */
    private static Pair<FixedPoint32, BigInteger> get_number_of_items_and_remainder(BigInteger amount, BigInteger item_amount) {
        FixedPoint32 number_of_items = FixedPoint32.createFromRational(amount, item_amount);
        BigInteger remainder = amount.subtract(FixedPoint32.multiplyU64(item_amount, number_of_items));
        return Pair.of(number_of_items, remainder);
    }

    /*
    /// Return integer part and fractional of a fixed point number
    public fun integer_and_fractional(value: FixedPoint32): (u64, u64) {
        let raw_value = fixed_point32::get_raw_value(value);
        (raw_value / SCALING_FACTOR, raw_value % SCALING_FACTOR)
    }
     */
//    private static Pair<BigInteger, BigDecimal> integer_and_fractional(BigDecimal value) {
//        BigInteger i = value.toBigInteger();
//        BigDecimal f = value.subtract(new BigDecimal(i));
//        return Pair.of(i, f);
//    }

}
