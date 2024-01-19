import FungibleToken from 0xNC
import SamuhikaToken from 0xNC

transaction() {
    prepare(signer: AuthAccount) {
        if signer.borrow<&SamuhikaToken.Vault>(from: SamuhikaToken.VaultStoragePath) == nil {
            signer.save(<-SamuhikaToken.createEmptyVault(), to: SamuhikaToken.VaultStoragePath)

            signer.link<&SamuhikaToken.Vault{FungibleToken.Receiver}>(SamuhikaToken.VaultReceiverPath, target: SamuhikaToken.VaultStoragePath)

            signer.link<&SamuhikaToken.Vault{FungibleToken.Balance}>(SamuhikaToken.VaultBalancePath, target: SamuhikaToken.VaultStoragePath)
        }
    }
}
 