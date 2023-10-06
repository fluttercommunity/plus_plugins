# Contributing to PlusPlugins

_See also: [Flutter's code of conduct](https://flutter.dev/design-principles/#code-of-conduct)_

## Types of contributions

We welcome all contributions to the project, however some contributions will need extra work in
order to be accepted.

Here's some examples:

### 🟢 Easily accepted contributions

- Fixing issues
- Improving the README.md
- Upgrading deprecated dependencies
- Improving tests

### 🟡 Need extra consideration

- New features covering all platforms

We need to make sure it works well before merging and each platform needs to be reviewed individually.

- Changing a platform implementation

Ideally an expert in that platform will have to review the change to make sure it works as expected.

### 🔴 Cannot be accepted

- New features covering only one platform

New features should cover at least the mobile platforms (Android and iOS) to be considered,
and a plan for the rest must be provided.

- New plugins

We don't have the capacity to accept new plugins.

# Setup and running

Please follow this steps when working on the PlusPlugins.

## 1. Things you will need

- Linux, Mac OS X, or Windows.
- [git](https://git-scm.com) (used for source version control).
- An ssh client (used to authenticate with GitHub).
- An IDE such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/).
- [`flutter_plugin_tools`](https://pub.dev/packages/flutter_plugin_tools) locally activated.
- [`tuneup`](https://pub.dev/packages/tuneup) locally activated.

## 2. Forking & cloning the repository

- Ensure all the dependencies described in the previous section are installed.
- Fork `https://github.com/fluttercommunity/plus_plugins` into your own GitHub account. If
  you already have a fork, and are now installing a development environment on
  a new machine, make sure you've updated your fork so that you don't use stale
  configuration options from long ago.
- If you haven't configured your machine with an SSH key that's known to github, then
  follow [GitHub's directions](https://help.github.com/articles/generating-ssh-keys/)
  to generate an SSH key.
- `git clone git@github.com:<your_name_here>/plus_plugins.git`
- `git remote add upstream git@github.com:fluttercommunity/plus_plugins.git` (So that you
  fetch from the master repository, not your clone, when running `git fetch`
  et al.)

## 3. Environment Setup

PlusPlugins uses [Melos](https://github.com/invertase/melos) to manage the project and dependencies.

To install Melos, run the following command from your SSH client:

```bash
flutter pub global activate melos
```

Next, at the root of your locally cloned repository bootstrap the projects dependencies:

```bash
melos bootstrap
```

The bootstrap command locally links all dependencies within the project without having to
provide manual [`dependency_overrides`](https://dart.dev/tools/pub/pubspec). This allows all
plugins, examples and tests to build from the local clone project.

> You do not need to run `flutter pub get` once bootstrap has been completed.

## 4. Running an example

Each plugin provides an example app which aims to showcase the main use-cases of each plugin.

To run an example, run the `flutter run` command from the `example` directory of each plugins main
directory. For example, for `sensors_plus` example:

```bash
cd packages/sensors_plus/sensors_plus/example
flutter run
```

Using Melos (installed in step 3), any changes made to the plugins locally will also be reflected within all
example applications code automatically.

## 4. Running tests

PlusPlugins comprises of a number of tests for each plugin, either end-to-end (e2e) or unit tests.

### Unit tests

Unit tests are responsible for ensuring expected behavior whilst developing the plugins Dart code. Unit tests do not
interact with 3rd party services, and mock where possible. To run unit tests for a specific plugin, run the
`flutter test` command from the plugins root directory. For example, sensors_plus platform interface tests can be run
with the following commands:

```bash
cd packages/sensors_plus/sensors_plus
flutter test
```

### End-to-end (e2e) tests

E2e tests are those which directly communicate with Flutter, whose results cannot be mocked. **These tests run directly from
an example application.**

To run e2e tests, run the `flutter test` command from the plugins main `example` directory, and provide the path to the
e2e test file. For example, to run the `sensors_plus` e2e tests:

#### Mobile

```bash
cd packages/sensors_plus/sensors_plus/example
flutter test integration_test/sensors_plus_test.dart
```

#### Web

To run tests against web environments, you will need to have Chrome and ChromeDriver installed and use the `flutter drive` command.

First start ChromeDriver on port 4444:

```bash
chromedriver --port=4444
```

Then go to the `example` directory of the plugin you want to test and run the `flutter drive` command
with the specific driver and `*_web_test.dart` target. For example, to run the `package_info_plus` web tests:

```bash
cd packages/package_info_plus/package_info_plus/example
flutter drive \
  --driver ./integration_test/driver.dart \
  --target ./integration_test/package_info_plus_web_test.dart \
  -d chrome
```

### Using Melos

To help aid developer workflow, Melos provides a number of commands to quickly run
tests against plugins. For example, to run all e2e tests across all plugins at once,
run the following command from the root of your cloned repository:

```bash
# for mobile testing (Android or iOS)
melos run test:mobile_e2e
```

A full list of all commands can be found within the [`melos.yaml`](https://github.com/fluttercommunity/plus_plugins/blob/main/melos.yaml)
file.

## 5. Contributing code

We gladly accept contributions via GitHub pull requests.

Please peruse the
[Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) and
[design principles](https://flutter.dev/design-principles/) before
working on anything non-trivial. These guidelines are intended to
keep the code consistent and avoid common pitfalls.

### 5.1 Getting started

To start working on a patch:

1. `git fetch upstream`
2. `git checkout upstream/main -b <name_of_your_branch>`
3. Hack away!

### 5.2 Check the code

Once you have made your changes, ensure that it passes the internal analyzer & formatting checks. The following
commands can be run locally to highlight any issues before committing your code:

```bash
# Run the analyze check
melos run analyze

# Format code
melos run format
```

### 5.3 (Do not) Update version and changelog

**NEW: Do not modify the CHANGELOG.md or the version in the pubspec.yaml, this is handled by the maintainers from now on**

### 5.4 Commit and push your changes

Assuming all is successful, commit and push your code:

1. `git commit -a -m "<your informative commit message>"`
2. `git push origin <name_of_your_branch>`

### 5.5 Create a pull request

To send us a pull request:

- `git pull-request` (if you are using [Hub](http://github.com/github/hub/)) or
  go to `https://github.com/fluttercommunity/plus_plugins` and click the
  "Compare & pull request" button

Please make sure all your check-ins have detailed commit messages explaining the patch.

When naming the title of your pull request, please follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.4/)
guide. For example, for a fix to the `sensor_plus` plugin:

`fix(sensor_plus): fixed a bug!`

Please also enable **“Allow edits by maintainers”**, this will help to speed-up the review
process as well.

### 5.6 Now be patient :)

Plugins tests are run automatically on contributions using GitHub Actions. Depending on
your code contributions, various tests will be run against your updated code automatically.

Once you've gotten an LGTM from a project maintainer and once your PR has received
the green light from all our automated testing, wait for one the package maintainers
to merge the pull request.

Please understand, that this repository is run by volunteers, and the response may be delayed.

### The review process

Newly opened PRs first go through initial triage which results in one of:

- **Merging the PR** - if the PR can be quickly reviewed and looks good.
- **Closing the PR** - if the maintainer decides that the PR should not be merged.
- **Moving the PR to the backlog** - if the review requires non trivial effort and the issue isn't a priority; in this case the maintainer will:
  - Make sure that the PR has an associated issue labeled with "plugin".
  - Add the "backlog" label to the issue.
  - Leave a comment on the PR explaining that the review is not trivial and that the issue will be looked at according to priority order.
- **Starting a non trivial review** - if the review requires non trivial effort and the issue is a priority; in this case the maintainer will:
  - Add the "in review" label to the issue.
  - Self assign the PR.

### The release process

We push releases manually, using [Melos](https://github.com/invertase/melos)
to take care of the hard work.

Some things to keep in mind before publishing the release:

- Has CI ran on the master commit and gone green? Even if CI shows as green on
  the PR it's still possible for it to fail on merge, for multiple reasons.
  There may have been some bug in the merge that introduced new failures. CI
  runs on PRs as it's configured on their branch state, and not on tip of tree.
  CI on PRs also only runs tests for packages that it detects have been directly
  changed, vs running on every single package on master.
- [Publishing is
  forever.](https://dart.dev/tools/pub/publishing#publishing-is-forever)
  Hopefully any bugs or breaking in changes in this PR have already been caught
  in PR review, but now's a second chance to revert before anything goes live.
- "Don't deploy on a Friday." Consider carefully whether or not it's worth
  immediately publishing an update before a stretch of time where you're going
  to be unavailable. There may be bugs with the release or questions about it
  from people that immediately adopt it, and uncovering and resolving those
  support issues will take more time if you're unavailable.

#### Run a release...

1. Switch to `main` branch locally.
2. Run `git pull origin main`.
3. Run `git pull --tags` to make sure all tags are fetched.
4. Create new branch with the signature `release/[year]-[month]-[day]`.
5. Run `melos version --no-git-tag-version` to automatically version packages and update Changelogs.
6. Run `melos publish` to dry run and confirm all packages are publishable.
7. After successful dry run, commit all changes with the signature "chore(release): prepare for release".
8. Run `git push origin [RELEASE BRANCH NAME]` & open pull request for review on GitHub.
9. After successful review and merge of the pull request, switch to main branch locally, & run `git pull origin main`.
10. Run `melos publish --no-dry-run --git-tag-version` to now publish to Pub.dev.
11. Run `git push --tags` to push tags to repository.
