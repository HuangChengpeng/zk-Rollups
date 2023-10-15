# Rollup

An on-chain verification for rollup SNARKs and KZG commitments.

## Circuits

The arithmetic circuits for the SNARKs are in `src/circuits`. Running:

```sh
npm run build
```

to compile the circuits and generate a on-chain verifier contract under `src/contract/snark/` directory. The circuit description will be stored in the `build/main.r1cs` file, along with a folder named `main_js` for witness computation.

Credits to [`circomlib`](https://github.com/iden3/circomlib) library for the Poseidon hash implementation.

## KZG Commitment

The verifier for KZG commitment is packed in a solidity contract in `src/contract/commitment`, which could be deployed to Ethereum blockchain via Remix or web3.js.

Credits to [`libkzg`](https://github.com/weijiekoh/libkzg) for solidity verification of KZG commitments.
