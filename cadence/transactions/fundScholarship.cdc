import SarpanchScholarship from 0xNC

transaction(requestIndex: Int, amount: UFix64, transactionID: String) {

    prepare(signer: AuthAccount) {
    }

    execute {
        SarpanchScholarship.donate(
            requestIndex: requestIndex,
            amount: amount,
            transactionID: transactionID,
        )
    }
}
