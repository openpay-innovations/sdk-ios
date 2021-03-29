# ADR-0002: SDK Setup

## Xcode Build Settings
### Context
By default Xcode stores build settings internally within Xcode project files. Build settings are applied at a project and target level. Targets can inherit, augment and override project level settings.

The Xcode build settings editor GUI is quite flexible and easy to use but managing settings across multiple targets and projects can quickly become unweildly and prone to error.

### Decision
We decided to do the following for the SDK project:
- Use `.xcconfig` files for the Xcode build setting configuration.
- Keep all the `.xcconfig` files in `Configurations` folder.
- Use the script `validate-build-settings` in the Build Phase to ensure there are no build settings within the Xcode Project file.

## Minimum SDK Version
### Context
It is important to determine the minimum deployment version for the iOS SDK.

### Decision
We will initially target the most recent public release of **iOS (v13.0)** as a minimum deployment target because at the time of writing, we have not been informed of any specific merchant who needs the lower version.

Supporting iOS 13 and later brings us the following benefits:
- Xcode 12+ supports SVG images in Assets.catalog
- Swift 5.3+ localises resources in swift packages e.g. `localizable.string`

## Mint
### Context
The SDK project uses Swift command line tools such as SwiftLint to support development. However, it is cumbersome to manage all the third-party tooling by ourselves. 
There are some downsides of downloading a binary or installing it via Homebrew:
- Unable to specify the exact version to use
- The repository may end up with many large binary blobs

### Decision
In order to solve the issues mentioned above, we decided to use [`Mint`](https://github.com/yonaskolb/Mint) as our Swift command line package manager.

- SwiftLint and many other popular tools can be installed using `mint`. All the third-party tools are listed in the [`Mintfile`]().

- Developers can run the [Scripts/bootstrap-tools]() script to install all the Swift command line tool packages before the first build to speed up the build time.

- Developers do not need to install `mint` manually as an extra step because a pre-compiled Mint executable file is included under the directory [Tools/mint]().

