import SarpanchVoting from 0xNC

transaction(
    name: String,
    description: String,
    startTime: UFix64,
    endTime: UFix64
) {

    let Admin: &SarpanchVoting.Admin

    prepare(signer: AuthAccount) {
        self.Admin = signer.borrow<&SarpanchVoting.Admin>(from: SarpanchVoting.AdminPath) ?? panic("only admin transaction~")
    }

    execute {
        self.Admin.createProposal(name: name, description: description, startTime: startTime, endTime: endTime)
    }
}
 