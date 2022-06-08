## Dynamic NFT
This is a Dynamic NFT Project Which Upgrades When You call Upgrade Function or damage Function

It is completey On Chain Along with Metadata

It is Deployed to Polygon chain to save some money on gas fees

### Deploy 
1:Clone the Repo
2:Create a file name ".env"
3:ADD The Following Code:
TESTNET_RPC="VALUE" //Get Polygon Testnet RPC from alchemy or anyother node provider 
PRIVATE_KEY="VALUE" //You metamask account private Key
POLYGONSCAN_API_KEY="VALUE" //Create an account and polygon scan create an app over there and copy the api key and paste it here

4:Compile the Project Using "npx hardhat compile"
5:deploy to polygon testnet using "npx hardhat run scripts/deploy.js --network mumbai"
6:Verify your Contract Using "npx hardhat verify --network mumbai 'CONTRACT ADDRESS'"