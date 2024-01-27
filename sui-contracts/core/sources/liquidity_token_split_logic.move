// #[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
// module sui_swap_example::liquidity_token_split_logic {
//     use sui::tx_context::TxContext;
//
//     use sui_swap_example::liquidity_token::{Self, LiquidityToken};
//     use sui_swap_example::liquidity_token_split;
//
//     friend sui_swap_example::liquidity_token_aggregate;
//
//     const EInvalidAmount: u64 = 100;
//
//     public(friend) fun verify<Y>(
//         amount: u64,
//         liquidity_token: &liquidity_token::LiquidityToken<Y>,
//         _ctx: &TxContext,
//     ): liquidity_token::LiquidityTokenSplit {
//         assert!(amount > 0 && amount < liquidity_token::amount(liquidity_token), EInvalidAmount);
//         liquidity_token::new_liquidity_token_split(liquidity_token, amount)
//     }
//
//     public(friend) fun mutate<Y>(
//         liquidity_token_split: &liquidity_token::LiquidityTokenSplit,
//         liquidity_token: liquidity_token::LiquidityToken<Y>,
//         ctx: &mut TxContext,
//     ): (LiquidityToken<Y>, LiquidityToken<Y>) {
//         let amount = liquidity_token_split::amount(liquidity_token_split);
//         let x_token_type = liquidity_token::x_token_type(&liquidity_token);
//         let remaining_amount = liquidity_token::amount(&liquidity_token) - amount;
//         liquidity_token::set_amount(&mut liquidity_token, remaining_amount);
//
//         let split_liquidity_token = liquidity_token::new_liquidity_token(
//             x_token_type,
//             amount,
//             ctx,
//         );
//         let split_liqudity_token_minted = liquidity_token::new_liquidity_token_minted<Y>(
//             x_token_type,
//             amount,
//         );
//         liquidity_token::set_liquidity_token_minted_id(
//             &mut split_liqudity_token_minted,
//             liquidity_token::id(&split_liquidity_token),
//         );
//         liquidity_token::emit_liquidity_token_minted(split_liqudity_token_minted);
//
//         (liquidity_token, split_liquidity_token)
//     }
// }
