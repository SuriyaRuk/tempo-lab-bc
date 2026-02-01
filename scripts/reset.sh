#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "⚠️  This will delete all chain data and volumes!"
read -p "Are you sure? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Removing all data..."

    # Stop containers
    docker compose down -v 2>/dev/null || true

    # Clean up logs
    rm -rf logs/*

    echo "✅ All data has been reset!"
    echo ""
    echo "Run './scripts/start.sh' to start fresh."
else
    echo "❌ Cancelled."
fi
