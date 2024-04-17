// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::liquidity_token {
    use std::option;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct LIQUIDITY_TOKEN has drop {}

    friend sui_swap_example::liquidity_token_mint_logic;
    friend sui_swap_example::liquidity_token_destroy_logic;
    friend sui_swap_example::liquidity_token_aggregate;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    const EEmptyObjectID: u64 = 107;

    fun init(otw: LIQUIDITY_TOKEN, ctx: &mut TxContext) {
        sui::package::claim_and_keep(otw, ctx);
    }

    struct LiquidityToken<phantom X, phantom Y> has key, store {
        id: UID,
        amount: u64,
    }

    public fun id<X, Y>(liquidity_token: &LiquidityToken<X, Y>): object::ID {
        object::uid_to_inner(&liquidity_token.id)
    }

    public fun amount<X, Y>(liquidity_token: &LiquidityToken<X, Y>): u64 {
        liquidity_token.amount
    }

    public(friend) fun set_amount<X, Y>(liquidity_token: &mut LiquidityToken<X, Y>, amount: u64) {
        liquidity_token.amount = amount;
    }

    public(friend) fun new_liquidity_token<X, Y>(
        amount: u64,
        ctx: &mut TxContext,
    ): LiquidityToken<X, Y> {
        LiquidityToken {
            id: object::new(ctx),
            amount,
        }
    }

    struct LiquidityTokenMinted has copy, drop {
        id: option::Option<object::ID>,
        amount: u64,
    }

    public fun liquidity_token_minted_id(liquidity_token_minted: &LiquidityTokenMinted): option::Option<object::ID> {
        liquidity_token_minted.id
    }

    public(friend) fun set_liquidity_token_minted_id(liquidity_token_minted: &mut LiquidityTokenMinted, id: object::ID) {
        liquidity_token_minted.id = option::some(id);
    }

    public fun liquidity_token_minted_amount(liquidity_token_minted: &LiquidityTokenMinted): u64 {
        liquidity_token_minted.amount
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_liquidity_token_minted<X, Y>(
        amount: u64,
    ): LiquidityTokenMinted {
        LiquidityTokenMinted {
            id: option::none(),
            amount,
        }
    }

    struct LiquidityTokenDestroyed has copy, drop {
        id: object::ID,
        amount: u64,
    }

    public fun liquidity_token_destroyed_id(liquidity_token_destroyed: &LiquidityTokenDestroyed): object::ID {
        liquidity_token_destroyed.id
    }

    public fun liquidity_token_destroyed_amount(liquidity_token_destroyed: &LiquidityTokenDestroyed): u64 {
        liquidity_token_destroyed.amount
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_liquidity_token_destroyed<X, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        amount: u64,
    ): LiquidityTokenDestroyed {
        LiquidityTokenDestroyed {
            id: id(liquidity_token),
            amount,
        }
    }


    #[lint_allow(custom_state_change)]
    public(friend) fun transfer_object<X, Y>(liquidity_token: LiquidityToken<X, Y>, recipient: address) {
        transfer::transfer(liquidity_token, recipient);
    }

    public(friend) fun drop_liquidity_token<X, Y>(liquidity_token: LiquidityToken<X, Y>) {
        let LiquidityToken {
            id,
            amount: _amount,
        } = liquidity_token;
        object::delete(id);
    }

    public(friend) fun emit_liquidity_token_minted(liquidity_token_minted: LiquidityTokenMinted) {
        assert!(std::option::is_some(&liquidity_token_minted.id), EEmptyObjectID);
        event::emit(liquidity_token_minted);
    }

    public(friend) fun emit_liquidity_token_destroyed(liquidity_token_destroyed: LiquidityTokenDestroyed) {
        event::emit(liquidity_token_destroyed);
    }

}
