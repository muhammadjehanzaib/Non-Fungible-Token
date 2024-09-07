

deploy-anvil :
	forge script script/DeployBasicNFT.s.sol --rpc-url http://localhost:8545 --account smartkey --broadcast

fmt: 
	forge fmt