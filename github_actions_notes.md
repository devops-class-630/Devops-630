GitHub Actions can be triggered by a variety of events, including pushes to the repository, pull requests, schedule intervals, and more. Here are some common examples:

### Trigger on Push

```yaml
name: CI

on:
  push:
    branches:
      - main
      - 'feature/*'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run a script
      run: echo "This runs on push to main or feature branches"
```

### Trigger on Pull Request

```yaml
name: CI

on:
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run a script
      run: echo "This runs on pull request to main"
```

### Scheduled Trigger (Cron)

```yaml
name: Scheduled Job

on:
  schedule:
    - cron: '0 0 * * *' # Every day at midnight

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run a script
      run: echo "This runs every day at midnight"
```

### Trigger on Release

```yaml
name: Release CI

on:
  release:
    types: [published]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run a script
      run: echo "This runs on release publish"
```

### Trigger on Issue Creation

```yaml
name: Issue Created

on:
  issues:
    types: [opened]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run a script
      run: echo "This runs when a new issue is created"
```

### Trigger on Workflow Dispatch (Manual Trigger)

```yaml
name: Manual Trigger

on:
  workflow_dispatch:
    inputs:
      name:
        description: 'Person to greet'
        required: true
        default: 'World'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Run a script
      run: echo "Hello ${{ github.event.inputs.name }}"
```

These examples demonstrate different ways to trigger GitHub Actions workflows based on various events. You can combine and customize these triggers to fit your specific use case.
