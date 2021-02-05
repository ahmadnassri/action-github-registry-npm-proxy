#!/bin/bash
set -euo pipefail

npm config --userconfig "${1}" .npmrc set registry="https://npm.pkg.github.com/${2}"
npm config --userconfig "${1}" .npmrc set //npm.pkg.github.com/:_authToken "${3}"
npm config --userconfig "${1}" .npmrc set always-auth true
