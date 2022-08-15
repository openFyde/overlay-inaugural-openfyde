#!/bin/sh
rdev=$(/usr/bin/rootdev -d)
/usr/bin/cgpt add -t kernel -i 2 $rdev
/usr/bin/cgpt add -t kernel -i 4 $rdev
