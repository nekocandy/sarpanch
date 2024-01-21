import FlowToken from 0x7e60df042a9c0868
import FungibleToken from 0x9a0766d93b6608b7

pub contract SarpanchCommunityTreasury {
  pub var totalActions: UInt64
  pub let TreasuryStoragePath: StoragePath
  pub let TreasuryPublicPath: PublicPath

  pub struct interface Action {
    pub let id: UInt64
    pub let type: String
    pub let amount: UFix64
    pub let description: String
    pub let proposedBy: Address
  }

  pub struct PendingProposal: Action {
    pub let id: UInt64
    pub let type: String
    pub let amount: UFix64
    pub let description: String
    pub let timeProposed: UFix64
    pub let proposedBy: Address
    pub let transferTo: Address
    pub let signers: [Address]

    access(contract) fun sign(by: Address) {
      pre {
        !self.signers.contains(by): "proposal already signed by this address"
      }
      self.signers.append(by)
    }

    init(id: UInt64, amount: UFix64, description: String, proposedBy: Address, transferTo: Address) {
      self.id = id
      self.type = "Pending"
      self.amount = amount
      self.description = description
      self.timeProposed = getCurrentBlock().timestamp
      self.proposedBy = proposedBy
      self.transferTo = transferTo
      self.signers = []
    }
  }

  pub struct CompletedProposal: Action {
    pub let id: UInt64
    pub let type: String
    pub let amount: UFix64
    pub let description: String
    pub let timeProposed: UFix64
    pub let proposedBy: Address
    pub let transferTo: Address
    pub let signers: [Address]

    pub let timeAccepted: UFix64

    init(id: UInt64, amount: UFix64, description: String, timeProposed: UFix64, proposedBy: Address, transferTo: Address, signers: [Address], timeAccepted: UFix64) {
      self.id = id
      self.type = "Completed"
      self.amount = amount
      self.description = description
      self.timeProposed = timeProposed
      self.proposedBy = proposedBy
      self.transferTo = transferTo
      self.signers = signers

      self.timeAccepted = timeAccepted
    }
  }

  pub struct Deposit: Action {
    pub let id: UInt64
    pub let type: String
    pub let amount: UFix64
    pub let description: String
    pub let proposedBy: Address

    init(id: UInt64, amount: UFix64, description: String, donor: Address) {
      self.id = id
      self.type = "Deposit"
      self.amount = amount
      self.description = description
      self.proposedBy = donor
    }
  }

  pub resource interface TreasuryPublic {
    pub let admins: [Address]
    pub let pendingProposals: {UInt64: PendingProposal}
    pub let completedProposals: {UInt64: CompletedProposal}
    pub let deposits: {UInt64: Deposit}
    pub let orderedActions: [{Action}]
    access(contract) fun createProposal(amount: UFix64, description: String, proposedBy: Address, transferTo: Address)
    access(contract) fun completeAction(proposalId: UInt64)
    pub fun deposit(flowVault: @FlowToken.Vault, description: String, donor: Address)
    access(contract) fun getPendingProposalRef(proposalId: UInt64): &PendingProposal?
    pub fun getTreasuryBalance(): UFix64
  }

  pub resource Treasury: TreasuryPublic {
    pub let admins: [Address]
    pub let flowVault: @FlowToken.Vault
    pub let pendingProposals: {UInt64: PendingProposal}
    pub let completedProposals: {UInt64: CompletedProposal}
    pub let deposits: {UInt64: Deposit}
    pub let orderedActions: [{Action}]

    pub fun proposeProposal(
      treasuryAddress: Address, 
      amount: UFix64, 
      description: String,
      transferTo: Address
    ) {
      let treasuryPublic = getAccount(treasuryAddress).getCapability(SarpanchCommunityTreasury.TreasuryPublicPath)
                          .borrow<&Treasury{TreasuryPublic}>() ?? panic("no treasury exists at the given address")
      treasuryPublic.createProposal(amount: amount, description: description, proposedBy: self.owner!.address, transferTo: transferTo)
    }

    access(contract) fun createProposal(amount: UFix64, description: String, proposedBy: Address, transferTo: Address) {
      let proposal = PendingProposal(
        id: SarpanchCommunityTreasury.totalActions,
        amount: amount, 
        description: description, 
        proposedBy: proposedBy,
        transferTo: transferTo
      )

      self.pendingProposals[SarpanchCommunityTreasury.totalActions] = proposal
      self.orderedActions.append(proposal)

      SarpanchCommunityTreasury.totalActions = SarpanchCommunityTreasury.totalActions + 1
    }

    pub fun deposit(flowVault: @FlowToken.Vault, description: String, donor: Address) {
      let deposit = Deposit(
        id: SarpanchCommunityTreasury.totalActions, 
        amount: flowVault.balance,
        description: description,
        donor: donor
      )
      
      self.deposits[SarpanchCommunityTreasury.totalActions] = deposit
      self.orderedActions.append(deposit)

      self.flowVault.deposit(from: <- flowVault)
      SarpanchCommunityTreasury.totalActions = SarpanchCommunityTreasury.totalActions + 1
    }

    pub fun signProposal(treasuryAddress: Address, proposalId: UInt64) {
      let treasuryPublic = getAccount(treasuryAddress).getCapability(SarpanchCommunityTreasury.TreasuryPublicPath)
                          .borrow<&Treasury{TreasuryPublic}>() ?? panic("no treasury exists at the given address")

      assert(treasuryPublic.admins.contains(self.owner!.address), message: "not an admin of this treasury")

      let pendingProposalRef = treasuryPublic.getPendingProposalRef(proposalId: proposalId) 
                        ?? panic("proposal does not exist")
      pendingProposalRef.sign(by: self.owner!.address)

      if pendingProposalRef.signers.length == treasuryPublic.admins.length {
        // Complete the action
        treasuryPublic.completeAction(proposalId: proposalId)
      }
    }

    access(contract) fun completeAction(proposalId: UInt64) {
      let proposal = self.pendingProposals.remove(key: proposalId)!
      let completedProposal = CompletedProposal(
        id: proposal.id, 
        amount: proposal.amount, 
        description: proposal.description, 
        timeProposed: proposal.timeProposed, 
        proposedBy: proposal.proposedBy, 
        transferTo: proposal.transferTo,
        signers: proposal.signers,
        timeAccepted: getCurrentBlock().timestamp
      )
      self.completedProposals[proposal.id] = completedProposal
      self.orderedActions.append(completedProposal)

      let receiverFlowVault = getAccount(proposal.transferTo).getCapability(/public/flowTokenReceiver)
                        .borrow<&FlowToken.Vault{FungibleToken.Receiver}>()!
      receiverFlowVault.deposit(from: <- self.flowVault.withdraw(amount: proposal.amount))
    }

    pub fun addSigner(admin: Address) {
      pre {
        !self.admins.contains(admin): "already an admin"
      }
      self.admins.append(admin)
    }

    access(contract) fun getPendingProposalRef(proposalId: UInt64): &PendingProposal? {
      return &self.pendingProposals[proposalId] as &PendingProposal?
    }

    pub fun getTreasuryBalance(): UFix64 {
      return self.flowVault.balance
    }

    init(admins: [Address]) {
      self.admins = admins
      self.flowVault <- FlowToken.createEmptyVault() as! @FlowToken.Vault
      self.pendingProposals = {}
      self.completedProposals = {}
      self.deposits = {}
      self.orderedActions = []
    }

    destroy() {
      pre {
        self.flowVault.balance == 0.0: "can't destroy with nc funds in it."
      }

      destroy self.flowVault
    }
  }

  pub fun createTreasury(admins: [Address]): @Treasury {
    return <- create Treasury(admins: admins)
  }

  init() {
    self.totalActions = 0
    self.TreasuryStoragePath = /storage/SarpanchCommunityTreasury
    self.TreasuryPublicPath = /public/SarpanchCommunityTreasury

    self.account.save(<- SarpanchCommunityTreasury.createTreasury(admins: [self.account.address]), to: SarpanchCommunityTreasury.TreasuryStoragePath)
    self.account.link<&SarpanchCommunityTreasury.Treasury{SarpanchCommunityTreasury.TreasuryPublic}>(SarpanchCommunityTreasury.TreasuryPublicPath, target: SarpanchCommunityTreasury.TreasuryStoragePath)
  }

}
