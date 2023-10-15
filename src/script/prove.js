const snarkjs = require("snarkjs");
const keccak = require("keccak256");
const fs = require("fs");

async function proveImpl() {
  console.log("\nProving start ... ");
  const start = Date.now()

  const { proof, publicSignals } = await snarkjs.plonk.fullProve({
    tx: 19198101116342567435743678356487,
    c: 1919810
  }, '../../build/main_js/main.wasm', '../../build/circuit_final.zkey');
  console.log("Proof generated.");
  const end = Date.now()

  console.log(`Proving time: ${end - start}ms`);

  fs.writeFileSync('../../build/commit_proof.json', JSON.stringify(proof, null, 2))
  fs.writeFileSync('../../build/commit_public.json', JSON.stringify(publicSignals, null, 2))
}

async function prove() {
  await proveImpl();
  process.exit(0);
}

prove();
