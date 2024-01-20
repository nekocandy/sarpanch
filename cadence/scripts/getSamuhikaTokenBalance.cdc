import FungibleToken from 0xFT
import SamuhikaToken from 0xNC

pub fun main(account: Address): UFix64? {
    let vaultRef = getAccount(account).getCapability(SamuhikaToken.VaultBalancePath)
                    .borrow<&SamuhikaToken.Vault{FungibleToken.Balance}>()

    return vaultRef?.balance
}