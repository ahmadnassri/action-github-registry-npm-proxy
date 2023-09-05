Allows you to use the [GitHub Package Registry as a proxy][blog] for npm operations _(install, publish, etc ...)_ so you don't have to manually distinguish between internal dependencies registry url and public ones.

## Why

**Doesn't [`@actions/setup-node`] already do this?**

No, the `setup-node` action results in an `.npmrc` file that looks like this:

```ini
//npm.pkg.github.com/:_authToken=XXXXX-XXXXX-XXXXX-XXXXX
@scope:registry=https://npm.pkg.github.com
```

This means that npm will continue to use the public npm registry for any packages NOT under the defined `@scope`.

If you want to use GitHub Package Registry as a proxy to the default npm registry, you need to use an `.npmrc` file that looks like this:

```ini
//npm.pkg.github.com/:_authToken=XXXXX-XXXXX-XXXXX-XXXXX
registry=https://npm.pkg.github.com/scope/
```

**Why is this useful?**

- Tighter control on publishing packages: never make the mistake of publishing to the `npmjs.com` registry! _(it just wont work)_
- No need to manually distinguish between internal dependencies registry url and public ones in your config / ci
- potential performance boost by using the GitHub registry as a proxy _(can't find any documentation on this to verify, but my own observations confirm it)_

## Usage

###### Example

use github registry for internal packages, and public registry for everything else

```yaml
on: push

jobs:
  npm:
    steps:
      - uses: actions/checkout@v3
      - uses: ahmadnassri/action-github-registry-npm-proxy@v3
```

> ###### result: `.npmrc`
>
> ```ini
> //npm.pkg.github.com/:_authToken=XXX-XXX
> registry=https://npm.pkg.github.com/ahmadnassri/
> ```

> **Warning**  
> this will use the [GitHub Action Token][action-token] by default!  
> you might want to specify a token value if you're installing private packages  
> or packages from other repositories within the same org

###### Example

set a custom path to `.npmrc` file and export it as `NPM_CONFIG_USERCONFIG` environment variable

```yaml
- uses: ahmadnassri/action-github-registry-npm-proxy@v2
  with:
    path: ./path-to-package/.npmrc
    export_config: true
```

> ###### result: `./path-to-package/.npmrc`
>
> ```ini
> //npm.pkg.github.com/:_authToken=XXX-XXX
> registry=https://npm.pkg.github.com/ahmadnassri
> ```

###### Example

don't use the proxy, just set the registry url to the github registry for current scope

```yaml
- uses: ahmadnassri/action-github-registry-npm-proxy@v2
  with:
    proxy: false
```

> **Note**  
> this is the same as using [`@actions/setup-node`] with `registry-url` option

###### result: `.npmrc`

```ini
//npm.pkg.github.com/:_authToken=XXX-XXX
@ahmadnassri:registry=https://npm.pkg.github.com
```

###### Example

custom scope (e.g. packages from another github account/org)

```yaml
- uses: ahmadnassri/action-github-registry-npm-proxy@v2
  with:
    scope: "@my-org"
    token: ${{ secrets.github-personal-access-token }}
```

###### result: `.npmrc`

```ini
//npm.pkg.github.com/:_authToken=XXX-XXX
registry=https://npm.pkg.github.com/@my-org/
```

### Inputs

| input         | required | default                          | description                                                             |
| ------------- | -------- | -------------------------------- | ----------------------------------------------------------------------- |
| token         | ❌       | `${{ github.token }}`            | the token to use with npm cli                                           |
| scope         | ❌       | `${{ github.repository_owner }}` | the "npm scope", typically this will be your GitHub username / org name |
| path          | ❌       | `${{ github.workspace }}/.npmrc` | where to store the `.npmrc` file                                        |
| export_config | ❌       | `false`                          | export the path to `.npmrc` as `NPM_CONFIG_USERCONFIG`                  |
| proxy         | ❌       | `true`                           | enable/disable the GitHub npm packages proxy for npm                    |

> **Warning**
> Your github token should have the [appropriate scopes][token-scopes] to be able to install private packages

[blog]: https://github.blog/2019-09-11-proxying-packages-with-github-package-registry-and-other-updates/
[action-token]: https://docs.github.com/en/actions/security-guides/automatic-token-authentication
[`@actions/setup-node`]: https://github.com/actions/setup-node
[token-scopes]: https://docs.github.com/en/packages/learn-github-packages/about-permissions-for-github-packages#about-scopes-and-permissions-for-package-registries
