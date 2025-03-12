/*
/// Module: merkle_store
module merkle_store::merkle_store;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module merkle_store::merkle_store {
    use std::string::{String};
    use sui::event;

    // Struct to represent a Merkle Root submission
    public struct Submission has key, store {
        id: UID,
        merkle_root: String,
        datafile_url: String,
        batch_metadata: String,
        submitted_on: u64,
        updated_on: u64,
    }

    // Struct to represent the MerkleStore contract
    public struct MerkleStore has key {
        id: UID,
        root_nonce: u64,
        owner: address,
        merkle_roots: vector<Submission>,
    }

    // Event for new root submission
    public struct NewRootSubmission has copy, drop {
        idx: u64,
    }

    // Event for root modification
    public struct RootModification has copy, drop {
        idx: u64,
    }

    // Initialize the MerkleStore contract
    fun init(ctx: &mut TxContext) {
        let merkle_store = MerkleStore {
            id: object::new(ctx),
            root_nonce: 0,
            owner: tx_context::sender(ctx),
            merkle_roots: vector::empty(),
        };
        transfer::transfer(merkle_store, tx_context::sender(ctx));
    }

    // Function to submit a new Merkle Root with metadata
    public entry fun submit_new_merkle_root_with_metadata(
        merkle_store: &mut MerkleStore,
        merkle_root: String,
        datafile_url: String,
        batch_metadata: String,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == merkle_store.owner, 0);
        let idx = merkle_store.root_nonce;
        merkle_store.root_nonce = idx + 1;
        let submission = Submission {
            id: object::new(ctx),
            merkle_root,
            datafile_url,
            batch_metadata,
            submitted_on: tx_context::epoch(ctx),
            updated_on: tx_context::epoch(ctx),
        };
        vector::push_back(&mut merkle_store.merkle_roots, submission);
        event::emit(NewRootSubmission { idx });
    }

    // Function to update metadata on an existing Merkle Root
    public entry fun update_metadata_on_merkle_root_hash(
        merkle_store: &mut MerkleStore,
        idx: u64,
        new_metadata: String,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == merkle_store.owner, 0);
        assert!(idx < vector::length(&merkle_store.merkle_roots), 1);
        let submission = vector::borrow_mut(&mut merkle_store.merkle_roots, idx);
        submission.batch_metadata = new_metadata;
        submission.updated_on = tx_context::epoch(ctx);
        event::emit(RootModification { idx });
    }

    // Function to get a Merkle Root by index
    public fun get_merkle_root_on_hash(merkle_store: &MerkleStore, idx: u64): &Submission {
        assert!(idx < vector::length(&merkle_store.merkle_roots), 1);
        vector::borrow(&merkle_store.merkle_roots, idx)
    }

    // Function to get the number of Merkle Roots
    public fun get_number_of_merkle_roots(merkle_store: &MerkleStore): u64 {
        merkle_store.root_nonce
    }

    // Function to get the owner of the contract
    public fun owner(merkle_store: &MerkleStore): address {
        merkle_store.owner
    }
}