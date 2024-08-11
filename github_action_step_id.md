In GitHub Actions, you can give steps a unique `id` and reference their outputs in subsequent steps within the same job. This is useful for passing data between steps.

### Setting up Steps with IDs

You can assign an `id` to a step and use its outputs in later steps. Here’s an example workflow demonstrating this:

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

      - name: Run a script
        id: run_script
        run: echo "Hello World"

      - name: Capture output
        id: capture_output
        run: echo "::set-output name=example_output::$(echo "example_value")"

      - name: Use output from previous step
        run: echo "The output from capture_output is ${{ steps.capture_output.outputs.example_output }}"

      - name: More complex script
        id: complex_script
        run: |
          VALUE=$(echo "42")
          echo "::set-output name=complex_output::$VALUE"

      - name: Use complex output
        run: echo "The output from complex_script is ${{ steps.complex_script.outputs.complex_output }}"
```

### Detailed Explanation

1. **Step with ID `run_script`**:
   - Runs a simple script (`echo "Hello World"`).
   - This step doesn’t set any outputs, but has an ID for potential future reference.

2. **Step with ID `capture_output`**:
   - Runs a script that sets an output named `example_output` using the `::set-output` command.
   - The value of `example_output` is set to `example_value`.

3. **Step using output from `capture_output`**:
   - Accesses the output of the previous step using `${{ steps.capture_output.outputs.example_output }}`.
   - Prints the output to the console.

4. **Step with ID `complex_script`**:
   - Runs a more complex script, captures a value, and sets an output named `complex_output`.

5. **Step using output from `complex_script`**:
   - Accesses the output of the `complex_script` step using `${{ steps.complex_script.outputs.complex_output }}`.
   - Prints the output to the console.

### Real-World Example: Building, Testing, and Using Outputs

Here’s a more practical example where the build step produces an output that is used by subsequent steps:

```yaml
name: Build and Test Workflow

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
        id: build_project
        run: |
          npm run build
          echo "::set-output name=build_dir::$(pwd)/build"

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Download build artifact
        uses: actions/download-artifact@v2
        with:
          name: build-artifact
          path: ${{ needs.build.outputs.build_dir }}

      - name: Run tests
        run: npm test -- --build-path ${{ needs.build.outputs.build_dir }}
```

### Detailed Explanation

1. **Build Job**:
   - Checks out the code.
   - Sets up Node.js.
   - Installs dependencies.
   - Builds the project and sets the output `build_dir` to the build directory path.

2. **Test Job**:
   - Runs after the `build` job (using `needs: build`).
   - Downloads the build artifact using the path from `build_dir`.
   - Runs tests using the build directory path.

In this example:
- The build job sets an output `build_dir`.
- The test job uses this output to know where the build artifacts are located.

This way, you can efficiently pass data between steps and jobs within the same workflow.
