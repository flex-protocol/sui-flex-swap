#[test_only]
module sui_swap_example::liquidity_util_tests {
    use std::debug;

    use sui_swap_example::liquidity_util;

    #[test]
    public fun liquidity_util_test() {
        let l = liquidity_util::calculate_liquidity(1000, 100, 10, 100, 11);
        debug::print(&l);
        //debug::print(&x_r);
        //debug::print(&y_r);
        let l = liquidity_util::calculate_liquidity(1000, 100, 10, 99, 10);
        debug::print(&l);
        //debug::print(&x_r);
        //debug::print(&y_r);
    }
}
