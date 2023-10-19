module sui_swap_example::exchange_add_token_pair_logic {
    use sui::object::ID;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::exchange;
    use sui_swap_example::token_pair_added_to_exchange;

    friend sui_swap_example::exchange_aggregate;

    public(friend) fun verify(
        token_pair_id: ID,
        exchange: &exchange::Exchange,
        ctx: &TxContext,
    ): exchange::TokenPairAddedToExchange {
        exchange::new_token_pair_added_to_exchange(
            exchange,
            token_pair_id,
        )
    }

    public(friend) fun mutate(
        token_pair_added_to_exchange: &exchange::TokenPairAddedToExchange,
        exchange: &mut exchange::Exchange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let token_pair_id = token_pair_added_to_exchange::token_pair_id(token_pair_added_to_exchange);
        // todo ...
        //
    }

}
