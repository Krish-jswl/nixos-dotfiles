#!/usr/bin/env bash
swayidle -w timeout 600 'swaylock' timeout 720 'niri msg output power off' resume 'niri msg output power on' timeout 1800 'pgrep swaylock && systemctl suspend' before-sleep 'swaylock'

