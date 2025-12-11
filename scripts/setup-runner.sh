#!/bin/bash
#
# GitHub Actions Self-Hosted Runner Setup Script
# Run this on root@home.pskumar.com
#

set -e

echo "🚀 Setting up GitHub Actions Self-Hosted Runner"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root: sudo bash setup-runner.sh"
  exit 1
fi

# Variables
RUNNER_VERSION="2.311.0"
RUNNER_USER="github-runner"
RUNNER_DIR="/opt/actions-runner"
REPO_URL="https://github.com/pskumarweb/async_dev"

# Create runner user
echo "📦 Creating runner user..."
if ! id "$RUNNER_USER" &>/dev/null; then
  useradd -m -s /bin/bash "$RUNNER_USER"
  echo "✅ User $RUNNER_USER created"
else
  echo "✅ User $RUNNER_USER already exists"
fi

# Install dependencies
echo "📦 Installing dependencies..."
apt-get update
apt-get install -y curl wget git jq build-essential libssl-dev libffi-dev python3 python3-pip
apt-get install -y nodejs npm

# Install Docker (if not already installed)
if ! command -v docker &> /dev/null; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  usermod -aG docker "$RUNNER_USER"
  echo "✅ Docker installed"
fi

# Create runner directory
echo "📂 Creating runner directory..."
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# Download GitHub Actions Runner
echo "⬇️  Downloading GitHub Actions Runner..."
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract
echo "📦 Extracting runner..."
tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Set permissions
chown -R "$RUNNER_USER:$RUNNER_USER" "$RUNNER_DIR"

echo ""
echo "✅ Runner setup complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  NEXT STEPS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Get a GitHub Runner Token:"
echo "   Go to: $REPO_URL/settings/actions/runners/new"
echo ""
echo "2. Configure the runner as the github-runner user:"
echo "   sudo su - $RUNNER_USER"
echo "   cd $RUNNER_DIR"
echo "   ./config.sh --url $REPO_URL --token YOUR_TOKEN_HERE"
echo ""
echo "3. Install and start the runner as a service:"
echo "   sudo $RUNNER_DIR/svc.sh install $RUNNER_USER"
echo "   sudo $RUNNER_DIR/svc.sh start"
echo ""
echo "4. Check runner status:"
echo "   sudo $RUNNER_DIR/svc.sh status"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
