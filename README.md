
# Description
Project of powerful ViM configuration files. ViM is a quality text
editor with huge set of features. Vimconfig is project of highly
tuned ViM configuration files for ViM developed over 5 years.

See vim/doc/FEATURES.txt file for getting help. Read this file with ViM for
better reading.

This document is fast howto install this vimconfig.

# INSTALLATION

Copy content of vimconfig/ directory somewhere in your home directory.
Suppose that it will be ~/prog/vimconfig/. Go to this directory
(~/prog/vimconfig/) and type 'make install'. Or simply create symlinks
in root of your home directory:

    git clone git://github.com/uning/vimconfig 
    cd vimconfig && git submodule update --init
    make install

# Updating

As long as your checkout is kept clean, you can easily update, rebase your local changes and update submodules with:

     git pull --rebase ; git submodule update ; cd -

# Getting the newest versions of all submodules

Run this from the main directory:

     git submodule foreach git pull origin master

