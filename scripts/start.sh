#!/bin/bash
set -e

# Tempo Private Chain Startup Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Tempo Private Chain...${NC}"

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  No .env file found. Creating from template...${NC}"
    cp .env.example .env 2>/dev/null || cp .env .env.example 2>/dev/null || true
fi

# Create necessary directories
mkdir -p logs config

# Parse arguments
MULTI_VALIDATOR=false
RESET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --multi-validator|-m)
            MULTI_VALIDATOR=true
            shift
            ;;
        --reset|-r)
            RESET=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -m, --multi-validator  Start with 3 validators"
            echo "  -r, --reset           Reset all data and start fresh"
            echo "  -h, --help            Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Reset if requested
if [ "$RESET" = true ]; then
    echo -e "${YELLOW}🗑️  Resetting all data...${NC}"
    docker compose down -v 2>/dev/null || true
    rm -rf logs/*
fi

# Start the appropriate configuration
if [ "$MULTI_VALIDATOR" = true ]; then
    echo -e "${GREEN}📦 Starting multi-validator setup (3 validators)...${NC}"
    docker compose -f docker-compose.yml -f docker-compose.multi-validator.yml up -d
else
    echo -e "${GREEN}📦 Starting single validator setup...${NC}"
    docker compose up -d
fi

# Wait for genesis to complete
echo -e "${YELLOW}⏳ Waiting for genesis generation...${NC}"
docker compose logs -f genesis 2>/dev/null || true

# Show status
echo ""
echo -e "${GREEN}✅ Tempo Private Chain started!${NC}"
echo ""
echo "📊 RPC Endpoints:"
echo "   HTTP: http://localhost:8545"
echo "   WS:   ws://localhost:8546"
echo ""
echo "📝 Useful commands:"
echo "   View logs:    docker compose logs -f"
echo "   Stop:         docker compose down"
echo "   Reset:        ./scripts/start.sh --reset"
echo ""
