#[starknet::contract]
mod counter_contract {
    use core::starknet::event::EventEmitter;
#[storage]
    struct Storage {
        counter: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased{
        #[key]
        counter: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initialCounter: u32) {
        self.counter.write(initialCounter);
    }

    #[abi(embed_v0)]
    impl counter_contract of super::ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            return self.counter.read();
        }

        fn increase_counter(ref self: ContractState) {
            let currentValue = self.counter.read();
            self.counter.write(currentValue + 1);
            self.emit(CounterIncreased {counter: currentValue });
        }
    }


}

#[starknet::interface]
trait ICounter<TContractState> {
    // fn getCounter(ref self: TContractState, x: u128);
    fn get_counter(self: @TContractState) -> u32;

    fn increase_counter(ref self: TContractState);
}
