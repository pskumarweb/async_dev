# GitHub Workflows - Automated Development System

This directory contains GitHub Actions workflows that automate the complete development lifecycle of the AvioSync platform.

## 📋 Overview

The automated development system consists of three main workflows:

1. **Auto Development Workflow** - Scaffolds and develops complete system components
2. **Feature Development** - Develops specific features on demand
3. **Build, Test & Deploy** - Continuous integration and deployment pipeline

## 🚀 Workflows

### 1. Auto Development Workflow (`auto-development.yml`)

**Purpose**: Automates the creation and development of entire system components including frontend, backend, microservices, and database setup.

**Trigger**: 
- Manual dispatch via GitHub Actions UI
- Daily at 2 AM UTC (for scheduled development tasks)

**Usage**:
```bash
# Via GitHub UI:
Actions → Auto Development Workflow → Run workflow

# Select options:
Component: [all | frontend | backend | file-storage | payment-service | database]
Task: [scaffold | develop-features | test | deploy]
```

**Jobs**:
- `setup-repository` - Creates project structure
- `develop-frontend` - Initializes Next.js application with components
- `develop-backend` - Sets up NestJS with modules and entities
- `develop-file-storage` - Creates file storage microservice
- `develop-payment-service` - Sets up payment microservice
- `setup-database` - Creates database schema and migrations
- `ci-pipeline` - Runs linting, type checking, and tests
- `generate-docs` - Creates API documentation
- `security-scan` - Runs security vulnerability scans
- `setup-monitoring` - Configures monitoring infrastructure

### 2. Feature Development Workflow (`feature-development.yml`)

**Purpose**: Develops specific features and components on demand.

**Trigger**: Manual dispatch

**Available Features**:
- `work-request-form` - Work request creation UI
- `shop-dashboard` - Shop manager dashboard
- `task-management` - Task assignment and tracking
- `messaging-system` - Real-time messaging with WebSockets
- `file-upload` - Multi-file upload component
- `billing-estimates` - Invoice and estimate generation
- `user-authentication` - JWT-based auth system
- `notifications` - Email and push notifications
- `analytics-dashboard` - Metrics and reporting

**Usage**:
```bash
Actions → Feature Development Automation → Run workflow
Select feature from dropdown
```

### 3. Build, Test & Deploy Workflow (`build-test-deploy.yml`)

**Purpose**: Comprehensive CI/CD pipeline for testing and deploying the application.

**Triggers**:
- Push to `main`, `develop`, or `staging` branches
- Pull requests to `main` or `develop`
- Manual dispatch

**Jobs**:
- `test-frontend` - Lint, type-check, test, and build frontend
- `test-backend` - Run backend tests with PostgreSQL
- `test-microservices` - Test file-storage and payment services
- `build-docker-images` - Build and push container images
- `deploy-frontend-vercel` - Deploy frontend to Vercel
- `deploy-backend` - Deploy backend to Cloud Run
- `e2e-tests` - Run Playwright end-to-end tests
- `performance-tests` - Run k6 load tests
- `database-migration` - Run production migrations
- `notify-deployment` - Send deployment notifications
- `rollback` - Automatic rollback on failure

## 🔧 Setup Instructions

### Prerequisites

1. **Repository Secrets** (Settings → Secrets and variables → Actions):
   ```
   GITHUB_TOKEN              # Automatically provided
   VERCEL_TOKEN              # Vercel deployment token
   VERCEL_ORG_ID             # Vercel organization ID
   VERCEL_PROJECT_ID         # Vercel project ID
   GCP_PROJECT_ID            # Google Cloud project ID
   GCP_SA_KEY                # GCP service account key
   PRODUCTION_DATABASE_URL   # Production database connection
   STAGING_URL               # Staging environment URL
   SLACK_WEBHOOK             # (Optional) Slack notifications
   ```

2. **Enable GitHub Actions**:
   - Go to Settings → Actions → General
   - Enable "Allow all actions and reusable workflows"
   - Set "Workflow permissions" to "Read and write permissions"

3. **Container Registry**:
   - Ensure GitHub Container Registry (ghcr.io) is enabled
   - Images will be pushed to `ghcr.io/your-org/aviosync/*`

### Initial Setup

1. **Scaffold the entire project**:
   ```bash
   # Via GitHub Actions UI
   Actions → Auto Development Workflow → Run workflow
   Component: all
   Task: scaffold
   ```

2. **Develop core components**:
   ```bash
   # Develop all components
   Component: all
   Task: develop-features
   ```

3. **Verify CI pipeline**:
   ```bash
   # Push to develop branch to trigger CI
   git push origin develop
   ```

