#!/bin/bash

git submodule sync
cd ~/chipyard/generators/gemmini
git reset --hard
git pull origin soc-chipyard-base
git checkout -t origin/soc-chipyard-base

git submodule sync
cd ~/chipyard/generators/gemmini/software/gemmini-rocc-tests 
git reset --hard
git pull origin soc-chipyard-base
git checkout -t origin/soc-chipyard-base



