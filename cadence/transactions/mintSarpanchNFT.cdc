import SarpanchNFT from 0xNC
import NonFungibleToken from 0xNCT

transaction(name: String, description: String, thumbnail: String, recipient: Address) {
  let RecipientCollection: &SarpanchNFT.Collection{NonFungibleToken.CollectionPublic}
  
  prepare(signer: AuthAccount) {
    self.RecipientCollection = getAccount(recipient)
                                .getCapability(SarpanchNFT.CollectionPublicPath)
                                .borrow<&SarpanchNFT.Collection{NonFungibleToken.CollectionPublic}>()
                                ?? panic("no collection added to account yet~")
  }

  execute {
    SarpanchNFT.mintNFT(
      recipient: self.RecipientCollection,
      name: name,
      description: description,
      thumbnail: thumbnail
    )
  }
}