## 📊 Development Workflow

### Typical Development Flow

1. **Create Feature Branch**:
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Use Feature Development Workflow**:
   - Go to Actions → Feature Development Automation
   - Select the feature you want to develop
   - Run workflow
   - Review and commit generated code

3. **Create Pull Request**:
   - Push your branch
   - Create PR to `develop`
   - CI pipeline runs automatically
   - Review automated test results

4. **Merge to Develop**:
   - Merge PR after approval
   - Automatic deployment to staging

5. **Release to Production**:
   - Merge `develop` → `main`
   - Automatic deployment to production
   - E2E tests run automatically
   - Performance tests validate deployment

## 🎯 Component Development Examples

### Example 1: Develop Frontend Only

```yaml
Component: frontend
Task: develop-features
```

This will:
- Initialize Next.js app
- Create layout components (TopNav, SideNav)
- Set up API client
- Configure TypeScript and Tailwind
- Commit changes automatically

### Example 2: Add Work Request Feature

```yaml
Feature: work-request-form
```

This will:
- Create work request form component
- Add form validation
- Implement API integration
- Add file upload support
- Commit feature automatically

### Example 3: Setup Complete Backend

```yaml
Component: backend
Task: develop-features
```

This will:
- Initialize NestJS application
- Generate all required modules
- Create database entities
- Set up authentication
- Configure TypeORM
- Commit backend code

## 🔍 Monitoring & Debugging

### View Workflow Runs
```
Repository → Actions → Select workflow → View run
```

### Check Logs
- Click on any job to view detailed logs
- Download logs for offline analysis
- View artifacts (test reports, build outputs)

### Common Issues

**Issue**: Workflow fails with "permission denied"
**Solution**: Check repository settings → Actions → Workflow permissions

**Issue**: Docker build fails
**Solution**: Ensure Dockerfile exists in the app directory

**Issue**: Tests fail
**Solution**: Check PostgreSQL service status and connection string

## 📈 Metrics & Analytics

The workflows automatically track:
- Build success/failure rates
- Test coverage
- Deployment frequency
- Performance metrics (via k6)
- Security vulnerabilities (via Trivy)

View metrics in:
- Actions tab → Select workflow → Insights
- Security tab → Dependabot alerts
- Container registry → Package details

## 🔐 Security

### Automated Security Measures

1. **Dependency Scanning**: Trivy scans for vulnerabilities
2. **Secret Scanning**: GitHub automatically detects exposed secrets
3. **Code Scanning**: (Enable CodeQL for static analysis)
4. **Container Scanning**: Images scanned before deployment

### Best Practices

- Never commit secrets to repository
- Use GitHub Secrets for sensitive data
- Enable branch protection on `main`
- Require PR reviews before merging
- Enable signed commits

## 🚢 Deployment Environments

### Staging (develop branch)
- Automatic deployment on push to `develop`
- Vercel preview deployments for frontend
- Cloud Run staging instance for backend
- Staging database (separate from production)

### Production (main branch)
- Automatic deployment on push to `main`
- E2E tests run before deployment
- Database migrations run automatically
- Automatic rollback on failure
- Performance tests validate deployment

## 📝 Customization

### Adding New Features

1. Edit `feature-development.yml`
2. Add new job for your feature:
   ```yaml
   develop-new-feature:
     name: Develop New Feature
     runs-on: ubuntu-latest
     if: github.event.inputs.feature == 'new-feature'
     steps:
       - uses: actions/checkout@v4
       - name: Generate feature code
         run: |
           # Your feature generation code
   ```

### Adding New Microservices

1. Create microservice directory: `apps/new-service/`
2. Add Dockerfile
3. Add job to `auto-development.yml`
4. Add to `build-docker-images` matrix in `build-test-deploy.yml`

### Custom Deployment Targets

Modify `deploy-backend` job in `build-test-deploy.yml`:
```yaml
- name: Deploy to Custom Platform
  run: |
    # Your deployment commands
```

## 🤝 Contributing

When contributing to workflows:

1. Test changes in a fork first
2. Use workflow_dispatch for testing
3. Document any new secrets required
4. Update this README with changes
5. Follow conventional commit messages

## 📚 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [NestJS Documentation](https://docs.nestjs.com)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Vercel CLI](https://vercel.com/docs/cli)

## 🆘 Support

For issues with workflows:

1. Check workflow logs in Actions tab
2. Review this documentation
3. Check repository secrets configuration
4. Create an issue with workflow run link

---

**Last Updated**: 2025-12-10
**Maintained By**: AvioSync Development Team
