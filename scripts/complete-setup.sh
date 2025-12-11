#!/bin/bash
# 
# Complete Self-Hosted Runner Setup
# Run this script on root@home.pskumar.com
#
# Usage: bash complete-setup.sh
#

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🏠 GitHub Actions Self-Hosted Runner Setup"
echo "  Server: home.pskumar.com"
echo "  Repository: pskumarweb/async_dev"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root: sudo bash complete-setup.sh"
  exit 1
fi

# Variables
RUNNER_VERSION="2.311.0"
RUNNER_USER="github-runner"
RUNNER_DIR="/opt/actions-runner"
REPO_URL="https://github.com/pskumarweb/async_dev"

# Step 1: Update system
echo "📦 Step 1: Updating system..."
apt-get update -qq

# Step 2: Install dependencies
echo "📦 Step 2: Installing dependencies..."
apt-get install -y -qq curl wget git jq build-essential libssl-dev libffi-dev python3 python3-pip

# Install Node.js 20 (required for Next.js)
if ! command -v node &> /dev/null || [[ $(node -v | cut -d. -f1 | sed 's/v//') -lt 20 ]]; then
  echo "📦 Installing Node.js 20..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

# Install Docker if not present
if ! command -v docker &> /dev/null; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  rm /tmp/get-docker.sh
fi

# Step 3: Create runner user
echo "👤 Step 3: Creating runner user..."
if ! id "$RUNNER_USER" &>/dev/null; then
  useradd -m -s /bin/bash "$RUNNER_USER"
  usermod -aG docker "$RUNNER_USER"
  echo "✅ User $RUNNER_USER created"
else
  echo "✅ User $RUNNER_USER already exists"
fi

# Step 4: Create runner directory
echo "📂 Step 4: Creating runner directory..."
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# Step 5: Download GitHub Actions Runner
if [ ! -f "$RUNNER_DIR/config.sh" ]; then
  echo "⬇️  Step 5: Downloading GitHub Actions Runner v${RUNNER_VERSION}..."
  curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
  
  echo "📦 Extracting runner..."
  tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
  rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
else
  echo "✅ Step 5: Runner already downloaded"
fi

# Step 6: Set permissions
echo "🔒 Step 6: Setting permissions..."
chown -R "$RUNNER_USER:$RUNNER_USER" "$RUNNER_DIR"

# Step 7: Install dependencies
echo "📦 Step 7: Installing runner dependencies..."
sudo -u "$RUNNER_USER" "$RUNNER_DIR/bin/installdependencies.sh" || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ SETUP COMPLETE! Next steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "STEP 1: Get a runner token from GitHub"
echo "→ Visit: $REPO_URL/settings/actions/runners/new"
echo "→ Copy the token shown on the page"
echo ""
echo "STEP 2: Configure the runner (replace YOUR_TOKEN with actual token)"
echo "→ Run: sudo su - $RUNNER_USER"
echo "→ Run: cd $RUNNER_DIR"
echo "→ Run: ./config.sh --url $REPO_URL --token YOUR_TOKEN --name home-pskumar --labels self-hosted,linux,x64"
echo "→ When prompted for runner group: Press Enter (default)"
echo "→ When prompted for runner name: Press Enter (or enter custom name)"
echo "→ When prompted for work folder: Press Enter (default)"
echo "→ Run: exit"
echo ""
echo "STEP 3: Install and start the service"
echo "→ Run: cd $RUNNER_DIR"
echo "→ Run: sudo ./svc.sh install $RUNNER_USER"
echo "→ Run: sudo ./svc.sh start"
echo "→ Run: sudo ./svc.sh status"
echo ""
echo "STEP 4: Verify runner is online"
echo "→ Visit: $REPO_URL/settings/actions/runners"
echo "→ You should see 'home-pskumar' with a green dot"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🚀 After runner is online:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Update the workflow to use self-hosted runner:"
echo "1. Edit: .github/workflows/code-generator.yml"
echo "2. Change: runs-on: ubuntu-latest"
echo "3. To:     runs-on: self-hosted"
echo "4. Commit and push the change"
echo ""
echo "Then run the workflow:"
echo "→ Visit: $REPO_URL/actions/workflows/code-generator.yml"
echo "→ Click 'Run workflow'"
echo "→ Select 'all' from dropdown"
echo "→ Click 'Run workflow'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
