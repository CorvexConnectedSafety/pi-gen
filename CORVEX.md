# pi-gen for Corvex Gateway

This fork fine-tunes the stock Raspbian distribution for the requirements of 
the Corvex gateway.

## Dependencies

You will need a local snapshot of the Corvex backend software somewhere on the
local disk.

## Config

In order to build this as a Corves Gateway, provide a 'config' file
with the following settings:

 * The name of the image

   IMG_NAME=xxx

 * The password for the gateway account

   GW_PASS=xxx

 * The location on the local machine to find the backend code that should be installed on the gateway

   GW_SCRIPTS=/path/to/backend

See the file README.md for many more interesting config options.

In addition, ensure you have put a file named 'SKIP' in the folders
stage3, stage4, and stage5.  These are only needed for the GUI.  Also add the
file '`SKIP_IMAGES` to stage4 and stage5 folders.

```bash
# Example for setting up
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES
```

## Building

As 'root' execute the script ./build.sh from the top level directory.

Because of some bugs, we are now building via Vagrant:

Run vagrant up. It will start downloading the Virtualbox base
image (based on Debian Buster i386) and after done, it will run the
build.sh script of the repo. Once done, it will put the images in
the deploy folder. If the process fails, you can run again with
vagrant provision. vagrant destroy will delete the vm and its
contents. The source is here:
https://github.com/jriguera/packer-rpibuilder-vagrant so you can
customize it and create your own Raspbian builder vm.

## Cleanup

The build script creates a work directory that can get quite large.  The tree
in it is dated, so builds on subsequent days end up using more and more space.
It is a good idea to clear out that directory often.
