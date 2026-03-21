################################################################################
#
# DOOR_SECURITY_DAEMON
#
################################################################################

DOOR_SECURITY_DAEMON_VERSION = main
DOOR_SECURITY_DAEMON_SITE = https://github.com/kevrocks67/final-project-assignment-aesd-kevrocks67.git
DOOR_SECURITY_DAEMON_SITE_METHOD = git
DOOR_SECURITY_DAEMON_GIT_SUBMODULES = YES

DOOR_SECURITY_DAEMON_LICENSE = MIT

# Buildroot passes the cross-compiler toolchain to CMake automatically.
# We disable testing here to save time and space on the QEMU/BBB image.
DOOR_SECURITY_DAEMON_CONF_OPTS = \
    -DBUILD_DOCS=OFF \
    -DBUILD_TESTING=OFF \
    -DENABLE_COVERAGE=OFF

define DOOR_SECURITY_DAEMON_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 0755 $(@D)/pkg/buildroot/S99door_security_daemon \
        $(TARGET_DIR)/etc/init.d/S99door_security_daemon
endef

# This is a CMake project, so we use the cmake-package infrastructure
$(eval $(cmake-package))
