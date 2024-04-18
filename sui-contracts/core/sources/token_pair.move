// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_core::token_pair {
    use std::option::{Self, Option};
    use std::string::String;
    use sui::balance::Balance;
    use sui::event;
    use sui::object::{Self, ID, UID};
    use sui::object_table::ObjectTable;
    use sui::table::Table;
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct TOKEN_PAIR has drop {}

    friend sui_swap_core::token_pair_initialize_liquidity_logic;
    friend sui_swap_core::token_pair_add_liquidity_logic;
    friend sui_swap_core::token_pair_remove_liquidity_logic;
    friend sui_swap_core::token_pair_destroy_logic;
    friend sui_swap_core::token_pair_swap_x_logic;
    friend sui_swap_core::token_pair_swap_y_logic;
    friend sui_swap_core::token_pair_update_fee_rate_logic;
    friend sui_swap_core::token_pair_aggregate;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    const EInappropriateVersion: u64 = 103;
    const EEmptyObjectID: u64 = 107;

    /// Not the right admin for the object
    const ENotAdmin: u64 = 0;
    /// Migration is not an upgrade
    const ENotUpgrade: u64 = 1;
    /// Calling functions from the wrong package version
    const EWrongSchemaVersion: u64 = 2;

    const SCHEMA_VERSION: u64 = 0;

    struct AdminCap has key {
        id: UID,
    }


    fun init(otw: TOKEN_PAIR, ctx: &mut TxContext) {
        sui::package::claim_and_keep(otw, ctx);
    }

    public fun assert_schema_version<X: key + store, Y>(token_pair: &TokenPair<X, Y>) {
        assert!(token_pair.schema_version == SCHEMA_VERSION, EWrongSchemaVersion);
    }

    struct TokenPair<phantom X: key + store, phantom Y> has key {
        id: UID,
        version: u64,
        schema_version: u64,
        admin_cap: ID,
        x_reserve: ObjectTable<ID, X>,
        x_amounts: Table<ID, u64>,
        x_total_amount: u64,
        y_reserve: Balance<Y>,
        total_liquidity: u64,
        liquidity_token_id: ID,
        fee_numerator: u64,
        fee_denominator: u64,
    }

    public fun id<X: key + store, Y>(token_pair: &TokenPair<X, Y>): object::ID {
        object::uid_to_inner(&token_pair.id)
    }

    public fun version<X: key + store, Y>(token_pair: &TokenPair<X, Y>): u64 {
        token_pair.version
    }

    public fun borrow_x_reserve<X: key + store, Y>(token_pair: &TokenPair<X, Y>): &ObjectTable<ID, X> {
        &token_pair.x_reserve
    }

    public(friend) fun borrow_mut_x_reserve<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>): &mut ObjectTable<ID, X> {
        &mut token_pair.x_reserve
    }

    public fun borrow_x_amounts<X: key + store, Y>(token_pair: &TokenPair<X, Y>): &Table<ID, u64> {
        &token_pair.x_amounts
    }

    public(friend) fun borrow_mut_x_amounts<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>): &mut Table<ID, u64> {
        &mut token_pair.x_amounts
    }

    public fun x_total_amount<X: key + store, Y>(token_pair: &TokenPair<X, Y>): u64 {
        token_pair.x_total_amount
    }

    public(friend) fun set_x_total_amount<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>, x_total_amount: u64) {
        token_pair.x_total_amount = x_total_amount;
    }

    public fun borrow_y_reserve<X: key + store, Y>(token_pair: &TokenPair<X, Y>): &Balance<Y> {
        &token_pair.y_reserve
    }

    public(friend) fun borrow_mut_y_reserve<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>): &mut Balance<Y> {
        &mut token_pair.y_reserve
    }

    public fun total_liquidity<X: key + store, Y>(token_pair: &TokenPair<X, Y>): u64 {
        token_pair.total_liquidity
    }

    public(friend) fun set_total_liquidity<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>, total_liquidity: u64) {
        token_pair.total_liquidity = total_liquidity;
    }

    public fun liquidity_token_id<X: key + store, Y>(token_pair: &TokenPair<X, Y>): ID {
        token_pair.liquidity_token_id
    }

    public(friend) fun set_liquidity_token_id<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>, liquidity_token_id: ID) {
        token_pair.liquidity_token_id = liquidity_token_id;
    }

    public fun fee_numerator<X: key + store, Y>(token_pair: &TokenPair<X, Y>): u64 {
        token_pair.fee_numerator
    }

    public(friend) fun set_fee_numerator<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>, fee_numerator: u64) {
        token_pair.fee_numerator = fee_numerator;
    }

    public fun fee_denominator<X: key + store, Y>(token_pair: &TokenPair<X, Y>): u64 {
        token_pair.fee_denominator
    }

    public(friend) fun set_fee_denominator<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>, fee_denominator: u64) {
        token_pair.fee_denominator = fee_denominator;
    }

    public fun admin_cap<X: key + store, Y>(token_pair: &TokenPair<X, Y>): ID {
        token_pair.admin_cap
    }

    public(friend) fun new_token_pair<X: key + store, Y>(
        x_reserve: ObjectTable<ID, X>,
        x_amounts: Table<ID, u64>,
        x_total_amount: u64,
        total_liquidity: u64,
        liquidity_token_id: ID,
        fee_numerator: u64,
        fee_denominator: u64,
        ctx: &mut TxContext,
    ): TokenPair<X, Y> {
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        let admin_cap_id = object::id(&admin_cap);
        transfer::transfer(admin_cap, sui::tx_context::sender(ctx));
        TokenPair {
            id: object::new(ctx),
            version: 0,
            schema_version: SCHEMA_VERSION,
            admin_cap: admin_cap_id,
            x_reserve,
            x_amounts,
            x_total_amount,
            y_reserve: sui::balance::zero(),
            total_liquidity,
            liquidity_token_id,
            fee_numerator,
            fee_denominator,
        }
    }

    entry fun migrate<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>, a: &AdminCap) {
        assert!(token_pair.admin_cap == object::id(a), ENotAdmin);
        assert!(token_pair.schema_version < SCHEMA_VERSION, ENotUpgrade);
        token_pair.schema_version = SCHEMA_VERSION;
    }

    struct LiquidityInitialized has copy, drop {
        id: option::Option<object::ID>,
        exchange_id: ID,
        fee_numerator: u64,
        fee_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        liquidity_amount: u64,
        liquidity_token_id: Option<ID>,
        x_id: ID,
    }

    public fun liquidity_initialized_id(liquidity_initialized: &LiquidityInitialized): option::Option<object::ID> {
        liquidity_initialized.id
    }

    public(friend) fun set_liquidity_initialized_id(liquidity_initialized: &mut LiquidityInitialized, id: object::ID) {
        liquidity_initialized.id = option::some(id);
    }

    public fun liquidity_initialized_exchange_id(liquidity_initialized: &LiquidityInitialized): ID {
        liquidity_initialized.exchange_id
    }

    public fun liquidity_initialized_fee_numerator(liquidity_initialized: &LiquidityInitialized): u64 {
        liquidity_initialized.fee_numerator
    }

    public fun liquidity_initialized_fee_denominator(liquidity_initialized: &LiquidityInitialized): u64 {
        liquidity_initialized.fee_denominator
    }

    public fun liquidity_initialized_provider(liquidity_initialized: &LiquidityInitialized): address {
        liquidity_initialized.provider
    }

    public fun liquidity_initialized_x_token_type(liquidity_initialized: &LiquidityInitialized): String {
        liquidity_initialized.x_token_type
    }

    public fun liquidity_initialized_y_token_type(liquidity_initialized: &LiquidityInitialized): String {
        liquidity_initialized.y_token_type
    }

    public fun liquidity_initialized_x_amount(liquidity_initialized: &LiquidityInitialized): u64 {
        liquidity_initialized.x_amount
    }

    public fun liquidity_initialized_y_amount(liquidity_initialized: &LiquidityInitialized): u64 {
        liquidity_initialized.y_amount
    }

    public fun liquidity_initialized_liquidity_amount(liquidity_initialized: &LiquidityInitialized): u64 {
        liquidity_initialized.liquidity_amount
    }

    public fun liquidity_initialized_liquidity_token_id(liquidity_initialized: &LiquidityInitialized): Option<ID> {
        liquidity_initialized.liquidity_token_id
    }

    public(friend) fun set_liquidity_initialized_liquidity_token_id(liquidity_initialized: &mut LiquidityInitialized, liquidity_token_id: Option<ID>) {
        liquidity_initialized.liquidity_token_id = liquidity_token_id;
    }

    public fun liquidity_initialized_x_id(liquidity_initialized: &LiquidityInitialized): ID {
        liquidity_initialized.x_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_liquidity_initialized<X: key + store, Y>(
        exchange_id: ID,
        fee_numerator: u64,
        fee_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        liquidity_amount: u64,
        liquidity_token_id: Option<ID>,
        x_id: ID,
    ): LiquidityInitialized {
        LiquidityInitialized {
            id: option::none(),
            exchange_id,
            fee_numerator,
            fee_denominator,
            provider,
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
            liquidity_amount,
            liquidity_token_id,
            x_id,
        }
    }

    struct LiquidityAdded has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        liquidity_amount: u64,
        x_id: ID,
    }

    public fun liquidity_added_id(liquidity_added: &LiquidityAdded): object::ID {
        liquidity_added.id
    }

    public fun liquidity_added_liquidity_token_id(liquidity_added: &LiquidityAdded): ID {
        liquidity_added.liquidity_token_id
    }

    public fun liquidity_added_provider(liquidity_added: &LiquidityAdded): address {
        liquidity_added.provider
    }

    public fun liquidity_added_x_token_type(liquidity_added: &LiquidityAdded): String {
        liquidity_added.x_token_type
    }

    public fun liquidity_added_y_token_type(liquidity_added: &LiquidityAdded): String {
        liquidity_added.y_token_type
    }

    public fun liquidity_added_x_amount(liquidity_added: &LiquidityAdded): u64 {
        liquidity_added.x_amount
    }

    public fun liquidity_added_y_amount(liquidity_added: &LiquidityAdded): u64 {
        liquidity_added.y_amount
    }

    public fun liquidity_added_liquidity_amount(liquidity_added: &LiquidityAdded): u64 {
        liquidity_added.liquidity_amount
    }

    public fun liquidity_added_x_id(liquidity_added: &LiquidityAdded): ID {
        liquidity_added.x_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_liquidity_added<X: key + store, Y>(
        token_pair: &TokenPair<X, Y>,
        liquidity_token_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        liquidity_amount: u64,
        x_id: ID,
    ): LiquidityAdded {
        LiquidityAdded {
            id: id(token_pair),
            version: version(token_pair),
            liquidity_token_id,
            provider,
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
            liquidity_amount,
            x_id,
        }
    }

    struct LiquidityRemoved has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        x_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        liquidity_amount: u64,
    }

    public fun liquidity_removed_id(liquidity_removed: &LiquidityRemoved): object::ID {
        liquidity_removed.id
    }

    public fun liquidity_removed_liquidity_token_id(liquidity_removed: &LiquidityRemoved): ID {
        liquidity_removed.liquidity_token_id
    }

    public fun liquidity_removed_x_id(liquidity_removed: &LiquidityRemoved): ID {
        liquidity_removed.x_id
    }

    public fun liquidity_removed_provider(liquidity_removed: &LiquidityRemoved): address {
        liquidity_removed.provider
    }

    public fun liquidity_removed_x_token_type(liquidity_removed: &LiquidityRemoved): String {
        liquidity_removed.x_token_type
    }

    public fun liquidity_removed_y_token_type(liquidity_removed: &LiquidityRemoved): String {
        liquidity_removed.y_token_type
    }

    public fun liquidity_removed_x_amount(liquidity_removed: &LiquidityRemoved): u64 {
        liquidity_removed.x_amount
    }

    public fun liquidity_removed_y_amount(liquidity_removed: &LiquidityRemoved): u64 {
        liquidity_removed.y_amount
    }

    public fun liquidity_removed_liquidity_amount(liquidity_removed: &LiquidityRemoved): u64 {
        liquidity_removed.liquidity_amount
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_liquidity_removed<X: key + store, Y>(
        token_pair: &TokenPair<X, Y>,
        liquidity_token_id: ID,
        x_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        liquidity_amount: u64,
    ): LiquidityRemoved {
        LiquidityRemoved {
            id: id(token_pair),
            version: version(token_pair),
            liquidity_token_id,
            x_id,
            provider,
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
            liquidity_amount,
        }
    }

    struct TokenPairDestroyed has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
    }

    public fun token_pair_destroyed_id(token_pair_destroyed: &TokenPairDestroyed): object::ID {
        token_pair_destroyed.id
    }

    public fun token_pair_destroyed_liquidity_token_id(token_pair_destroyed: &TokenPairDestroyed): ID {
        token_pair_destroyed.liquidity_token_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_token_pair_destroyed<X: key + store, Y>(
        token_pair: &TokenPair<X, Y>,
        liquidity_token_id: ID,
    ): TokenPairDestroyed {
        TokenPairDestroyed {
            id: id(token_pair),
            version: version(token_pair),
            liquidity_token_id,
        }
    }

    struct XSwappedForY has copy, drop {
        id: object::ID,
        version: u64,
        expected_y_amount_out: u64,
        sender: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        x_id: ID,
    }

    public fun x_swapped_for_y_id(x_swapped_for_y: &XSwappedForY): object::ID {
        x_swapped_for_y.id
    }

    public fun x_swapped_for_y_expected_y_amount_out(x_swapped_for_y: &XSwappedForY): u64 {
        x_swapped_for_y.expected_y_amount_out
    }

    public fun x_swapped_for_y_sender(x_swapped_for_y: &XSwappedForY): address {
        x_swapped_for_y.sender
    }

    public fun x_swapped_for_y_x_token_type(x_swapped_for_y: &XSwappedForY): String {
        x_swapped_for_y.x_token_type
    }

    public fun x_swapped_for_y_y_token_type(x_swapped_for_y: &XSwappedForY): String {
        x_swapped_for_y.y_token_type
    }

    public fun x_swapped_for_y_x_amount(x_swapped_for_y: &XSwappedForY): u64 {
        x_swapped_for_y.x_amount
    }

    public fun x_swapped_for_y_y_amount(x_swapped_for_y: &XSwappedForY): u64 {
        x_swapped_for_y.y_amount
    }

    public fun x_swapped_for_y_x_id(x_swapped_for_y: &XSwappedForY): ID {
        x_swapped_for_y.x_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_x_swapped_for_y<X: key + store, Y>(
        token_pair: &TokenPair<X, Y>,
        expected_y_amount_out: u64,
        sender: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        x_id: ID,
    ): XSwappedForY {
        XSwappedForY {
            id: id(token_pair),
            version: version(token_pair),
            expected_y_amount_out,
            sender,
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
            x_id,
        }
    }

    struct YSwappedForX has copy, drop {
        id: object::ID,
        version: u64,
        x_id: ID,
        sender: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
    }

    public fun y_swapped_for_x_id(y_swapped_for_x: &YSwappedForX): object::ID {
        y_swapped_for_x.id
    }

    public fun y_swapped_for_x_x_id(y_swapped_for_x: &YSwappedForX): ID {
        y_swapped_for_x.x_id
    }

    public fun y_swapped_for_x_sender(y_swapped_for_x: &YSwappedForX): address {
        y_swapped_for_x.sender
    }

    public fun y_swapped_for_x_x_token_type(y_swapped_for_x: &YSwappedForX): String {
        y_swapped_for_x.x_token_type
    }

    public fun y_swapped_for_x_y_token_type(y_swapped_for_x: &YSwappedForX): String {
        y_swapped_for_x.y_token_type
    }

    public fun y_swapped_for_x_x_amount(y_swapped_for_x: &YSwappedForX): u64 {
        y_swapped_for_x.x_amount
    }

    public fun y_swapped_for_x_y_amount(y_swapped_for_x: &YSwappedForX): u64 {
        y_swapped_for_x.y_amount
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_y_swapped_for_x<X: key + store, Y>(
        token_pair: &TokenPair<X, Y>,
        x_id: ID,
        sender: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
    ): YSwappedForX {
        YSwappedForX {
            id: id(token_pair),
            version: version(token_pair),
            x_id,
            sender,
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
        }
    }

    struct FeeRateUpdated has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        fee_numerator: u64,
        fee_denominator: u64,
    }

    public fun fee_rate_updated_id(fee_rate_updated: &FeeRateUpdated): object::ID {
        fee_rate_updated.id
    }

    public fun fee_rate_updated_liquidity_token_id(fee_rate_updated: &FeeRateUpdated): ID {
        fee_rate_updated.liquidity_token_id
    }

    public fun fee_rate_updated_fee_numerator(fee_rate_updated: &FeeRateUpdated): u64 {
        fee_rate_updated.fee_numerator
    }

    public fun fee_rate_updated_fee_denominator(fee_rate_updated: &FeeRateUpdated): u64 {
        fee_rate_updated.fee_denominator
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_fee_rate_updated<X: key + store, Y>(
        token_pair: &TokenPair<X, Y>,
        liquidity_token_id: ID,
        fee_numerator: u64,
        fee_denominator: u64,
    ): FeeRateUpdated {
        FeeRateUpdated {
            id: id(token_pair),
            version: version(token_pair),
            liquidity_token_id,
            fee_numerator,
            fee_denominator,
        }
    }


    public(friend) fun update_version_and_transfer_object<X: key + store, Y>(token_pair: TokenPair<X, Y>, recipient: address) {
        update_object_version(&mut token_pair);
        transfer::transfer(token_pair, recipient);
    }

    #[lint_allow(share_owned)]
    public fun share_object<X: key + store, Y>(token_pair: TokenPair<X, Y>) {
        transfer::share_object(token_pair);
    }

    public(friend) fun update_object_version<X: key + store, Y>(token_pair: &mut TokenPair<X, Y>) {
        token_pair.version = token_pair.version + 1;
        //assert!(token_pair.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_token_pair<X: key + store, Y>(token_pair: TokenPair<X, Y>) {
        let TokenPair {
            id,
            version: _version,
            schema_version: _,
            admin_cap: _,
            x_reserve,
            x_amounts,
            x_total_amount: _x_total_amount,
            y_reserve,
            total_liquidity: _total_liquidity,
            liquidity_token_id: _liquidity_token_id,
            fee_numerator: _fee_numerator,
            fee_denominator: _fee_denominator,
        } = token_pair;
        object::delete(id);
        sui::object_table::destroy_empty(x_reserve);
        sui::table::destroy_empty(x_amounts);
        sui::balance::destroy_zero(y_reserve);
    }

    public(friend) fun emit_liquidity_initialized(liquidity_initialized: LiquidityInitialized) {
        assert!(std::option::is_some(&liquidity_initialized.id), EEmptyObjectID);
        event::emit(liquidity_initialized);
    }

    public(friend) fun emit_liquidity_added(liquidity_added: LiquidityAdded) {
        event::emit(liquidity_added);
    }

    public(friend) fun emit_liquidity_removed(liquidity_removed: LiquidityRemoved) {
        event::emit(liquidity_removed);
    }

    public(friend) fun emit_token_pair_destroyed(token_pair_destroyed: TokenPairDestroyed) {
        event::emit(token_pair_destroyed);
    }

    public(friend) fun emit_x_swapped_for_y(x_swapped_for_y: XSwappedForY) {
        event::emit(x_swapped_for_y);
    }

    public(friend) fun emit_y_swapped_for_x(y_swapped_for_x: YSwappedForX) {
        event::emit(y_swapped_for_x);
    }

    public(friend) fun emit_fee_rate_updated(fee_rate_updated: FeeRateUpdated) {
        event::emit(fee_rate_updated);
    }

}
