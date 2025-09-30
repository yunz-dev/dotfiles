#!/usr/bin/env sh

# filter="PMU tdev"
filter="PMU tcal"
sensor_output=$(./plugins/macos-temp-tool -f "${filter}" -a | awk '{print $NF}')
sensor_output=$(smctemp -g)
LABEL="${sensor_output}°C"

sketchybar --set "$NAME" label="$LABEL"
