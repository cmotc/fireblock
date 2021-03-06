#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEBIN=fireblock
SOURCEDOC=README.md
DEBFOLDER=fireblock
DEBVERSION=$(date +%Y%m%d)

if [ -n "$BASH_VERSION" ]; then
	TOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
	TOME=$( cd "$( dirname "$0" )" && pwd )
fi
cd $TOME

git pull origin master

DEBFOLDERNAME="$TOME/../$DEBFOLDER-$DEBVERSION"

# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp $TOME $DEBFOLDERNAME -R
cd $DEBFOLDERNAME

# Create the packaging skeleton (debian/*)
dh_make --indep --createorig 

mkdir -p debian/tmp
cp * debian/tmp

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo $SOURCEBIN usr/bin > debian/install 
echo $SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc > ../log 
