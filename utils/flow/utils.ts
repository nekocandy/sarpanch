import * as fcl from '@onflow/fcl'

export async function sendFlow(toAddress: string, amount: string) {
  const transaction = await fcl.mutate({
    cadence: `
        import FungibleToken from 0xFT
        import FlowToken from 0xDFT
    
        transaction(recipient: Address, amount: UFix64){
          prepare(signer: AuthAccount){
            let sender = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
              ?? panic("Could not borrow Provider reference to the Vault")
    
            let receiverAccount = getAccount(recipient)
    
            let receiver = receiverAccount.getCapability(/public/flowTokenReceiver)
              .borrow<&FlowToken.Vault{FungibleToken.Receiver}>()
              ?? panic("Could not borrow Receiver reference to the Vault")
    
                    let tempVault <- sender.withdraw(amount: amount)
            receiver.deposit(from: <- tempVault)
          }
        }
            `,
    limit: 9999,
    // @ts-expect-error not sure how to type this
    args: (arg, t) => [
      arg(toAddress, t.Address),
      arg(Number.parseFloat(amount).toFixed(2), t.UFix64),
    ],
    // @ts-expect-error not sure how to type this
    payer: fcl.authz,
    // @ts-expect-error not sure how to type this
    proposer: fcl.authz,
    // @ts-expect-error not sure how to type this
    authorizations: [fcl.authz],
  })

  return transaction
}
