const fs = require("fs")
const { Transaction, Batch } = require("./batch")

const compactBatch = () => {
  // load batch from file
  const batch = JSON.parse(fs.readFileSync('../../data/transactions/batch.json'))
  
  // compact the transactions
  const compactedTransactions = batch.transactions.map(transaction => {
    return {
      value: transaction.value,
      from: transaction.from,
      to: transaction.to
    }
  })
  return new Batch(compactedTransactions, batch.hiddenState)
}

const verifyBatch = (batch) => {
  // verify the batch
  const verified = batch.verify()
  console.log(`Batch verified: ${verified}`)
}
