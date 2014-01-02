# Simple make file to wrap the building of the apt source tree.
#
# This project assumes that it will be built using Debian's
# own set of tools for compiling and packaging. This manually 
# build some of the more useful parts of the apt project, and
# installs them in their expected location for Amazons default
# linux AMI.
#
# There are likley issues with this ... you've been warned.

all: getdeps build

getdeps:
	@echo 'Getting Dependancies:'
	@sudo yum install \
					gcc \
					gcc-c++ \
					autoconf \
					automake \
					db4-devel \
					libcurl-devel \
					gettext-devel \
					zlib-devel \
					bzip2-devel >/dev/null
					

build: getdeps
	# Currently only builds a subset of the available
	# make targets -- only development artifacts are
	# built
	# * shared objects
	# * apt methods (used by external programs such as reprepro)
	# * development headers are 'built' (useful for projects like python-apt)

	@echo 'Building:'
	@cd ./apt

	autoconf
	./configure --prefix=/usr/local

	make -C apt-pkg/
	make -C apt-inst/
	make -C methods/

install: build
	@echo 'Installing:'

  @mkdir -p /usr/lib/apt/methods/
	@mkdir -p /usr/include/apt-pkg/

	# Install apt-pkg and apt-inst shared object files
	# these shared objects are already properly symlinked
	# during the build 
	@cp ./apt/bin/*.so*	/usr/lib64/
	
	# Install the development header files 
  @cp .apt/apt-pkg/*.h /usr/include/apt-pkg/

.PHONY: all clean getdeps
