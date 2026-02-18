#!/usr/bin/env bash
# Initialize submodules and install dependencies
set -e
git submodule update --init --recursive
pnpm install
