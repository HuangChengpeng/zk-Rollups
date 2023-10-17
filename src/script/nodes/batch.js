class Transaction {
  constructor (value, from, to) {
    this.value = value
    this.from = from
    this.to = to
  }
}

class Batch {
  constructor (transactions, hiddenState) {
    this.transactions = transactions
    this.hiddenState = hiddenState
  }

  verify () {
    // verify the batch
    return true
  }
}

module.exports = {
  Transaction,
  Batch
}
