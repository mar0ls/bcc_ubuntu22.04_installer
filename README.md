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

## Reference
- The github site BCC project: [click here](https://github.com/iovisor/bcc)
- The eBPF ducumentation: [click here](https://ebpf.io/)
- 
**Note:** Ensure you have the correct root password and necessary permissions to install packages.
