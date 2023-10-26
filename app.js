const web3 = new Web3(window.ethereum);
let currentAccount = null;
const contractAddress = "0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8"; // Replace with your deployed contract address.
const contractABI = [[
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			}
		],
		"name": "registerUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "a",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "b",
				"type": "uint256"
			}
		],
		"name": "calculateAverage",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "registeredUsers",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]]; // Replace with your contract ABI.
const contractInstance = new web3.eth.Contract(contractABI, contractAddress);

document.getElementById('connectMetamask').onclick = async function() {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    currentAccount = accounts[0];
    console.log("Connected:", currentAccount);
};

document.getElementById('register').onclick = async function() {
    const name = document.getElementById('username').value;
    await contractInstance.methods.registerUser(name).send({ from: currentAccount });
    console.log("Registered:", name);
};

document.getElementById('calculate').onclick = async function() {
    const num1 = parseInt(document.getElementById('num1').value);
    const num2 = parseInt(document.getElementById('num2').value);
    
    const result = await contractInstance.methods.calculateAverage(num1, num2).call({ from: currentAccount });
    document.getElementById('result').innerText = "Average: " + result;
};
