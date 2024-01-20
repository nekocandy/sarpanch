import SarpanchNFT from 0xNC
import NonFungibleToken from 0xNC
import MetadataViews from 0xNC

transaction() {
  
  prepare(signer: AuthAccount) {
    if signer.borrow<&SarpanchNFT.Collection>(from: SarpanchNFT.CollectionStoragePath) == nil {
      signer.save(<- SarpanchNFT.createEmptyCollection(), to: SarpanchNFT.CollectionStoragePath)
      signer.link<&SarpanchNFT.Collection{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(SarpanchNFT.CollectionPublicPath, target: SarpanchNFT.CollectionStoragePath)
    }
  }

  execute {
    log("Coxllnecction initialized")
  }
}
 