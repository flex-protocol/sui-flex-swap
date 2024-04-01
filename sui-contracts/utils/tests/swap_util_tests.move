#[test_only]
module sui_swap_utils::swap_util_tests {
    use sui_swap_utils::swap_util;

    const FEE_NUMERATOR: u64 = 3;
    const FEE_DENOMINATOR: u64 = 1000;

    #[test]
    public fun swap_util_test() {
        let out_1 = swap_util::swap(10_000_000_000, 100_000_000, 10_000_293, 98_905, FEE_NUMERATOR, FEE_DENOMINATOR);
        //debug::print(&out_1);
        let out_2 = swap_util::swap(10_000_000_000, 100_000_000, 10_030, 100, FEE_NUMERATOR, FEE_DENOMINATOR);
        //debug::print(&out_2);
    }
}
