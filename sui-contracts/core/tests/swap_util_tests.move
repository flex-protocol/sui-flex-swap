#[test_only]
module sui_swap_example::swap_util_tests {
    use std::debug;

    use sui_swap_example::swap_util;

    #[test]
    public fun swap_util_test() {
        let out_1 = swap_util::swap(10_000_000_000, 100_000_000, 10_000_293, 98_905);
        debug::print(&out_1);
        let out_2 = swap_util::swap(10_000_000_000, 100_000_000, 10_030, 100);
        debug::print(&out_2);
    }
}
