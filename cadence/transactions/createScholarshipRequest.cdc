import SarpanchScholarship from 0xNC

transaction(name: String, description: String, address: Address) {

    prepare(signer: AuthAccount) {
    }

    execute {
        SarpanchScholarship.addFundingRequest(
            name: name,
            description: description,
            address: address
        )
    }
}
