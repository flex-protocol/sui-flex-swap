module nft_service_impl::test_equipment_service_impl {
    use example_tokens::equipment::{Self, Equipment};
    use sui_swap_core::nft_service;
    use sui_swap_core::nft_service_config::NftServiceConfig;

    struct TestEquipmentServiceImpl has drop {}

    public fun get_amount<C>(
        config: &NftServiceConfig,
        get_amount_request: nft_service::GetAmountRequest<Equipment, C>
    ): nft_service::GetAmountResponse<Equipment, TestEquipmentServiceImpl, C> {
        let x = nft_service::get_get_amount_request_all_parameters(&get_amount_request);
        let result: u64 = equipment::amount(x);
        nft_service::new_get_amount_response(
            config,
            TestEquipmentServiceImpl {},
            result,
            get_amount_request
        )
    }
}
