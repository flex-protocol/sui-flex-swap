module sui_swap_core::trade_pool_util {

    use sui_swap_utils::price_curve;

    const EInvalidPriceCurveType: u64 = 1;

    const EInvalidExchangeRateNumerator: u64 = 11;
    const EInvalidExchangeRateDenominator: u64 = 12;
    const EInvalidPriceDeltaXAmount: u64 = 13;
    const EInvalidPriceDeltaDenominator: u64 = 14;

    public fun assert_trade_pool_initialize_exchange_rate_arguments(
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
    ) {
        assert!(exchange_rate_numerator > 0, EInvalidExchangeRateNumerator);
        assert!(exchange_rate_denominator > 0, EInvalidExchangeRateDenominator);
        assert!(price_delta_x_amount > 0, EInvalidPriceDeltaXAmount);
        assert!(price_delta_denominator > 0, EInvalidPriceDeltaDenominator);
        assert!(price_curve::is_valid_curve_type(price_curve_type), EInvalidPriceCurveType);
        let _ = price_delta_numerator;
    }
}
