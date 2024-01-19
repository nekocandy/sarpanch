import FungibleToken from "../utils/FungibleToken.cdc"
import SamuhikaToken from "../SamuhikaToken.cdc"

transaction(recipient: Address, amount: UFix64) {
    let Minter: &SamuhikaToken.Minter

    let TokenReceiver: &SamuhikaToken.Vault{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.Minter = signer.borrow<&SamuhikaToken.Minter>(from: SamuhikaToken.MinterStoragePath)
            ?? panic("signature possibly from wrong account")

        self.TokenReceiver = getAccount(recipient).getCapability(SamuhikaToken.VaultReceiverPath)
                              .borrow<&SamuhikaToken.Vault{FungibleToken.Receiver}>()
                              ?? panic("borrow reciever reference error")
    }

    execute {
        let mintedVault <- self.Minter.mintTokens(amount: amount)
        self.TokenReceiver.deposit(from: <-mintedVault)
    }
}