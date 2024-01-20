import SarpanchCommunityTreasury from 0xNC

pub fun main(treasuryAddress: Address): Info {
    let treasury = getAccount(treasuryAddress).getCapability(SarpanchCommunityTreasury.TreasuryPublicPath)
                      .borrow<&SarpanchCommunityTreasury.Treasury{SarpanchCommunityTreasury.TreasuryPublic}>()
                      ?? panic("There does not exist a treasury here.")

    return Info(treasury.admins, treasury.getTreasuryBalance(), treasury.pendingProposals, treasury.completedProposals, treasury.deposits, treasury.orderedActions)
}

pub struct Info {
  pub let admins: [Address]
  pub let balance: UFix64
  pub let pendingProposals: {UInt64: SarpanchCommunityTreasury.PendingProposal}
  pub let completedProposals: {UInt64: SarpanchCommunityTreasury.CompletedProposal}
  pub let deposits: {UInt64: SarpanchCommunityTreasury.Deposit}
  pub let orderedActions: [{SarpanchCommunityTreasury.Action}]

  init(
    _ admins: [Address],
    _ balance: UFix64,
    _ pendingProposals: {UInt64: SarpanchCommunityTreasury.PendingProposal},
    _ completedProposals: {UInt64: SarpanchCommunityTreasury.CompletedProposal},
    _ deposits: {UInt64: SarpanchCommunityTreasury.Deposit},
    _ orderedActions: [{SarpanchCommunityTreasury.Action}]
  ) {
    self.admins = admins
    self.balance = balance
    self.pendingProposals = pendingProposals
    self.completedProposals = completedProposals
    self.deposits = deposits
    self.orderedActions = orderedActions
  }
}