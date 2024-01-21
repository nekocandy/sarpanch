import FlowToken from 0x7e60df042a9c0868

pub contract SarpanchScholarship {

    pub struct ScholarshipRequest {
        pub let name: String
        pub let description: String
        pub let address: Address
        pub var donations: [Donation]

        init(
            name: String,
            description: String,
            address: Address
        ) {
            self.name = name
            self.description = description
            self.address = address
            self.donations = []
        }

        pub fun addDonation( 
            sender: Address,
            sentTime: UFix64,
            amount: UFix64,
            transactionID: String
        ) {
            let donation = Donation(
                sender: sender,
                sentTime: sentTime,
                amount: amount,
                transactionID: transactionID
            )
            
            self.donations.append(donation)
        }
    }

    pub struct Donation {
        pub let sender: Address
        pub let sentTime: UFix64
        pub let amount: UFix64
        pub let transactionID: String

        init(
            sender: Address,
            sentTime: UFix64,
            amount: UFix64,
            transactionID: String
        ) {
            self.sender = sender
            self.sentTime = sentTime
            self.amount = amount
            self.transactionID = transactionID
        }
    }

    pub var scholarshipRequests: [ScholarshipRequest]


    pub event DonationMade(requestIndex: Int, name: String,sender: Address, amount: UFix64, transactionID: String)

    pub fun addFundingRequest(
        name: String,
        description: String,
        address: Address
    ) {
        let newRequest = ScholarshipRequest(
            name: name,
            description: description,
            address: address
        )

        self.scholarshipRequests.append(newRequest)
    }

    pub fun donate(
        requestIndex: Int,
        amount: UFix64,
        transactionID: String
    ) {
        pre {
            requestIndex >= 0 && requestIndex < self.scholarshipRequests.length: "Invalid request index"
        }

        let donationRequest = self.scholarshipRequests[requestIndex]
        let sender = self.account.address
        let sentTime = getCurrentBlock().timestamp

        donationRequest.addDonation(
            sender: sender,
            sentTime: sentTime,
            amount: amount,
            transactionID: transactionID
        )

        emit DonationMade(
            requestIndex: requestIndex,
            name: donationRequest.name,
            sender: sender,
            amount: amount,
            transactionID: transactionID
        )
    }

    pub fun getProjectDetails(requestIndex: Int): ScholarshipRequest? {
        if requestIndex >= 0 && requestIndex < self.scholarshipRequests.length {
            return self.scholarshipRequests[requestIndex]
        }
        return nil
    }

    init() {
        self.scholarshipRequests = []
    }
}