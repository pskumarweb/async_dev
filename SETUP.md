# AvioSync Platform - Automated Development Setup

## Overview

This project uses GitHub Actions to automatically generate code for the aviation maintenance management platform.

## Problem Solved

The workflows were failing because `GITHUB_TOKEN` doesn't have permission to push code back to the repository. 

## Solutions

### Option 1: Use Personal Access Token (PAT) - **RECOMMENDED**

1. **Create a Personal Access Token:**
   - Go to: https://github.com/settings/tokens/new
   - Token name: `ASYNC_DEV_PAT`
   - Expiration: 90 days (or custom)
   - Select scopes:
     - ✅ `repo` (Full control of private repositories)
     - ✅ `workflow` (Update GitHub Action workflows)
   - Click "Generate token"
   - **COPY THE TOKEN** (you won't see it again!)

2. **Add Token to Repository Secrets:**
   - Go to: https://github.com/pskumarweb/async_dev/settings/secrets/actions/new
   - Name: `PAT_TOKEN`
   - Value: Paste the token you just created
   - Click "Add secret"

3. **Run the Workflow:**
   - Go to: https://github.com/pskumarweb/async_dev/actions/workflows/code-generator.yml
   - Click "Run workflow"
   - Select component to generate (or "all")
   - Click "Run workflow"

### Option 2: Use Self-Hosted Runner on home.pskumar.com

If you want more control and don't want to deal with tokens:

1. **SSH into your server:**
   ```bash
   ssh root@home.pskumar.com
   ```

2. **Download and run the setup script:**
   ```bash
   curl -o setup-runner.sh https://raw.githubusercontent.com/pskumarweb/async_dev/main/scripts/setup-runner.sh
   chmod +x setup-runner.sh
   sudo bash setup-runner.sh
   ```

3. **Get a runner token from GitHub:**
   - Go to: https://github.com/pskumarweb/async_dev/settings/actions/runners/new
   - Copy the token shown

4. **Configure the runner:**
   ```bash
   sudo su - github-runner
   cd /opt/actions-runner
   ./config.sh --url https://github.com/pskumarweb/async_dev --token YOUR_TOKEN_HERE
   exit
   ```

5. **Install and start the runner service:**
   ```bash
   sudo /opt/actions-runner/svc.sh install github-runner
   sudo /opt/actions-runner/svc.sh start
   sudo /opt/actions-runner/svc.sh status
   ```

6. **Update workflow to use self-hosted runner:**
   Edit `.github/workflows/code-generator.yml` and change:
   ```yaml
   runs-on: ubuntu-latest
   ```
   to:
   ```yaml
   runs-on: self-hosted
   ```

## Usage

### Generate All Code

```bash
# Via GitHub UI
1. Go to Actions tab
2. Select "Code Generator" workflow
3. Click "Run workflow"
4. Select "all" from dropdown
5. Click "Run workflow"
```

### Generate Specific Components

Choose from:
- `structure` - Project structure only
- `frontend` - Next.js frontend application
- `backend` - NestJS backend API
- `services` - File storage and payment microservices
- `database` - PostgreSQL schema and Docker setup
- `docs` - API documentation and README

## Workflow Features

✅ **Sequential Execution** - No merge conflicts, everything runs in order
✅ **Idempotent** - Safe to run multiple times, won't duplicate code
✅ **Automatic Commits** - Each component committed separately
✅ **Single Job** - Simplified, no parallel job coordination issues  
✅ **Comprehensive** - Generates full-stack application code
✅ **Skip CI Tags** - Prevents infinite workflow loops

## What Gets Generated

### Frontend (Next.js 14)
- TypeScript configuration
- Tailwind CSS setup
- App router structure
- UI components (TopNav, etc.)
- API client with axios
- Authentication hooks

### Backend (NestJS)
- REST API structure  
- Authentication module
- User management
- Database entities (TypeORM)
- JWT auth guards
- Environment configuration

### Microservices
- **File Storage**: Fastify-based upload service
- **Payment Service**: Square/Wise integration stub
- Docker files for each service

### Database
- PostgreSQL schema with migrations
- User and work request tables
- Indexes for performance
- Docker Compose setup
- Seed data scripts

### Documentation
- OpenAPI 3.0 specification
- README with quick start
- Architecture overview
- Development guides

## Troubleshooting

### Issue: Workflow fails with "fatal: could not read Username"

**Solution**: You need to add PAT_TOKEN secret (see Option 1 above)

### Issue: Code not appearing in repository

**Solution**: Check workflow logs, ensure PAT_TOKEN has correct permissions

### Issue: Want to run locally instead

**Solution**: Use self-hosted runner (see Option 2 above)

## Next Steps

After code generation:

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start database:**
   ```bash
   cd infra/docker
   docker-compose up -d
   ```

3. **Run migrations:**
   ```bash
   npm run migrate
   ```

4. **Start development servers:**
   ```bash
   npm run dev
   ```

## Support

For issues:
1. Check workflow logs in Actions tab
2. Verify PAT_TOKEN is set correctly
3. Ensure runner is online (if using self-hosted)
4. Review this documentation

## Architecture

```
aviosync-platform/
├── apps/
│   ├── frontend/          # Next.js app (Port 3000)
│   ├── backend/           # NestJS API (Port 3001)
│   ├── file-storage/      # Upload service (Port 3002)
│   └── payment-service/   # Payment processing (Port 3003)
├── packages/
│   ├── ui/                # Shared UI components
│   ├── lib/               # Shared utilities
│   └── shared-types/      # TypeScript types
├── infra/
│   ├── docker/            # Docker Compose files
│   ├── terraform/         # Infrastructure as code
│   └── monitoring/        # Prometheus config
├── scripts/
│   ├── migration/         # Database migrations
│   └── seed/              # Seed data
└── docs/
    ├── api/               # OpenAPI specs
    └── guides/            # Development guides
```

## License

Proprietary - All rights reserved
