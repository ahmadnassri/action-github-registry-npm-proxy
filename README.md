# GitHub Package Registry as a proxy

sets up an .npmrc file that points to GPR as a proxy

[![license][license-img]][license-url]
[![release][release-img]][release-url]

Allows you to use the [GitHub Package Registry as a proxy][] for npm operations *(install, publish, etc ...)* so you don't have to manually distinguish between internal dependencies registry url and public ones.

## Why

**Doesn't [`@actions/setup-node`][] already do this?**

No, the `setup-node` action results in an `.npmrc` file that looks like this:

``` ini
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
@scope:registry=https://npm.pkg.github.com
```

This means that npm will continue to use the public npm registry for any packages NOT under the defined `@scope`.

If you want to use GitHub Package Registry as a proxy to the default npm registry, you need to use an `.npmrc` file that looks like this:

``` ini
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
registry=https://npm.pkg.github.com/scope/
```

**Why is this useful?**

- Tighter control on publishing packages: never make the mistake of publishing to the `npmjs.com` registry! *(it just wont work)*
- No need to manually distinguish between internal dependencies registry url and public ones in your config / ci
- potential performance boost by using the GitHub registry as a proxy *(can't find any documentation on this to verify, but my own observations confirm it)*

## Usage

###### Example

use github registry for internal packages, and public registry for everything else

``` yaml
on: push

jobs:
  npm:
    steps:
      - uses: actions/checkout@v3
      - uses: ahmadnassri/action-github-registry-npm-proxy@v5
      - run: npm ci
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

> ###### result: `.npmrc`
>
> ``` ini
> //npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
> registry=https://npm.pkg.github.com/ahmadnassri/
> ```

> **Warning**  
> you should specify a token value if you're installing private packages  
> or packages from other repositories within the same org

###### Example

set a custom path to `.npmrc` file and export it as `NPM_CONFIG_USERCONFIG` environment variable

``` yaml
- uses: ahmadnassri/action-github-registry-npm-proxy@v5
  with:
    path: ./path-to-package/.npmrc
    export_config: true

- run: npm ci
  working-directory: ./path-to-package
  env:
    NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

> ###### result: `./path-to-package/.npmrc`
>
> ``` ini
> //npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
> registry=https://npm.pkg.github.com/ahmadnassri
> ```

###### Example

don't use the proxy, just set the registry url to the github registry for current scope

``` yaml
- uses: ahmadnassri/action-github-registry-npm-proxy@v5
  with:
    proxy: false
```

> **Note**  
> this is the same as using [`@actions/setup-node`][] with `registry-url` option

###### result: `.npmrc`

``` ini
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
@ahmadnassri:registry=https://npm.pkg.github.com
```

###### Example

custom scope (e.g. packages from another github account/org)

``` yaml
- uses: ahmadnassri/action-github-registry-npm-proxy@v5
  with:
    scope: '@my-org'
    token: ${{ secrets.github-personal-access-token }}
```

###### result: `.npmrc`

``` ini
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
registry=https://npm.pkg.github.com/@my-org/
```

### Inputs

| input         | required | default                          | description                                                             |
|---------------|----------|----------------------------------|-------------------------------------------------------------------------|
| scope         | ❌       | `${{ github.repository_owner }}` | the "npm scope", typically this will be your GitHub username / org name |
| path          | ❌       | `${{ github.workspace }}/.npmrc` | where to store the `.npmrc` file                                        |
| export_config | ❌       | `false`                          | export the path to `.npmrc` as `NPM_CONFIG_USERCONFIG`                  |
| token         | ❌       | `NODE_AUTH_TOKEN`                | environment variable name for the registry token                        |
| proxy         | ❌       | `true`                           | enable/disable the GitHub npm packages proxy for npm                    |

> **Warning**
> Your github token should have the [appropriate scopes][] to be able to install private packages

  [GitHub Package Registry as a proxy]: https://github.blog/2019-09-11-proxying-packages-with-github-package-registry-and-other-updates/
  [`@actions/setup-node`]: https://github.com/actions/setup-node
  [appropriate scopes]: https://docs.github.com/en/packages/learn-github-packages/about-permissions-for-github-packages#about-scopes-and-permissions-for-package-registries

----
> Author: [Ahmad Nassri](https://www.ahmadnassri.com/) &bull;
> Twitter: [@AhmadNassri](https://twitter.com/AhmadNassri)

[license-url]: LICENSE
[license-img]: https://badgen.net/github/license/ahmadnassri/action-github-registry-npm-proxy

[release-url]: https://github.com/ahmadnassri/action-github-registry-npm-proxy/releases
[release-img]: https://badgen.net/github/release/ahmadnassri/action-github-registry-npm-proxy
