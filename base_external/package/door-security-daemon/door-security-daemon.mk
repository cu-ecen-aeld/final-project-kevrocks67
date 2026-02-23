################################################################################
#
# DOOR_SECURITY_DAEMON
#
################################################################################

# Use the full hash or 'main'
DOOR_SECURITY_DAEMON_VERSION = main
# Use the SSH style or HTTPS style, but ensure SITE_METHOD is git
DOOR_SECURITY_DAEMON_SITE = https://github.com/kevrocks67/final-project-assignment-aesd-kevrocks67.git
DOOR_SECURITY_DAEMON_SITE_METHOD = git
DOOR_SECURITY_DAEMON_GIT_SUBMODULES = YES

DOOR_SECURITY_DAEMON_LICENSE = MIT

# Buildroot passes the cross-compiler toolchain to CMake automatically.
# We disable testing here to save time and space on the QEMU/BBB image.
DOOR_SECURITY_DAEMON_CONF_OPTS = -DBUILD_TESTING=OFF

# This is a CMake project, so we use the cmake-package infrastructure
$(eval $(cmake-package))
