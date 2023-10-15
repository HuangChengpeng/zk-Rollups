const snarkjs = require("snarkjs");
const keccak = require("keccak256");
const fs = require("fs");

async function proveImpl() {
  const file = fs.readFileSync("../data/table70.csv", "utf8");
  const start = Date.now()

  keccak(file);
 
  const end = Date.now()
  console.log(`Proving time: ${end - start}ms`);
}

async function prove() {
  await proveImpl();
  process.exit(0);
}

prove();
