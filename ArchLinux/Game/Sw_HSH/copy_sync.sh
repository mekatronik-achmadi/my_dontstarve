#!/bin/bash

sudo rsync -avh --delete ./ /opt/gog-dont-starve/game/dontstarve64/data/ --exclude "DLC0001" --exclude "DLC0002/scripts/components/flooding.lua"
sudo chown -Rvf root:root /opt/gog-dont-starve/game/dontstarve64/data/
