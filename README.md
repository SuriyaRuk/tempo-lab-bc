# Tempo Private Chain - Docker Setup

Docker Compose configuration สำหรับรัน Tempo blockchain เป็น private chain พร้อม validator

## 📁 โครงสร้างไฟล์

```
tempo-private-chain/
├── docker-compose.yml              # Single validator setup
├── docker-compose.multi-validator.yml  # Multi-validator overlay
├── .env                            # Configuration
├── scripts/
│   ├── start.sh                   # Start script
│   ├── stop.sh                    # Stop script
│   └── reset.sh                   # Reset all data
├── logs/                          # Node logs
└── config/                        # Custom configs
```

## 🚀 Quick Start

### Single Validator (Development)

```bash
# Start
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

### Multi-Validator Setup

```bash
# Start with 3 validators
docker compose -f docker-compose.yml -f docker-compose.multi-validator.yml up -d

# Or use the script
./scripts/start.sh --multi-validator
```

## ⚙️ Configuration

แก้ไขไฟล์ `.env` เพื่อปรับค่า:

| Variable | Default | Description |
|----------|---------|-------------|
| `ACCOUNTS` | 1000 | จำนวน accounts ที่จะสร้างใน genesis |
| `CHAIN_ID` | 1337 | Chain ID ของ network |
| `BLOCK_TIME` | 1sec | เวลาในการสร้าง block |
| `GAS_LIMIT` | 3000000000 | Gas limit ต่อ block |
| `FAUCET_AMOUNT` | 1000000000000 | จำนวน ETH ที่ faucet แจก |

## 🔗 Endpoints

| Service | URL |
|---------|-----|
| HTTP RPC | http://localhost:8545 |
| WebSocket | ws://localhost:8546 |
| P2P | 30303 |
| Consensus | 9000 |

### Multi-Validator Ports

| Validator | HTTP RPC | WebSocket | P2P | Consensus |
|-----------|----------|-----------|-----|-----------|
| Validator 1 | 8545 | 8546 | 30303 | 9000 |
| Validator 2 | 8555 | 8556 | 30313 | 9001 |
| Validator 3 | 8565 | 8566 | 30323 | 9002 |

## 📝 Services

### 1. Genesis Service
- สร้าง genesis file และ validator keys
- ใช้ `tempo-xtask` image
- รันครั้งเดียวแล้วจบ

### 2. Tempo Node Service
- รัน validator node
- รอให้ genesis service เสร็จก่อน
- เปิด HTTP/WS RPC และ faucet

## 🔧 Commands

```bash
# ดู status
docker compose ps

# ดู logs ของ node
docker compose logs -f tempo-node

# เข้าไปใน container
docker exec -it tempo-validator /bin/bash

# Reset ทุกอย่าง
./scripts/reset.sh
```

## 🧪 ทดสอบ RPC

```bash
# Check block number
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Get chain ID
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'

# Request funds from faucet (if enabled)
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tempo_requestFunds","params":["0xYourAddress"],"id":1}'
```

## ⚠️ Notes

- **Development Only**: Default private keys ไม่ควรใช้ใน production
- **Data Persistence**: Data ถูกเก็บใน Docker volumes (`genesis-data`, `node-data`)
- **Logs**: Log files อยู่ใน `./logs/` directory

## 🔗 References

- [Tempo GitHub](https://github.com/tempoxyz/tempo)
- [Tempo Documentation](https://docs.tempo.xyz)
