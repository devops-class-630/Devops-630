Artifacts in GitHub Actions are used to share data between jobs and to store data that can be downloaded after a workflow has run. You can use artifacts to persist data like build outputs or test results and then share them across jobs within the same workflow or publish them for later use.

### Example: Sharing Artifacts Between Jobs

Here’s how you can create, share, and use artifacts between jobs in a GitHub Actions workflow:

#### Job 1: Create and Upload Artifact

```yaml
name: CI Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Install dependencies
        run: npm install

      - name: Build project
        run: npm run build

      - name: Upload build artifact
        uses: actions/upload-artifact@v2
        with:
          name: build-artifact
          path: build/
```

#### Job 2: Download and Use Artifact

```yaml
  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Download build artifact
        uses: actions/download-artifact@v2
        with:
          name: build-artifact
          path: build/
      
      - name: Run tests
        run: npm test -- --build-path build/
```

In this example:
- The `build` job builds the project and uploads the `build/` directory as an artifact named `build-artifact`.
- The `test` job depends on the `build` job, downloads the `build-artifact`, and uses it to run tests.

### Example: Publishing Artifacts

To make artifacts available for download after a workflow completes, you can use the `actions/upload-artifact` action. The artifacts will be stored and can be accessed through the GitHub Actions interface.

```yaml
name: CI Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Install dependencies
        run: npm install

      - name: Build project
        run: npm run build

      - name: Upload build artifact
        uses: actions/upload-artifact@v2
        with:
          name: build-artifact
          path: build/
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v2
        with:
          name: test-results
          path: test-results/
```

In this example:
- The `build` job uploads the build artifact.
- The `build` job also uploads test results (if they exist) as a separate artifact, even if the job fails (`if: always()`).

### Downloading Artifacts After Workflow Completion

After the workflow runs, you can download the artifacts from the GitHub Actions interface:

1. Navigate to the Actions tab in your repository.
2. Select the workflow run you are interested in.
3. Scroll down to the "Artifacts" section.
4. Click on the artifact you want to download.

### Example: Full Workflow Using Artifacts

Combining the above steps, here’s a full example of a workflow that builds, tests, and deploys a project using artifacts:

```yaml
name: CI Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Install dependencies
        run: npm install

      - name: Build project
        run: npm run build

      - name: Upload build artifact
        uses: actions/upload-artifact@v2
        with:
          name: build-artifact
          path: build/
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v2
        with:
          name: test-results
          path: test-results/

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Download build artifact
        uses: actions/download-artifact@v2
        with:
          name: build-artifact
          path: build/

      - name: Run tests
        run: npm test -- --build-path build/

  deploy:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Download build artifact
        uses: actions/download-artifact@v2
        with:
          name: build-artifact
          path: build/

      - name: Deploy to server
        run: |
          echo "Deploying to server"
          scp -r build/ user@server:/path/to/deploy
        env:
          SERVER_USERNAME: ${{ secrets.SERVER_USERNAME }}
          SERVER_PASSWORD: ${{ secrets.SERVER_PASSWORD }}
          DEPLOY_PATH: ${{ vars.DEPLOY_PATH }}
```

In this example:
- The `build` job builds the project and uploads the build output and test results as artifacts.
- The `test` job downloads the build artifact and runs tests.
- The `deploy` job downloads the build artifact and deploys it to a server, using secrets for secure credentials.

This approach ensures that each job can access the necessary artifacts from previous jobs, and artifacts can be retained for future reference.
