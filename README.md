# Ubuntu

Check the contents of `install_everything.sh` and run it to install everything


# Arch

## Installing
1. Edit `export_targetdir.sh`, enter your preferred install location there
2. Check and execute install_system_packages_arch.sh
3. Check and execute install_everything_arch.sh
4. Optional: Add `source init_environment.sh` command to ~/.bash_profile

## Working
1. Execute `source init_environment.sh` before starting to work with just if you haven't added it to ~/.bash_profile during installation


## Uninstalling
1. Execute `clean-up.sh` from the project directory
2. Remove `source init_environment.sh` from ~/.bash_profile if you added it during installation 
