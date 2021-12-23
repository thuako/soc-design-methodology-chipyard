#!/bin/bash


chip_dir=$PWD
git submodule sync
cd generators/gemmini
git pull
git checkout -t origin/soc-chipyard-base
git submodule sync
git software/gemmini-rocc-tests
git pull
git checkout -t origin/soc-chipyard-base

cd $chip_dir
cp scripts/ec2-user-init.sh ~/
cd ~/
source ec2-user-init.sh


