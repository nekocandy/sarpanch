import CommunityProjectCollection from 0xNC

transaction(projectIndex: Int, amount: UFix64, transactionID: String) {

    prepare(signer: AuthAccount) {
    }

    execute {
        CommunityProjectCollection.donateToProject(
            projectIndex: projectIndex,
            amount: amount,
            transactionID: transactionID,
        )
    }
}
