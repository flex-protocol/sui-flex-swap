module example_tokens::equipment {

    use sui::object;
    use sui::object::UID;
    use sui::transfer::public_transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;

    const EWrongEquipmentType: u64 = 1;

    struct Equipment has key, store {
        id: UID,
        type: u8,
        amount: u64,
    }

    public fun brick(): u8 {
        1
    }

    public fun shield(): u8 {
        2
    }

    public fun sword(): u8 {
        3
    }

    public fun amount(equipment: &Equipment): u64 {
        equipment.amount
    }

    public entry fun mint(type: u8, ctx: &mut TxContext) {
        assert!(type == 1 || type == 2 || type == 3, EWrongEquipmentType);
        let amount = if (type == 1) { 1 } else {
            if (type == 2) { 3 } else { 5 }
        };
        let e = Equipment {
            id: object::new(ctx),
            type,
            amount,
        };
        public_transfer(e, tx_context::sender(ctx));
    }
}
