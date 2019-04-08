In order to build this as a Corves Gateway, provide a 'config' file
with the following settings:

The name of the image

  IMG_NAME=xxx

The password for the gateway account

  GW_PASS=xxx

The location on the local machine to find the backend code that
should be installed on the gateway

  GW_SCRIPTS=/path/to/backend


In addition, ensure you have put a file named 'SKIP' in the folders
stage3, stage4, and stage5.  These are only needed for the GUI.
