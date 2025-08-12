#[starknet::contract]
mod Tubbly {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::Map;
    use core::num::traits::Zero;

    // ===== Storage =====
    #[storage]
    struct Storage {
        owner: ContractAddress,
        balances: Map<ContractAddress, u256>,
        requests: Map<u128, Request>,
    }

    // ===== Structs =====
    #[derive(Drop, Serde, starknet::Store)]
    struct Request {
        caller: ContractAddress,
        balance: u256,
    }

    // ===== Constructor =====
    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
    }

    // ===== External Functions =====

    #[external(v0)]
    fn submit(ref self: ContractState, req_id: u128, balance: u256) -> u128 {
        let existing_request = self.requests.read(req_id);
        assert(existing_request.caller.is_zero(), 'Request ID already used');

        let new_request = Request {
            caller: get_caller_address(),
            balance: balance,
        };
        self.requests.write(req_id, new_request);

        req_id
    }

    #[external(v0)]
    fn confirm(ref self: ContractState, req_id: u128) -> u256 {
        // Check if owner
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Not owner');

        let request = self.requests.read(req_id);
        assert(!request.caller.is_zero(), 'Invalid request ID');

        let current_balance = self.balances.read(request.caller);
        let new_balance = current_balance + request.balance;
        
        self.balances.write(request.caller, new_balance);

        // Clear request
        self.requests.write(req_id, Request {
            caller: Zero::zero(),
            balance: 0,
        });

        request.balance
    }

    #[external(v0)]
    fn balanceOf(self: @ContractState, addr: ContractAddress) -> u256 {
        self.balances.read(addr)
    }

    #[external(v0)]
    fn getRequest(self: @ContractState, req_id: u128) -> Request {
        // Check if owner
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Not owner');
        
        self.requests.read(req_id)
    }

    #[external(v0)]
    fn changeOwnership(ref self: ContractState, new_owner: ContractAddress) {
        // Check if owner
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Not owner');
        assert(!new_owner.is_zero(), 'New owner is zero');

        self.owner.write(new_owner);
    }

    #[external(v0)]
    fn owner(self: @ContractState) -> ContractAddress {
        self.owner.read()
    }
}