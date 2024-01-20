export interface TreasuryData {
  admins: string[]
  balance: string
  pendingProposals: PendingProposals
  completedProposals: CompletedProposals
  deposits: Deposits
  orderedActions: OrderedAction[]
}

export interface PendingProposals {}

export interface CompletedProposals {}

export interface Deposits {
  '0': N0
}

export interface N0 {
  id: string
  type: string
  amount: string
  description: string
  proposedBy: string
}

export interface OrderedAction {
  id: string
  type: string
  amount: string
  description: string
  proposedBy: string
}

export interface Product {
  id: number
  title: string
  price: number
  description: string
  category: string
  image: string
  rating: Rating
}

export interface Rating {
  rate: number
  count: number
}
