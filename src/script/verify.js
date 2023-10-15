const snarkjs = require('snarkjs')
const fs = require('fs')

async function verifyCommit() {
  const vk = JSON.parse(fs.readFileSync(`../../build/verification_key.json`))
  const public = JSON.parse(fs.readFileSync(`../../build/commit_public.json`))
  const proof = JSON.parse(fs.readFileSync(`../../build/commit_proof.json`))

  console.log("Verification start ...")
  const start = Date.now()

  const res = await snarkjs.plonk.verify(vk, public, proof)

  console.log(`Verification finished.`)
  const end = Date.now()
  
  console.log(`Verification result: ${res}`)
  console.log(`Verification time: ${end - start}ms`)
  return res
}

async function verify() {
  await verifyCommit()
  process.exit(0)
}

verify()
