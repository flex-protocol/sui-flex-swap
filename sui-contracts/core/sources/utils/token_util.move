module sui_swap_core::token_util {
    use std::bcs;
    use std::type_name;

    use sui_swap_core::compare;

    //const EQUAL: u8 = 0;
    const LESS_THAN: u8 = 1;
    //const GREATER_THAN: u8 = 2;

    const EXNotLessThanY: u64 = 100;

    public fun assert_type_less_than<X, Y>() {
        let x = type_name::into_string(type_name::get<X>());
        let y = type_name::into_string(type_name::get<Y>());
        let x_bytes = bcs::to_bytes(&x);
        let y_bytes = bcs::to_bytes(&y);
        assert!(compare::cmp_bcs_bytes(&x_bytes, &y_bytes) == LESS_THAN, EXNotLessThanY);
    }
}
