import Vote from 0xNC

transaction(
    name: String,
    description: String,
    startTime: UFix64,
    endTime: UFix64
) {

    let Admin: &Vote.Admin

    prepare(signer: AuthAccount) {
        self.Admin = signer.borrow<&Vote.Admin>(from: Vote.AdminPath) ?? panic("only admin transaction~")
    }

    execute {
        self.Admin.createProposal(name: name, description: description, startTime: startTime, endTime: endTime)
    }
}
 