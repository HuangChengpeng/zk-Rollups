const keccak = require("keccak256")
const fs = require("fs")
const { Transaction, Batch } = require("./batch")

let transactionPool = [
  new Transaction(100, 'Alice', 'Bob'),
  new Transaction(50, 'Bob', 'Charlie'),
  new Transaction(50, 'Alice', 'Charlie'),
  new Transaction(50, 'Charlie', 'Alice'),
  new Transaction(50, 'Charlie', 'Bob'),
  new Transaction(50, 'Bob', 'Alice'),
  new Transaction(50, 'Alice', 'Charlie'),
  new Transaction(50, 'Charlie', 'Bob'),
  new Transaction(50, 'Bob', 'Alice'),
  new Transaction(50, 'Alice', 'Charlie'),
  new Transaction(50, 'Charlie', 'Bob'),
]

const selectTransactions = (transactionPool, number) => {
  const selectedTransactions = []
  const indexes = []
  for (let i = 0; i < number; i++) {
    let index = Math.floor(Math.random() * transactionPool.length)
    while (indexes.includes(index)) {
      index = Math.floor(Math.random() * transactionPool.length)
    }
    indexes.push(index)
    selectedTransactions.push(transactionPool[index])
  }
  return selectedTransactions
}

const createBatch = (transactionPool, number) => {
  const selectedTransactions = selectTransactions(transactionPool, number)
  const hiddenState = keccak(selectedTransactions.map(transaction => transaction.value).join(''))
  return new Batch(selectedTransactions, hiddenState)
}

const batch = createBatch(transactionPool, 5)
fs.writeFileSync('../../data/transactions/batch.json', JSON.stringify(batch, null, 2))
console.log(batch)
