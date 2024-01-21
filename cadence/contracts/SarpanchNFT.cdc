import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0x631e88ae7f1d7c20

pub contract SarpanchNFT: NonFungibleToken {

    pub var totalSupply: UInt64
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath

    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
        pub let id: UInt64

        pub let name: String
        pub let description: String
        pub let thumbnail: String

        init(
            name: String,
            description: String,
            thumbnail: String
        ) {
            self.id = self.uuid
            self.name = name
            self.description = description
            self.thumbnail = thumbnail

            SarpanchNFT.totalSupply = SarpanchNFT.totalSupply + 1
        }

        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    return MetadataViews.Display(
                        name: self.name,
                        description: self.description,
                        thumbnail: MetadataViews.HTTPFile(
                            url: self.thumbnail
                        )
                    )
            }
            return nil
        }
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("0xnc not found")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @SarpanchNFT.NFT

            let id: UInt64 = token.uuid

            self.ownedNFTs[id] <-! token

            emit Deposit(id: id, to: self.owner?.address)
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
            let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let SarpanchNFT = nft as! &SarpanchNFT.NFT
            return SarpanchNFT
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub fun mintNFT(
        recipient: &SarpanchNFT.Collection{NonFungibleToken.CollectionPublic},
        name: String,
        description: String,
        thumbnail: String
    ) {

        var newNFT <- create NFT(
            name: name,
            description: description,
            thumbnail: thumbnail
        )

        recipient.deposit(token: <-newNFT)
    }

    init() {
        self.totalSupply = 0

        self.CollectionStoragePath = /storage/SarpanchNFTCollection
        self.CollectionPublicPath = /public/SarpanchNFTCollection

        emit ContractInitialized()
    }
}