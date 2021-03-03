Allows you to use the [GitHub Package Registry as a proxy](https://github.blog/2019-09-11-proxying-packages-with-github-package-registry-and-other-updates/) for npm operations _(install, publish, etc ...)_ so you don't have to manually distinguish between internal dependencies registry url and public ones.

## Usage

```yaml
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

| input              | required | default                          | description                                                             |
| ------------------ | -------- | -------------------------------- | ----------------------------------------------------------------------- |
| token              | ❌        | `${{ github.token }}`            | the token to use with npm cli                                           |
| scope              | ❌        | `${{ github.repository_owner }}` | the "npm scope", typically this will be your GitHub username / org name |
| path               | ❌        | `${{ github.workspace }}/.npmrc` | where to store the `.npmrc` file                                        |
| export_user_config | ❌        | `false`                          | export the path to `.npmrc` as `NPM_CONFIG_USERCONFIG`                  |

> _**Note**: your github token should have the [appropriate scopes](https://docs.github.com/en/packages/guides/about-github-container-registry#about-scopes-and-permissions-for-github-container-registry)_
