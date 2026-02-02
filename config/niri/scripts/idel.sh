#!/usr/bin/env bash
swayidle -w timeout 600 'swaylock' timeout 720 'niri msg output power off' resume 'niri msg output power on' timeout 1800 'loginctl suspend' before-sleep 'swaylock'

