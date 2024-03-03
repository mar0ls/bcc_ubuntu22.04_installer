#!/bin/bash

set -e

# Ask user for root password
echo -n "Enter your root password: "
read -s ROOT_PASSWORD

# Function to handle errors
handle_error() {
  local exit_code=$?
  echo "Error: Command failed with exit code $exit_code"
  exit $exit_code
}

# Set up error handling
trap 'handle_error' ERR

# Check if sudo works
echo $ROOT_PASSWORD | sudo -S true || {
  echo "Error: Incorrect root password or sudo not available."
  exit 1
}

# Update system
echo $ROOT_PASSWORD | sudo -S apt-get update

# Install required packages
echo $ROOT_PASSWORD | sudo -S apt-get install -y zip unzip
echo $ROOT_PASSWORD | sudo -S apt-get install -y linux-headers-$(uname -r)
echo $ROOT_PASSWORD | sudo -S apt-get install -y arping netperf iperf3
echo $ROOT_PASSWORD | sudo -S apt-get install -y llvm python3 libbpf-dev libelf-dev libdebuginfod-dev
echo $ROOT_PASSWORD | sudo -S apt-get install -y bison build-essential cmake flex git libedit-dev libllvm14 llvm-14-dev libclang-14-dev 
echo $ROOT_PASSWORD | sudo -S apt-get install -y zlib1g-dev libfl-dev python3-distutils python3-setuptools
echo $ROOT_PASSWORD | sudo -S apt-get install -y luajit luajit-5.1-dev
echo $ROOT_PASSWORD | sudo -S apt-get install -y liblzma-dev

# Build BCC from source
git clone https://github.com/iovisor/bcc.git
mkdir bcc/build && cd bcc/build
echo $ROOT_PASSWORD | sudo -S cmake ..
echo $ROOT_PASSWORD | sudo -S make install
echo $ROOT_PASSWORD | sudo -S cmake -DPYTHON_CMD=python3 ..
cd src/python/
echo $ROOT_PASSWORD | sudo -S make
echo $ROOT_PASSWORD | sudo -S make install
cd ../..


# TEST INSTALATION
# Change head from python to python3
sudo sed -i 's|#!/usr/bin/env python|#!/usr/bin/env python3|' /usr/share/bcc/tools/opensnoop

# Check if opensnoop command works
echo " Testing the correctness of the installation begins by running the opensnoop program in the background."
echo " Wait 5 sekunds for the result."
# If you replace sign & to ; you will see windows with running opensnoop
if echo $ROOT_PASSWORD | sudo -S timeout 5 /usr/share/bcc/tools/opensnoop& then
  # Display message if test successful
  echo "All works, have fun coding with eBPF!"
else
  echo "Error: opensnoop test command failed..."
  echo "Check all information in your terminal from installation"
fi
