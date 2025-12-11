# Quick Start Guide - Code Generation

## 🚀 Fastest Way to Generate Code

### Step 1: Add PAT Token (One-time setup)

1. Create token: https://github.com/settings/tokens/new
   - Name: `ASYNC_DEV_PAT`
   - Scopes: ✅ `repo` and ✅ `workflow`
   - Copy the token

2. Add to secrets: https://github.com/pskumarweb/async_dev/settings/secrets/actions/new
   - Name: `PAT_TOKEN`
   - Value: Paste your token
   - Save

### Step 2: Run Workflow

1. Go to: https://github.com/pskumarweb/async_dev/actions/workflows/code-generator.yml
2. Click **"Run workflow"** button
3. Select component (choose **"all"** for full stack)
4. Click **"Run workflow"** again
5. Wait 2-5 minutes ⏱️
6. Check your repository - code is committed! 🎉

## 📦 What You Get

- ✅ Next.js frontend with TypeScript & Tailwind
- ✅ NestJS backend with TypeORM
- ✅ Microservices (File Storage, Payment)
- ✅ PostgreSQL schema & Docker setup
- ✅ Complete API documentation
- ✅ README and setup guides

## 🔧 Alternative: Self-Hosted Runner

If you prefer running on your own server:

```bash
# On root@home.pskumar.com
curl -o setup-runner.sh https://raw.githubusercontent.com/pskumarweb/async_dev/main/scripts/setup-runner.sh
chmod +x setup-runner.sh
sudo bash setup-runner.sh

# Follow the on-screen instructions
```

## 💡 Tips

- **First time?** Use "all" to generate everything
- **Need updates?** Select specific components
- **Check progress:** Watch Actions tab for real-time logs
- **Automatic commits:** Each component committed separately
- **Safe to re-run:** Won't duplicate existing code

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| "fatal: could not read Username" | Add PAT_TOKEN secret (see Step 1) |
| "Resource not accessible" | Token needs `repo` and `workflow` scopes |
| Code not appearing | Check workflow succeeded in Actions tab |
| Want to customize | Edit `.github/workflows/code-generator.yml` |

## 📖 Full Documentation

See [SETUP.md](./SETUP.md) for complete details.

---

**Need help?** Check workflow logs or review SETUP.md
