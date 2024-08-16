#!/bin/bash
rm ./build.ver
DATE=$(date +"%Y%m%d-%H%M%S")
echo $DATE>>"./build.ver"