#!/bin/bash
# Copy and paste these commands one by one on root@home.pskumar.com

# Download and run the complete setup script
curl -o /tmp/complete-setup.sh https://raw.githubusercontent.com/pskumarweb/async_dev/main/scripts/complete-setup.sh
chmod +x /tmp/complete-setup.sh
sudo bash /tmp/complete-setup.sh

# After the script completes, follow the instructions to:
# 1. Get runner token from: https://github.com/pskumarweb/async_dev/settings/actions/runners/new
# 2. Configure runner with that token
# 3. Start the service
