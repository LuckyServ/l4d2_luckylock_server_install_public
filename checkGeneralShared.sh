#!/bin/bash
grep -f <(cat cfg/generalfixes.cfg cfg/sharedplugins.cfg | grep -o '/.*\.smx' | sed 's/\///g') $(find cfg/cfgogl -type f)
