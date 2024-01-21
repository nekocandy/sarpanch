import CommunityProjectCollection from 0xNC

transaction(name: String, description: String, image: String) {

    prepare(signer: AuthAccount) {
    }

    execute {
        CommunityProjectCollection.createProject(
            name: name,
            description: description,
            image: image,
        )
    }
}
