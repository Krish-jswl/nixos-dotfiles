//@ pragma UseQApplication
//@ pragma RespectSystemStyle
//@ pragma IconTheme Papirus

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

ShellRoot {
    id: root

    // ------------------------------------------------------------
    // Shared services
    // ------------------------------------------------------------

    NiriIPC {
        id: niri
    }

    Notifications {
        id: notif
    }

    Audio {
        id: audio
    }

    Brightness {
        id: brightness
    }

    readonly property var player:
        Mpris.players.values.find(p => p.isPlaying)
        ?? Mpris.players.values[0]
        ?? null


    // ------------------------------------------------------------
    // Top bar
    // ------------------------------------------------------------

    PanelWindow {
        id: bar

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 24

        margins {
            top: 5
            left: 1
            right: 1
            bottom: 5
        }

        color: "transparent"


        // --------------------------------------------------------
        // Pollers
        // --------------------------------------------------------

        Poller {
            id: clock

            command: "date +%H:%M"
            interval: 15000
        }

        Poller {
            id: bat

            command: "cat /sys/class/power_supply/BAT0/capacity"
            interval: 30000
        }

        Poller {
            id: batStatus

            command: "cat /sys/class/power_supply/BAT0/status"
            interval: 30000
        }

        Poller {
            id: net

            command: "nmcli -t -f NAME connection show --active | head -n1"
            interval: 5000
        }


        // --------------------------------------------------------
        // Dynamic icon helpers
        // --------------------------------------------------------

        function volumeIcon(vol, muted) {
            if (muted) return ""
            const pct = Math.round(vol * 100)
            if (pct <= 0)  return ""
            if (pct <= 33) return ""
            if (pct <= 66) return ""
            return ""
        }

        function brightnessIcon(pct) {
            const p = Math.round(pct * 100)
            if (p <= 14) return "󰪞"
            if (p <= 28) return "󰪟"
            if (p <= 42) return "󰪡"
            if (p <= 57) return "󰪢"
            if (p <= 71) return "󰪣"
            if (p <= 85) return "󰪤"
            return "󰪥"
        }

        function batteryIcon(pct, status) {
            const charging = (status === "Charging" || status === "Full")
            const pluggedNotCharging = (status === "Not charging")
            const p = parseInt(pct) || 0
            if (pluggedNotCharging) return "󰚥"
            if (charging) {
                if (p >= 100) return "󰂅"
                if (p >= 90)  return "󰂋"
                if (p >= 80)  return "󰂊"
                if (p >= 70)  return "󰢞"
                if (p >= 60)  return "󰂉"
                if (p >= 50)  return "󰢝"
                if (p >= 40)  return "󰂈"
                if (p >= 30)  return "󰂇"
                if (p >= 20)  return "󰂆"
                return "󰢜"
            } else {
                if (p >= 100) return "󰁹"
                if (p >= 90)  return "󰂂"
                if (p >= 80)  return "󰂁"
                if (p >= 70)  return "󰂀"
                if (p >= 60)  return "󰁿"
                if (p >= 50)  return "󰁾"
                if (p >= 40)  return "󰁽"
                if (p >= 30)  return "󰁼"
                if (p >= 20)  return "󰁻"
                if (p >= 10)  return "󰁺"
                return "󰂎"
            }
        }

        function batteryColor(pct, status) {
            const charging = (status === "Charging" || status === "Full")
            const pluggedNotCharging = (status === "Not charging")
            const p = parseInt(pct) || 0
            if (pluggedNotCharging) return "#b4a7d6"
            if (charging) return "#7e98e8"
            if (p <= 10)  return "#d8647e"
            if (p <= 25)  return "#f3be7c"
            return "#7fa563"
        }


        // --------------------------------------------------------
        // Left side
        // --------------------------------------------------------

        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            anchors.leftMargin: 14

            spacing: 8

            Workspaces {
                niri: niri
            }

            Pill {
                id: mediaPill

                icon: root.player
                      ? (root.player.isPlaying ? "󰎆" : "󰏤")
                      : "󰝛"

                iconColor: "#7e98e8"

                maxLabelWidth: 220

                label: root.player
                       ? `${root.player.trackArtist || "Unknown"} - ${root.player.trackTitle || ""}`
                       : "Nothing playing"

                clickable: root.player !== null

                active: mediaPanel.open

                onClicked: {
                    mediaPanel.open = !mediaPanel.open

                    notifCenter.open = false
                    calendarPopup.open = false
                    powerMenu.open = false
                }

                onWheel: delta => {
                    if (!root.player)
                        return

                    if (delta > 0 && root.player.canGoPrevious)
                        root.player.previous()
                    else if (delta < 0 && root.player.canGoNext)
                        root.player.next()
                }
            }
        }


        // --------------------------------------------------------
        // Center
        // --------------------------------------------------------

        RowLayout {
            id: centerGroup

            anchors.centerIn: parent

            spacing: 8

            Pill {
                id: clockPill

                icon: "󰥔"
                label: clock.value

                iconColor: "#f3be7c"

                clickable: true

                active: calendarPopup.open

                onClicked: {
                    calendarPopup.open = !calendarPopup.open

                    notifCenter.open = false
                    mediaPanel.open = false
                    powerMenu.open = false
                }
            }
        }


        // --------------------------------------------------------
        // Right side
        // --------------------------------------------------------

        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            anchors.rightMargin: 14

            spacing: 8


            // System tray
            Tray {
                barWindow: bar
            }


            // Notifications
            Pill {
                id: notifPill

                icon: "󰂚"

                label: notif.history.length > 0
                       ? String(notif.history.length)
                       : ""

                iconColor: notif.active.length > 0
                            ? "#f3be7c"
                            : "#cdcdcd"

                clickable: true

                active: notifCenter.open

                onClicked: {
                    notifCenter.open = !notifCenter.open

                    calendarPopup.open = false
                    mediaPanel.open = false
                    powerMenu.open = false
                }
            }


            // Network
            Pill {
                icon: "󰖩"
                label: net.value
                iconColor: "#bb9dbd"
            }


            // Volume
            Pill {
                icon: bar.volumeIcon(audio.volume, audio.muted)

                label: audio.muted
                       ? "mute"
                       : Math.round(audio.volume * 100) + "%"

                iconColor: audio.muted ? "#606079" : "#c48282"

                clickable: true

                onClicked: {
                    audio.toggleMute()
                }

                onWheel: delta => {
                    audio.adjust(delta > 0 ? 0.05 : -0.05)
                }
            }


            // Brightness
            Pill {
                icon: bar.brightnessIcon(brightness.percent)

                label: Math.round(brightness.percent * 100) + "%"

                iconColor: "#e0a363"

                clickable: true

                onWheel: delta => {
                    brightness.adjust(delta > 0 ? 0.05 : -0.05)
                }
            }


            // Battery
            Pill {
                icon: bar.batteryIcon(bat.value, batStatus.value)

                label: bat.value + "%"

                iconColor: bar.batteryColor(bat.value, batStatus.value)
            }


            // Power
            Pill {
                id: powerPill

                icon: "⏻"

                iconColor: "#d8647e"

                clickable: true

                active: powerMenu.open

                onClicked: {
                    powerMenu.open = !powerMenu.open

                    notifCenter.open = false
                    calendarPopup.open = false
                    mediaPanel.open = false
                }
            }
        }


        // --------------------------------------------------------
        // Popups (anchored to their respective pills)
        // --------------------------------------------------------

        NotificationPopup {
            notifications: notif
        }

        NotificationCenter {
            id: notifCenter

            notifications: notif
            anchorItem: notifPill
        }

        Calendar {
            id: calendarPopup

            anchorItem: clockPill
        }

        PowerMenu {
            id: powerMenu

            anchorItem: powerPill
        }

        MediaPanel {
            id: mediaPanel

            player: root.player
            anchorItem: mediaPill
        }
    }
}

