#!/bin/bash
#
# Automated Runner Fix Script
# This will diagnose and fix the offline runner issue
#
# Usage: bash fix-runner.sh YOUR_GITHUB_TOKEN
#

set -e

RUNNER_DIR="/opt/actions-runner"
REPO_URL="https://github.com/pskumarweb/async_dev"
RUNNER_USER="github-runner"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔧 GitHub Actions Runner - Automated Fix"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if token provided
if [ -z "$1" ]; then
  echo "❌ ERROR: GitHub token not provided"
  echo ""
  echo "Usage: bash fix-runner.sh YOUR_GITHUB_TOKEN"
  echo ""
  echo "Get a token from:"
  echo "https://github.com/pskumarweb/async_dev/settings/actions/runners/new"
  echo ""
  exit 1
fi

GITHUB_TOKEN="$1"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root: sudo bash fix-runner.sh YOUR_TOKEN"
  exit 1
fi

echo "📋 Step 1: Checking current status..."
if systemctl is-active --quiet "actions.runner.pskumarweb-async_dev.*" 2>/dev/null; then
  echo "✅ Service is running (but may be misconfigured)"
  SERVICE_RUNNING=true
else
  echo "⚠️  Service is not running"
  SERVICE_RUNNING=false
fi

echo ""
echo "📋 Step 2: Stopping runner service..."
cd "$RUNNER_DIR"
if [ -f "svc.sh" ]; then
  ./svc.sh stop 2>/dev/null || echo "Service was not running"
  ./svc.sh uninstall 2>/dev/null || echo "Service was not installed"
else
  echo "⚠️  svc.sh not found, skipping service stop"
fi

echo ""
echo "📋 Step 3: Removing old configuration..."
if sudo -u "$RUNNER_USER" bash -c "cd $RUNNER_DIR && ./config.sh remove --token $GITHUB_TOKEN" 2>/dev/null; then
  echo "✅ Old configuration removed"
else
  echo "⚠️  No previous configuration found (this is OK)"
fi

echo ""
echo "📋 Step 4: Cleaning up work directory..."
rm -rf "$RUNNER_DIR/_work" 2>/dev/null || true
rm -rf "$RUNNER_DIR/_diag" 2>/dev/null || true

echo ""
echo "📋 Step 5: Setting correct permissions..."
chown -R "$RUNNER_USER:$RUNNER_USER" "$RUNNER_DIR"
chmod -R 755 "$RUNNER_DIR"

echo ""
echo "📋 Step 6: Configuring runner with new token..."
sudo -u "$RUNNER_USER" bash << EOF
cd "$RUNNER_DIR"
./config.sh --url "$REPO_URL" \
  --token "$GITHUB_TOKEN" \
  --name "home-pskumar" \
  --labels "self-hosted,linux,x64" \
  --unattended \
  --replace
EOF

if [ $? -eq 0 ]; then
  echo "✅ Runner configured successfully"
else
  echo "❌ Configuration failed"
  exit 1
fi

echo ""
echo "📋 Step 7: Installing service..."
cd "$RUNNER_DIR"
./svc.sh install "$RUNNER_USER"

echo ""
echo "📋 Step 8: Starting service..."
./svc.sh start

echo ""
echo "📋 Step 9: Waiting for runner to connect..."
sleep 5

echo ""
echo "📋 Step 10: Checking status..."
./svc.sh status

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ FIX COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔍 Verify runner is online:"
echo "https://github.com/pskumarweb/async_dev/settings/actions/runners"
echo ""
echo "You should see:"
echo "  Name: home-pskumar"
echo "  Status: 🟢 Idle (green dot)"
echo ""
echo "If still offline, check logs:"
echo "sudo journalctl -u actions.runner.pskumarweb-async_dev.home-pskumar -n 50"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
