import FlowToken from 0x0ae53cb6e3f42a79

pub contract CommunityProjectCollection {

    pub struct Project {
        pub let name: String
        pub let description: String
        pub let image: String
        pub var donations: [Donation]

        init(
            name: String,
            description: String,
            image: String,
        ) {
            self.name = name
            self.description = description
            self.image = image
            self.donations = []
        }

        pub fun addDonation(donation: Donation) {
            self.donations.append(donation)
        }
    }

    pub struct Donation {
        pub let sender: Address
        pub let sentTime: UFix64
        pub let amount: UFix64
        pub let transactionID: UInt64

        init(
            sender: Address,
            sentTime: UFix64,
            amount: UFix64,
            transactionID: UInt64
        ) {
            self.sender = sender
            self.sentTime = sentTime
            self.amount = amount
            self.transactionID = transactionID
        }
    }

    pub var projects: [Project]

    pub event ProjectCreated(name: String)

    pub event DonationMade(projectIndex: Int, sender: Address, amount: UFix64, transactionID: UInt64)

    pub fun createProject(
        name: String,
        description: String,
        image: String,
    ) {
        let newProject = Project(
            name: name,
            description: description,
            image: image,
        )

        self.projects.append(newProject)
        emit ProjectCreated(name: name)
    }

    pub fun donateToProject(
        projectIndex: Int,
        amount: UFix64,
        transactionID: UInt64
    ) {
        pre {
            projectIndex >= 0 && projectIndex < self.projects.length: "Invalid project index"
        }

        let project = self.projects[projectIndex]
        let sender = self.account.address
        let sentTime = getCurrentBlock().timestamp

        // Add donation to the project's donations array
        project.addDonation(donation: Donation(
            sender: sender,
            sentTime: sentTime,
            amount: amount,
            transactionID: transactionID
        ))

        emit DonationMade(
            projectIndex: projectIndex,
            sender: sender,
            amount: amount,
            transactionID: transactionID
        )
    }

    pub fun getProjectDetails(projectIndex: Int): Project? {
        if projectIndex >= 0 && projectIndex < self.projects.length {
            return self.projects[projectIndex]
        }
        return nil
    }

    init() {
        self.projects = []
    }
}