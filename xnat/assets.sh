#!/bin/bash

mkdir -p assets
base="https://ci.xnat.org/job/xnat-web/lastSuccessfulBuild/artifact/build/libs/"
latest=$(wget https://ci.xnat.org/job/xnat-web/lastSuccessfulBuild/artifact/build/libs/ -q -O - | grep -oP "xnat-web-.*?.war" | head -1)
url="$base$latest"

echo "Downloading the latest version: $latest"
wget --no-clobber -O ./assets/xnat-web.war $url
