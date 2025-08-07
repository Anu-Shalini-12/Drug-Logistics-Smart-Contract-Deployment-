# 💊 Drug Logistics Smart Contract Deployment & Transaction Tracking Using Ganache

## 📌 Project Overview

This project demonstrates the deployment and simulation of a **Drug Supply Chain Management System** using **Solidity smart contracts** on a **local Ethereum blockchain environment** powered by **Ganache**. The system enables role-based tracking of drugs from **Manufacturer** to **Consumer**, ensuring transparency, traceability, and accountability in the pharmaceutical supply chain.

---

## ⚙️ Setup & Environment

### 🔧 Tools Used

| Tool        | Purpose                                                       |
|-------------|---------------------------------------------------------------|
| **Ganache** | Local Ethereum blockchain for deployment and testing          |
| **Remix IDE** | Solidity development, compilation, deployment via Web3      |
| **MetaMask** | Connect Remix to Ganache using Injected Web3 (localhost RPC) |

### 🧪 Environment Details

- Ganache CLI/Desktop used to simulate a blockchain with pre-funded accounts  
- Remix IDE used to write, compile, and deploy the smart contract  
- Deployment verified with transaction receipts, logs, gas costs, and events via Remix & Ganache  

---

## 🧠 Smart Contract: `DrugSupplyChain.sol`

### 🚀 Core Functions

| Function | Description |
|---------|-------------|
| `registerDrug(string _name, string _description)` | Registers a new drug (Manufacturer only) |
| `assignRole(address _user, Role _role)` | Assigns roles (Admin-only) |
| `transferDrug(uint _drugId, address _to)` | Transfers drug ownership |
| `updateDrugStatus(uint _drugId, DrugStatus _status)` | Updates drug status at key checkpoints |
| `getDrugDetails(uint _drugId)` | Fetches full drug data and history |
| `getMyDrugs()` | Lists drugs owned by the caller |

---

## 🚀 Deployment & Transactions

### 🔨 Deployment

- Contract deployed via **Remix Web3 provider** using **Ganache's Admin account**
- Deployment gas fee deducted from Admin's balance in Ganache

### 🛡️ Role Assignments

| Role        | Ganache Address |
|-------------|------------------|
| Manufacturer (Admin) | `0xaE7B8bbdE07775C408c5Ed8A2607644b60966b8B` |
| Supplier     | `0x01e64ab9EE913C1d14D7688e75946Ce7160c8eF3` |
| Distributor  | `0x854291B9696a5B5f7d72f245549Ae790bb474d46` |
| Pharmacy     | `0x1dCF636113C537EadE0AF0974c7Bfb2072978ce6` |
| Consumer     | `0xECacd61DD74E2163F360eA26805BdBf16c04be3c` |

---

### 🔄 Drug Lifecycle Transactions

| Action                | Function          | Initiator   | Description                                  |
|-----------------------|-------------------|-------------|----------------------------------------------|
| Register Drug         | `registerDrug()`  | Manufacturer | Adds new drug to the system                  |
| Transfer to Supplier  | `transferDrug()`  | Manufacturer | Sends drug to Supplier                       |
| Transfer to Distributor | `transferDrug()` | Supplier    | Sends drug to Distributor                    |
| Transfer to Pharmacy  | `transferDrug()`  | Distributor | Sends drug to Pharmacy                       |
| Transfer to Consumer  | `transferDrug()`  | Pharmacy    | Sells/transfers drug to Consumer             |
| Status Update         | `updateDrugStatus()` | All roles | Updates drug status post each transfer       |

---

## 📊 Enum Reference Tables

### 🧑‍⚕️ Role Enum Mapping

| Role         | Enum Value |
|--------------|------------|
| None         | 0          |
| Manufacturer | 1          |
| Supplier     | 2          |
| Distributor  | 3          |
| Pharmacy     | 4          |
| Consumer     | 5          |

### 🚚 DrugStatus Enum Mapping

| Drug Status          | Enum Value |
|----------------------|------------|
| Manufactured         | 0          |
| InTransit            | 1          |
| DeliveredToPharmacy  | 2          |
| Sold                 | 3          |

---

## 📈 Summary of Achievements

- ✅ **Smart Contract Deployment**: Successfully deployed using Ganache and Remix  
- ✅ **Role Management**: Access control enforced via modifiers  
- ✅ **Lifecycle Simulation**: Drug flow tracked across all roles  
- ✅ **Transaction Tracking**: All actions, gas usage, and events recorded in Ganache logs  
- ✅ **Status Updates**: Verified at each transfer checkpoint  

---


