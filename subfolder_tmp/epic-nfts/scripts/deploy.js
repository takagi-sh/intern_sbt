// deploy.js
const main = async () => {
  // コントラクトがコンパイルします
  // コントラクトを扱うために必要なファイルが `artifacts` ディレクトリの直下に生成されます。
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  // Hardhat がローカルの Ethereum ネットワークを作成します。
  const nftContract = await nftContractFactory.deploy();
  // コントラクトが Mint され、ローカルのブロックチェーンにデプロイされるまで待ちます。
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);
  // makeAnEpicNFT 関数を呼び出す。NFT が Mint される。
  let txn = await nftContract.makeAnEpicNFT();
  // Minting が仮想マイナーにより、承認されるのを待ちます。
  await txn.wait();
  console.log("Minted NFT #1");

  // コントラクトがコンパイルします
  // コントラクトを扱うために必要なファイルが `artifacts` ディレクトリの直下に生成されます。
  const sbtContractFactory = await hre.ethers.getContractFactory("MyEpicSBT");
  // Hardhat がローカルの Ethereum ネットワークを作成します。
  const sbtContract = await sbtContractFactory.deploy();
  // コントラクトが Mint され、ローカルのブロックチェーンにデプロイされるまで待ちます。
  await sbtContract.deployed();
  console.log("Contract deployed to:", sbtContract.address);
  // makeAnEpicNFT 関数を呼び出す。NFT が Mint される。
  let txn_sbt = await sbtContract.makeAnEpicSBT();
  // Minting が仮想マイナーにより、承認されるのを待ちます。
  await txn_sbt.wait();
  console.log("Minted SBT #1");
};
// エラー処理を行っています。
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();