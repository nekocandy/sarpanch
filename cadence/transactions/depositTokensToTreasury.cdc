import SarpanchCommunityTreasury from 0xNC
import FlowToken from 0xDFT

transaction(
  treasuryAddress: Address,
  amount: UFix64,
  description: String
) {

    let Treasury: &SarpanchCommunityTreasury.Treasury{SarpanchCommunityTreasury.TreasuryPublic}
    let FlowVault: @FlowToken.Vault
    let Donor: Address

    prepare(signer: AuthAccount) {
       if signer.borrow<&SarpanchCommunityTreasury.Treasury>(from: SarpanchCommunityTreasury.TreasuryStoragePath) == nil {
            signer.save(<- SarpanchCommunityTreasury.createTreasury(admins: [signer.address]), to: SarpanchCommunityTreasury.TreasuryStoragePath)
            signer.link<&SarpanchCommunityTreasury.Treasury{SarpanchCommunityTreasury.TreasuryPublic}>(SarpanchCommunityTreasury.TreasuryPublicPath, target: SarpanchCommunityTreasury.TreasuryStoragePath)
       }

      self.Treasury = getAccount(treasuryAddress).getCapability(SarpanchCommunityTreasury.TreasuryPublicPath)
                      .borrow<&SarpanchCommunityTreasury.Treasury{SarpanchCommunityTreasury.TreasuryPublic}>()
                      ?? panic("no treasury here~")

      let flowVaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!
      self.FlowVault <- flowVaultRef.withdraw(amount: amount) as! @FlowToken.Vault
      
      self.Donor = signer.address
    }

    execute {
      self.Treasury.deposit(
        flowVault: <- self.FlowVault,
        description: description,
        donor: self.Donor
      )
    }
}
