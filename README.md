<div id="header" align="center">
  <img src="https://media0.giphy.com/media/1C8bHHJturSx2/200.webp?cid=790b7611datxhh3500rt5fult0n20dg3q8ksjcmy1cr5snrh&ep=v1_gifs_search&rid=200.webp&ct=g" width="400"/>
</div>

# BCC installer on ubuntu 22.04 LTS
Script tested on Ubuntu 22.04 LTS GUI and Server version. Ubuntu was virtualized using UTM on an M1 Mac.
This Bash script automates the process of installing BCC (BPF Compiler Collection) on Linux. The script installs the necessary packages and dependencies.
 
## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/bcc_ubuntu22.04_installer.git
    ```

2. Navigate to the repository:

    ```bash
    cd bcc_ubuntu22.04_installer
    ```

3. Make the script executable:

    ```bash
    chmod +x bcc_installer.sh
    ```

4. Run the script:

    ```bash
    ./bcc_installer.sh
    ```
Follow the on-screen prompts and enter your root password when prompted.

6. After the script completes, a test will be performed using the `opensnoop` tool to ensure the correctness of the installation.
7. If you replace sign "&" to ";" in 58 line, you will see windows with running opensnoop. This is what a working opensnoop program looks like:
   
<img width="1103" alt="Zrzut ekranu 2024-03-3 o 16 09 29" src="https://github.com/mar0ls/bcc_ubuntu22.04_installer/assets/120790937/5978d137-d034-432d-bc9b-f56de30afcae">


## Requirements

- Ubuntu 20.04 or newer
- Root access to install packages and dependencies

## Notes

- The script performs the following tasks:
  - Asks the user for the root password.
  - Checks for the availability of sudo and updates the system.
  - Installs required packages and dependencies for eBPF development.
  - Builds BCC from source.
  - Performs a test installation by running the `opensnoop` program.

## Ubuntu 24.04 lts
You can install bcc in Ubuntu 24.04 LTS from apt package
```bash
sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
```
or from binary source
```bash

#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

echo -n "Enter your root password: "
read -s ROOT_PASSWORD
echo

handle_error() {
  local exit_code=$?
  echo -e "${RED} [!!!] Error: Command failed with exit code $exit_code${NC}"
  exit $exit_code
}

trap 'handle_error' ERR

echo $ROOT_PASSWORD | sudo -S true || {
  echo -e "${RED} [!!!] Error: Incorrect root password or sudo not available.${NC}"
  exit 1
}

echo -e "${GREEN} Updating package list...${NC}"
echo $ROOT_PASSWORD | sudo -S apt update

echo -e "${GREEN} Installing dependencies...${NC}"
echo $ROOT_PASSWORD | sudo -S apt install -y zip bison build-essential cmake flex git libedit-dev \
  libllvm18 llvm-18-dev libclang-18-dev python3 zlib1g-dev libelf-dev libfl-dev python3-setuptools \
  liblzma-dev libdebuginfod-dev arping netperf iperf3 libpolly-18-dev

echo -e "${GREEN} Cloning BCC repository...${NC}"
git clone https://github.com/iovisor/bcc.git
mkdir bcc/build && cd bcc/build

echo -e "${GREEN} Configuring build with CMake...${NC}"
echo $ROOT_PASSWORD | sudo -S cmake ..
echo -e "${GREEN} Building BCC...${NC}"
make -j$(nproc)
echo $ROOT_PASSWORD | sudo -S make install

echo -e "${GREEN} Installing Python bindings...${NC}"
echo $ROOT_PASSWORD | sudo -S cmake -DPYTHON_CMD=python3 ..
cd ../src/python
make -j$(nproc)
echo $ROOT_PASSWORD | sudo -S make install
cd ../../

echo -e "${GREEN} Fixing Python shebangs in BCC tools...${NC}"
echo $ROOT_PASSWORD | sudo -S find /usr/share/bcc/tools -type f -exec sed -i 's|#!/usr/bin/env python$|#!/usr/bin/env python3|' {} \;

echo -e "${GREEN} Testing BCC installation by running 'opensnoop' for 5 seconds...${NC}"
if echo $ROOT_PASSWORD | sudo -S timeout 5 /usr/share/bcc/tools/opensnoop > /dev/null 2>&1; then
  echo -e "${GREEN} [OK] BCC installed and tested successfully!${NC}"
else
  echo -e "${RED}[!!!]Error: 'opensnoop' test failed. Please check the build logs.${NC}"
fi
```

## Reference
- The github site BCC project: [click here](https://github.com/iovisor/bcc)
- The eBPF ducumentation: [click here](https://ebpf.io/)
  
**Note:** Ensure you have the correct root password and necessary permissions to install packages.
