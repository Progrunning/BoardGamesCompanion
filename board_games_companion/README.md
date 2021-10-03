# Branching Strategy & App Release Process

Any changes that are ready to be released should be PR'd into the `release` branch, which is a gateway to verify the app in TestFlight and Google Play Store. Once the new build of the app is tested respectively on the Apple's and Google's platforms then release notes should be written and the app should be submitted for a review. After approval on both platforms the app can be released.

NOTE: Release should happen simultaneously on both platforms.

The release process on iOS and Android devices should be followed by

1. Creating a PR into the `main` branch
2. Creating a release in the Github
 - The release should include and overview of the changes made in this release

## Pipelines

CI and CD pipelines are defined in the Microsft Azure DevOps environment. 

### CI

**C**ontinuous **I**ntegration pipeline is triggered everytime a PR is created that targets `release` branch. This assures that code that is prepared for a release is veriefied and working.

### CD

**C**ontinuous **D**eployment pipeline is associated with the `release` pipeline. After a successful merge of changes into this branch a version of a new app will be created. 

#### iOS

New app version will be pushed into the *TestFlight*.

#### Android

New app version will be pushed into the Google Play Store.


# Running Hive Generator

The command to generate hive files is:
`flutter packages pub run build_runner build -v --delete-conflicting-outputs`

Sometimes when the generation fails you might need to add this parameter `--delete-conflicting-outputs` in order to delete conflicting files

# App Mockups

The Google Play Store and Apple Store mockups are locate in the `assets/mockups/` directory. The file `*.mockup` file contains all the screenshots and different devices mockups.

Go to https://studio.app-mockup.com/ and `Load` the `*.mockup` file in order to update mockups. Once finished with editing `Save` the new `*.mockup` file and update it in the repo.