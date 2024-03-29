<p align="center">  
    <img src="https://github.com/Progrunning/BoardGamesCompanion/blob/main/board_games_companion/assets/icons/logo_transparent.png?raw=true" height="128"/>  
  <h1 align="center">Board Games Companion</h1>
</p>

<p align="center">
  <a href="https://progrunning.visualstudio.com/Board%20Games%20Companion/_build?definitionId=24&_a=summary">
    <img src="https://img.shields.io/azure-devops/build/progrunning/cf1ca5c2-9446-441f-b3af-6e9f951997cf/24/main?label=CI">
  </a>
  <a href="https://progrunning.visualstudio.com/Board%20Games%20Companion/_build?definitionId=19&_a=summary">
    <img src="https://img.shields.io/azure-devops/build/progrunning/cf1ca5c2-9446-441f-b3af-6e9f951997cf/19/main?label=CD">
  </a>  
  <a href="https://github.com/Progrunning/BoardGamesCompanion/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/progrunning/BoardGamesCompanion">
  </a>
</p>

# Overview

Welcome to the official **Board Games Companion** Github repository - an open source [iOS](https://apps.apple.com/us/app/board-games-companion/id1506458832?ls=1) and [Android](https://play.google.com/store/apps/details?id=com.progrunning.boardgamescompanion) application dedicated to board games enthusiasts.

For more information about the application and its features please visit our [Wiki pages](https://github.com/Progrunning/BoardGamesCompanion/wiki).

# Discussion

If you have an idea about how the app could be improved, you ran into a problem or maybe you want to check what's currently in the works then join the  [Discord](https://discord.gg/t9dTVXxnvC) server to chat with the development team and other BGC users.

# Contributing

The iOS and Android mobile applications are written in [Dart language](https://dart.dev/), using a cross-platform framework [Flutter](https://flutter.dev/). In order to contribute to the project one needs to have working Flutter environemnt on their machines.

## Getting Started

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

The feature branches should have the following naming convention `feature/<short_feature_description>`. See below section for more information.

## Branching Strategy & App Release Process

This repository follows the [*trunk based development*](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development), where developers merge frequently to the `main` branch from their `feature/*` branches.

## Hotfix

In case of a need for a hotfix, the branch with a fix should be branched off of the latest release's tag. The branch itself should have the following naming convention `hotfix\<short_fix_description>`. After the hotfix gets released the `hotfix/*` branch gets merged into the `main`.

## Release

Every merged PR into the `main` branch triggers the [CD pipeline](#CD), which pushes out app packages to  *TestFlight* and *Google Play Store Beta* respectivly for iOS and Android. All of these releases are considered release canidates but not all might get released to the production.

NOTE: Release should happen simultaneously on both platforms.

### Before

Steps to follow before releasing apps to stores (i.e. production):

1. Update version of the app in the pipeline(s) to match what the released version should be
2. Test the core functionality of the application on an iOS and Android device using the beta version of the app
3. Update the release notes in Android and iOS stores
4. Submit iOS and Android applications for a store review

### After

The release to the iOS and Android stores should be followed by:

1. Creating a new version tag
2. Creating a release in the Github
 - The release should include an overview of the changes made in this release

### iOS

#### CocoaPods

Package managing on iOS is uber complex and sometimes might not make much sense. Please see this [intro YT video on CocoaPods](https://www.youtube.com/watch?v=iEAjvNRdZa0).

To put it "simply" there are a few steps and dependencies when working with CocoaPods:

1. Homebrew
A "default" package manager "to rule them all", which comes handy if you need to get an app/library from the internet. Go to [how to install](https://docs.brew.sh/Installation), to get it on your mac.

[Optional] Run `brew update` to update Homebrew, if you already have it.

> REQUIRED: To install RubyGems and other stuff

2. RubyGems
RubyGems is (you guess it) another package manager and is required to get CocoaPods. MacOS comes with a pre-installed version of it but it is recommended to update it, which can be done by executing the following:

`sudo gem update --system`

Whenever there's a need to update Ruby it is recommended to use [`rbenv`](https://github.com/rbenv/rbenv) or [`rvm`](https://rvm.io/rvm/about), both of which are a version manager tool for Ruby.

You can check Ruby's version by executing command `ruby -v`. 

3. Ruby Manager Tool

*rvm*: The tool can be installed by executing in terminal the following `curl -L https://get.rvm.io | bash -s stable`. After that updating Ruby is done by executing `rvm install ruby-<version_number>`.

*rbenv*: Install using Homebrew `brew install rbenv ruby-build`. Update ruby by executing `rbenv install <version_number>`

> !IMPORTANT!: Manager commands executed on M1 chips macs need to be prefixed with `arch arm64 ...`.

4. CocoaPods
Download CocoaPods using RubyGems by executing the following

`sudo gem install cocoapods`

> NOTE: The same can be used to update cocoapods

To install all of the dependencies/packages execute `pod install` command.

#### Flutter upgrade
s
Whenever flutter version gets updated there might be a problem with plugin dependencies. This might require updating `pods`. In order to update pods you need to:

1. Run Terminal
2. Open iOS folder directory (e.g. `cd /path/to/the/project/board_games_companion/ios`)
3. Run `pod install` command (`arch -arm64 pod install` on macs with M1 chip)

Additionally there will be a need to update the `PATH` of the Z shell. This can be done by doing the following:

1. Ensuring that the `~/.zhrc` file exists (`touch ~/.zshrc`)
2. Editing the file by existing one of the following
 - `vim ~/.zshrc`
 - `code ~/.zshrc`
3. Editing the `PATH` with the path to the update Flutter SDK

> NOTE: More info in this [SO thread](https://stackoverflow.com/questions/10574684/where-to-place-path-variable-assertions-in-zsh) and in the [official docs](https://docs.flutter.dev/get-started/install/macos#update-your-path)

#### M1 processors shenanigans

You may run into issues with updating pods on M1 processor devices. Here's some articles that might help with that:

- https://stackoverflow.com/a/65334677
- https://stackoverflow.com/a/64997047

Installing or updating pods on M1 chip (i.e. `arm64`) is done with the following commands `arch -arm64 pod install` and `arch -arm64 pod update`

Generally speaking try using **homebrew** to manage cocoapods. The command `brew install cocoapods` will not work on the **M1 processor devives** therefore you should run `arch -arm64 brew install cocoapods`.

> NOTE: In case an FFI requires updating try executing this command `sudo arch -arm64 gem install ffi`

# Pipelines

CI and CD pipelines are defined in the Microsft Azure DevOps environment. 

## CI

**C**ontinuous **I**ntegration pipeline is triggered everytime a PR is created that targets `release` branch. This assures that code that is prepared for a release is veriefied and working.

[![Build Status](https://progrunning.visualstudio.com/Board%20Games%20Companion/_apis/build/status/CI?branchName=main)](https://progrunning.visualstudio.com/Board%20Games%20Companion/_build/latest?definitionId=20&branchName=main)

## CD

**C**ontinuous **D**eployment pipeline is associated with the `release` pipeline. After a successful merge of changes into this branch a version of a new app will be created. 

[![Build Status](https://progrunning.visualstudio.com/Board%20Games%20Companion/_apis/build/status/CD?branchName=main)](https://progrunning.visualstudio.com/Board%20Games%20Companion/_build/latest?definitionId=19&branchName=main)
### iOS

New app version will be pushed into the *TestFlight*.

### Android

New app version will be pushed into the *Google Play Store*.

# Code generation

Use the following command to auto-generate files `flutter packages pub run build_runner build -v --delete-conflicting-outputs`. The below libraries rely on the auto generated files

- hive
- injactable
- mobx

> NOTE: Adding `--delete-conflicting-outputs` parameter fixes problems with conflicting files.

# App Mockups

The Google Play Store and Apple Store listing images were created with the use of a free mockup tool https://studio.app-mockup.com/.

The mockups are located in the `assets/mockups/` directory in the repository. The file `*.mockup`  contains all the screenshots and different devices mockups.

## Update

Follow the below steps to update the mockups:

1. Go to https://studio.app-mockup.com/
2. Click `Load` button in the top left corner
3. Select the `*.mockup` file from the repository - ensure that you have latest code. 
4. Edit
5. Click `Save` button in the top left corner
6. A new `*.mockup` file should saved in place of the existing one in the repo
