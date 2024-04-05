// module nft_service_impl::movescription_service_impl {
//     use sui_swap_core::nft_service;
//     use sui_swap_core::nft_service_config::NftServiceConfig;
//     use smartinscription::movescription::{Self, Movescription};
//
//     struct MovescriptionServiceImpl has drop {}
//
//     public fun get_amount<C>(
//         config: &NftServiceConfig,
//         get_amount_request: nft_service::GetAmountRequest<Movescription, C>
//     ): nft_service::GetAmountResponse<Movescription, MovescriptionServiceImpl, C> {
//         let x = nft_service::get_get_amount_request_all_parameters(&get_amount_request);
//         let result: u64 = movescription::amount(x);
//         nft_service::new_get_amount_response(
//             config,
//             MovescriptionServiceImpl {},
//             result,
//             get_amount_request
//         )
//     }
// }
