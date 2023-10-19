# Ubuntu

Check the contents of `install_everything.sh` and run it to install everything


# Arch

## Installing
1. Edit `./arch/export_targetdir.sh`, enter your preferred install location there
2. Check and execute `./arch/install_system_packages.sh`
3. Check and execute `./install_everything.sh`
4. Optional: Add `source absolute/path/to/arch/init_environment.sh` command to ~/.bash_profile

## Working
1. Execute `source arch/init_environment.sh` before starting to work with just if you haven't added it to ~/.bash_profile during installation


## Uninstalling
1. Execute `arch/clean-up.sh` from the project directory
2. Remove `source absolute/path/to/arch/init_environment.sh` from ~/.bash_profile if you added it during installation 
