# Branching Strategy & App Release Process

This repository tries to follow the [*trunk based development*](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development), where developers merge frequently to the `main` branch.

## Contributing

In order to contribute to the project, please follow the below steps:
1. Clone or fork the repository
 - `git clone https://github.com/Progrunning/BoardGamesCompanion.git`
2. Grab latest code from the `main` branch 
 - `git checkout main`
 - `git pull`
3. Create a feature branch from the `main`
 - `git checkout -b feature/<short_feature_description>`
4. After the implementation is done push the change to Github's repository
- `git push --set-upstream origin feature/<short_feature_description>`
5. Create a PR (TODO: Create steps to create a PR)

The feature branches should have the following naming convention `feature/<short_feature_description>`.

## Hotfix

In case of a need for a hotfix, the branch with a fix should be branched off of the latest release's tag. The branch itself should have the following naming convention `hotfix\<short_fix_description>`.

Any changes that are ready to be released should be PR'd into the `release` branch, which is a gateway to verify the app in TestFlight and Google Play Store. Once the new build of the app is tested respectively on the Apple's and Google's platforms then release notes should be written and the app should be submitted for a review. After approval on both platforms the app can be released.

NOTE: Release should happen simultaneously on both platforms.

The release process on iOS and Android devices should be followed by

1. Creating a PR into the `main` branch
2. Creating a release in the Github
 - The release should include an overview of the changes made in this release

## Pipelines

CI and CD pipelines are defined in the Microsft Azure DevOps environment. 

### CI

**C**ontinuous **I**ntegration pipeline is triggered everytime a PR is created that targets `release` branch. This assures that code that is prepared for a release is veriefied and working.

[![Build Status](https://progrunning.visualstudio.com/Board%20Games%20Companion/_apis/build/status/CI?branchName=main)](https://progrunning.visualstudio.com/Board%20Games%20Companion/_build/latest?definitionId=20&branchName=main)

### CD

**C**ontinuous **D**eployment pipeline is associated with the `release` pipeline. After a successful merge of changes into this branch a version of a new app will be created. 

[![Build Status](https://progrunning.visualstudio.com/Board%20Games%20Companion/_apis/build/status/CD?branchName=main)](https://progrunning.visualstudio.com/Board%20Games%20Companion/_build/latest?definitionId=19&branchName=main)
#### iOS

New app version will be pushed into the *TestFlight*.

#### Android

New app version will be pushed into the Google Play Store.


# Code generation

The command to auto generate files `flutter packages pub run build_runner build -v --delete-conflicting-outputs`. The following are libraries using auto generated code:

- hive
- injactable

NOTE: Adding `--delete-conflicting-outputs` parameter fixes problems with conflicting files.

# App Mockups

The Google Play Store and Apple Store mockups are locate in the `assets/mockups/` directory. The file `*.mockup` file contains all the screenshots and different devices mockups.

Go to https://studio.app-mockup.com/ and `Load` the `*.mockup` file in order to update mockups. Once finished with editing `Save` the new `*.mockup` file and update it in the repo.