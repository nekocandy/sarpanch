import FungibleToken from 0x9a0766d93b6608b7 // 0x9a0766d93b6608b7

pub contract SamuhikaToken: FungibleToken {
    pub var totalSupply: UFix64

    pub let VaultStoragePath: StoragePath
    pub let VaultReceiverPath: PublicPath
    pub let VaultBalancePath: PublicPath
    pub let MinterStoragePath: StoragePath

    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)

    pub event TokensMinted(amount: UFix64)
    pub event TokensBurned(amount: UFix64)
    pub event MinterCreated(allowedAmount: UFix64)
    pub event BurnerCreated()

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {
        pub var balance: UFix64

        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <-create Vault(balance: amount)
        }

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @SamuhikaToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            vault.balance = 0.0
            destroy vault
        }

        init(balance: UFix64) {
            self.balance = balance
        }

        destroy() {
            SamuhikaToken.totalSupply = SamuhikaToken.totalSupply - self.balance
        }
    }

    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    pub resource Minter {
        pub fun mintTokens(amount: UFix64): @SamuhikaToken.Vault {
            pre {
                amount > 0.0: "Amount minted must be greater than zero"
            }
            SamuhikaToken.totalSupply = SamuhikaToken.totalSupply + amount
            emit TokensMinted(amount: amount)
            return <- create Vault(balance: amount)
        }

        init() {}
    }

    init() {
        self.totalSupply = 0.0
        self.VaultStoragePath = /storage/SamuhikaTokenVault
        self.VaultReceiverPath = /public/SamuhikaTokenReceiver
        self.VaultBalancePath = /public/SamuhikaTokenBalance
        self.MinterStoragePath = /storage/SamuhikaTokenMinter

        let minter <- create Minter()
        self.account.save(<- minter, to: self.MinterStoragePath)

        emit TokensInitialized(initialSupply: self.totalSupply)
    }
}