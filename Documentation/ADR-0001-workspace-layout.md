# ADR-0001: Workspace Layout

## Context
This ADR defines a top level folder structure for the iOS project repository. A well-defined structure makes it very clear where to find or put sources, scripts or tests.

## Decision
The workspace folder structure will be as follows:

### Naming Conventions
In general, files and folders should be short single words with a capitalized first letter. E.g. `Sources`, `TestPlans`, `Support`, etc.

Filenames that are in all uppercase  will be used when necessary to draw attention to those files or when it is the common idiom to do so. E.g, `README`, `CONTRIBUTING` etc.

File extensions should always be lowercase. E.g. `README.md`.

### Top Level Folders
Below is a list of the folders located at the top level of the repository.
- `.git/` - Git SCM data and configuration
- `.github/` - GitHub related configuration
  - Issue template
  - Pull request template
  - Workflows for Github Action
  - CODEOWNERS
  - CONTRIBUTING.md
  - Release drafter
- `Configurations` - All the .xcconfig files for the SDK project
- `Support`
  - `Scripts` 
    - `BuildPhase` - Scripts invoked as 'Run Script' Build Phases within Xcode's build process
    - `CI` - Scripts invoked by CI/CD pipelines
  - `Images` - Images displayed in README.md
- `Tools` - Tool binaries, such as `mint`
- `Sources` - Source code for the SDK project
- `TestPlans` - Test plans for the SDK project
- `OpenpayTests` - Tests for the SDK project
- `Example` - Source code for the Example App project

### Xcode Workspace Structure
`Openpay.xcworkspace` includes two projects, the Openpay SDK project and the Example project. It also has two schemes, one for the SDK, and one for the Example App.

The structure is to be layered as follows:
| Project | | | \| | Type |
| :---: | :---: | :---: | :---: | :---: |
| `Openpay` | | | \| | SDK Framework |
| `Example` | | | \| | Example Application |

The Example Application will import and use the SDK framework, but not the other way around!


## Consequences
The folder structure standard needs to be followed. Changes to this structure should be documented in additional ADRs.