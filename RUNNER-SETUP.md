# Self-Hosted Runner Setup Instructions for home.pskumar.com

## 🎯 Quick Overview

You need to:
1. SSH to your server
2. Run the setup script
3. Get a GitHub token
4. Configure the runner
5. Start the service

---

## 📋 Detailed Steps

### Step 1: SSH to Your Server

```bash
ssh root@home.pskumar.com
```

### Step 2: Download and Run Setup Script

Copy and paste this entire block:

```bash
curl -o /tmp/complete-setup.sh https://raw.githubusercontent.com/pskumarweb/async_dev/main/scripts/complete-setup.sh
chmod +x /tmp/complete-setup.sh
sudo bash /tmp/complete-setup.sh
```

This will:
- ✅ Install Node.js 20, Docker, Git, and dependencies
- ✅ Create `github-runner` user
- ✅ Download GitHub Actions runner
- ✅ Set up directory structure
- ✅ Configure permissions

**Wait for it to complete** (takes 1-2 minutes)

---

### Step 3: Get GitHub Runner Token

1. **Open this link in your browser:**
   ```
   https://github.com/pskumarweb/async_dev/settings/actions/runners/new
   ```

2. **Copy the token** shown on the page (starts with `AAAA...`)
   - It looks like: `AAAAB3NzaC1yc2EAAAADAQABAAABAQ...`
   - You need this for the next step

---

### Step 4: Configure the Runner

**On your server**, run these commands:

```bash
# Switch to runner user
sudo su - github-runner

# Go to runner directory
cd /opt/actions-runner

# Configure runner (replace YOUR_TOKEN_HERE with actual token from Step 3)
./config.sh --url https://github.com/pskumarweb/async_dev --token YOUR_TOKEN_HERE --name home-pskumar --labels self-hosted,linux,x64

# When prompted:
# - Runner group: Press ENTER (use default)
# - Runner name: Press ENTER (use 'home-pskumar')
# - Work folder: Press ENTER (use default)

# Exit back to root user
exit
```

---

### Step 5: Install and Start the Service

```bash
# Navigate to runner directory
cd /opt/actions-runner

# Install as systemd service
sudo ./svc.sh install github-runner

# Start the service
sudo ./svc.sh start

# Check status
sudo ./svc.sh status
```

You should see: **"Active: active (running)"**

---

### Step 6: Verify Runner is Online

1. **Open this link:**
   ```
   https://github.com/pskumarweb/async_dev/settings/actions/runners
   ```

2. **Check for:**
   - Runner name: `home-pskumar`
   - Status: 🟢 **Idle** (green dot)

If you see this, **SUCCESS!** 🎉

---

## 🚀 Running the Workflow

The workflow has already been updated to use your self-hosted runner.

### To Generate Code:

1. **Go to:**
   ```
   https://github.com/pskumarweb/async_dev/actions/workflows/code-generator.yml
   ```

2. **Click:** "Run workflow" (green button)

3. **Select:** `all` from dropdown (or specific component)

4. **Click:** "Run workflow" again

5. **Watch it run** on your server!

The code will be generated and automatically committed to your repository.

---

## 📊 Monitoring

### Check runner status:
```bash
sudo /opt/actions-runner/svc.sh status
```

### View runner logs:
```bash
sudo journalctl -u actions.runner.pskumarweb-async_dev.home-pskumar -f
```

### Stop runner:
```bash
sudo /opt/actions-runner/svc.sh stop
```

### Start runner:
```bash
sudo /opt/actions-runner/svc.sh start
```

### Restart runner:
```bash
sudo /opt/actions-runner/svc.sh restart
```

---

## 🔧 Troubleshooting

### Issue: Runner not showing as online

**Solution 1:** Check service status
```bash
sudo /opt/actions-runner/svc.sh status
```

**Solution 2:** Check logs
```bash
sudo journalctl -u actions.runner.pskumarweb-async_dev.home-pskumar -n 50
```

**Solution 3:** Restart service
```bash
sudo /opt/actions-runner/svc.sh restart
```

### Issue: Token expired

Get a new token from:
```
https://github.com/pskumarweb/async_dev/settings/actions/runners/new
```

Then reconfigure:
```bash
sudo su - github-runner
cd /opt/actions-runner
./config.sh remove --token OLD_TOKEN
./config.sh --url https://github.com/pskumarweb/async_dev --token NEW_TOKEN --name home-pskumar
exit
sudo /opt/actions-runner/svc.sh restart
```

### Issue: Node.js version too old

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
sudo /opt/actions-runner/svc.sh restart
```

### Issue: Permission denied errors

```bash
sudo chown -R github-runner:github-runner /opt/actions-runner
sudo /opt/actions-runner/svc.sh restart
```

---

## 🎯 What Happens When You Run the Workflow

1. **Workflow triggered** from GitHub Actions UI
2. **Job assigned** to your `home-pskumar` runner
3. **Runner executes** on your server at `/opt/actions-runner/_work/async_dev/async_dev`
4. **Code generated** sequentially (structure → frontend → backend → services → database → docs)
5. **Commits made** to your repository automatically
6. **Job completes** - code is in your repo!

---

## 📦 Generated Code Location

On your server, code is temporarily in:
```
/opt/actions-runner/_work/async_dev/async_dev/
```

But the permanent location is your GitHub repository after commits.

---

## 💡 Benefits of Self-Hosted Runner

✅ **No PAT token needed** - runner has repo access
✅ **More resources** - uses your server's power
✅ **Faster execution** - no GitHub-hosted runner limits
✅ **Full control** - customize environment as needed
✅ **Cost effective** - no GitHub Actions minutes used

---

## 🔄 Workflow File

The workflow is configured to use `runs-on: self-hosted` in:
```
.github/workflows/code-generator.yml
```

Already updated and committed!

---

## 📞 Need Help?

If stuck, check:
1. Runner status: `sudo /opt/actions-runner/svc.sh status`
2. Runner logs: `sudo journalctl -u actions.runner.* -f`
3. GitHub: https://github.com/pskumarweb/async_dev/settings/actions/runners
4. Workflow runs: https://github.com/pskumarweb/async_dev/actions

---

**That's it! Once the runner shows as online, you can generate code anytime! 🚀**
