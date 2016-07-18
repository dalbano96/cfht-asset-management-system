# CFHT Asset Management
Asset management system for the Canada France Hawaii Telescope. Snipe-IT web application developed by Snipe
# Running the Installation script

The installation script will only work for initial installation of the asset management system on a new virtual machine. Therefore, re-installation on an existing machine will result in possible errors. The script works by configuring the necessary packages required for the system to operate. This includes a LAMP stack to manage a web server, user configuration, permissions configuration, and the Snipe-IT web application.

When the script is executed, it will use the local machine as the primary domain to host the web application. As a result, the URL (https://inventory.cfht.hawaii.edu) would have to be affiliated with the domain that is hosting the application. The primary purpose of the installation script is to allow for quick and easy configuration of the asset management system.

Snipe-IT asset management system developed by Snipe (https://github.com/snipe)
