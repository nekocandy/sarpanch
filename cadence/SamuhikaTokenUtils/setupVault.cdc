import FungibleToken from "../utils/FungibleToken.cdc"
import SamuhikaToken from "../SamuhikaToken.cdc"

transaction() {
    prepare(signer: AuthAccount) {
        if signer.borrow<&SamuhikaToken.Vault>(from: SamuhikaToken.VaultStoragePath) == nil {
            signer.save(<-SamuhikaToken.createEmptyVault(), to: SamuhikaToken.VaultStoragePath)

            signer.link<&SamuhikaToken.Vault{FungibleToken.Receiver}>(SamuhikaToken.VaultReceiverPath, target: SamuhikaToken.VaultStoragePath)

            signer.link<&SamuhikaToken.Vault{FungibleToken.Balance}>(SamuhikaToken.VaultBalancePath, target: SamuhikaToken.VaultStoragePath)
        }
    }
}
 