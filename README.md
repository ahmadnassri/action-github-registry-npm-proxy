# GitHub Package Registry as a proxy

sets up an .npmrc file that points to GPR as a proxy

[![license][license-img]][license-url]
[![release][release-img]][release-url]
[![super linter][super-linter-img]][super-linter-url]
[![semantic][semantic-img]][semantic-url]

Allows you to use the [GitHub Package Registry as a proxy](https://github.blog/2019-09-11-proxying-packages-with-github-package-registry-and-other-updates/) for npm operations *(install, publish, etc ...)* so you don't have to manually distinguish between internal dependencies registry url and public ones.

## Usage

``` yaml
on:
  push:
    branches: [ master ]

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: configure npm registry proxy
        uses: ahmadnassri/action-github-registry-npm-proxy@v2
        with:
          token: ${{ secrets.my-personal-access-token }}
          scope: ${{ github.repository_owner }}
          path: ${{ github.workspace }}/.npmrc
          export_user_config: true
```

### Inputs

| input                | required | default                          | description                                                             |
|----------------------|----------|----------------------------------|-------------------------------------------------------------------------|
| token                | ❌        | `${{ github.token }}`            | the token to use with npm cli                                           |
| scope                | ❌        | `${{ github.repository_owner }}` | the "npm scope", typically this will be your GitHub username / org name |
| path                 | ❌        | `${{ github.workspace }}/.npmrc` | where to store the `.npmrc` file                                        |
| export\_user\_config | ❌        | `false`                          | export the path to `.npmrc` as `NPM_CONFIG_USERCONFIG`                  |

> ***Note**: your github token should have the [appropriate scopes](https://docs.github.com/en/packages/guides/about-github-container-registry#about-scopes-and-permissions-for-github-container-registry)*

----
> Author: [Ahmad Nassri](https://www.ahmadnassri.com/) &bull;
> Twitter: [@AhmadNassri](https://twitter.com/AhmadNassri)

[license-url]: LICENSE
[license-img]: https://badgen.net/github/license/ahmadnassri/action-github-registry-npm-proxy

[release-url]: https://github.com/ahmadnassri/action-github-registry-npm-proxy/releases
[release-img]: https://badgen.net/github/release/ahmadnassri/action-github-registry-npm-proxy

[super-linter-url]: https://github.com/ahmadnassri/action-github-registry-npm-proxy/actions?query=workflow%3Asuper-linter
[super-linter-img]: https://github.com/ahmadnassri/action-github-registry-npm-proxy/workflows/super-linter/badge.svg

[semantic-url]: https://github.com/ahmadnassri/action-github-registry-npm-proxy/actions?query=workflow%3Arelease
[semantic-img]: https://badgen.net/badge/📦/semantically%20released/blue
