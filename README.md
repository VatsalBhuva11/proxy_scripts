# Corporate/College Proxy Configuration Scripts

-   Your one-stop solution to handling proxy at your job/college. It's a pain to keep switching the proxy on and off, and modifying specific files in the system to actually unset the proxy for that particular app.
-   To overcome those struggles, I've prepared a bunch of bash-scripts that will let you execute just **ONE SINGLE COMMAND** everytime to either set/unset the proxy for that particular application.
-   The applications supported currently are **Git** and **npm**. So you can set/unset the proxy for these apps using a single command.

## Installation

```bash
git clone https://github.com/VatsalBhuva11/proxy_scripts.git
cd proxy_scripts
```
```bash
./setup.sh
```

## Usage

-   Once you've installed the scripts, it's time to configure your proxy credentials (if any).
-   Running the `setup.sh` file must've prompted you for your:

1. Proxy Address\*
2. Proxy Port\*
3. Username (if)
4. Password (if)

-   It's important to note that while entering the Username or Password, you follow the **URL-Encoding** scheme that is provided to you as a reference when the script is run. Not doing so may cause issues with the proxy, and it may not work.
-   Having run the `setup.sh` file, you're essentially done now! The setup script caches your credentials so that you won't be prompted to enter them again whenever re-setting your proxy. If you need to change your proxy credentials at any moment, you can do so by running the `proxy.conf.sh` script, or directly changing it in the `proxy.conf.txt` file.
-   The setup script also adds the cloned repo's path to `~/.bashrc` , which would mean that _**you can run the following scripts from any directory**_ without cd'ing into this cloned repo's directory. Only the setup script should be run from the cloned dir's path (the first time, not needed later).

## Options Available

As mentioned, for now, you can only set/unset the proxy for **Git** and **npm**. Hence, you have the following options/scripts in hand once your credentials are initialised:

1. set_github_proxy.sh
2. unset_github_proxy.sh
3. set_npm_proxy.sh
4. unset_npm_proxy.sh

These scripts are self-explanatory, and can be executed from anywhere within the file system.

Some (actually all I guess) of these scripts require you to restart your terminal after running the scripts, for the proxy change to be sourced by bashrc. I'm working on making this more convenient for now, but it is what it is.

**Note: DO NOT FORGET THE .sh extension while calling these scripts. You can optionally create aliases on your own in the ~/.bash_aliases file to call these scripts without typing them over and over.**

# over and out
