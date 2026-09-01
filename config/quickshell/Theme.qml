pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Central theme singleton — reads colours from theme.json next to shell.qml.
// To change colors, edit theme.json and reload QuickShell (or send `qs ipc call theme reload`).
Singleton {
    id: theme

    // ===== Internal =====
    // _rev is incremented every time _data changes, so that color bindings
    // (which reference _rev) are forced to re-evaluate.
    property int _rev: 0
    property var _data: ({})

    function _c(key, fallback) {
        void _rev   // create a binding dependency on _rev
        return (_data && _data[key]) ? _data[key] : fallback
    }

    // ------- Base palette -------
    property color bg:           _c("bg",           "#141415")
    property color inactiveBg:   _c("inactiveBg",   "#1c1c24")
    property color line:         _c("line",         "#252530")
    property color fg:           _c("fg",           "#cdcdcd")
    property color fgDim:        _c("fgDim",        "#c3c3d5")
    property color comment:      _c("comment",      "#606079")
    property color disabled:     _c("disabled",     "#3a3a3d")
    property color floatBorder:  _c("floatBorder",  "#878787")
    property color trackBg:      _c("trackBg",      "#333738")

    // ------- Semantic accents -------
    property color accent:       _c("accent",       "#7e98e8")
    property color warning:      _c("warning",      "#f3be7c")
    property color error:        _c("error",        "#d8647e")
    property color success:      _c("success",      "#7fa563")
    property color info:         _c("info",         "#6e94b2")

    // ------- Per-widget accents -------
    property color volumeOn:     _c("volumeOn",     "#c48282")
    property color volumeOff:    _c("volumeOff",    "#606079")
    property color brightness:   _c("brightness",   "#e0a363")
    property color network:      _c("network",      "#bb9dbd")
    property color pluggedIn:    _c("pluggedIn",    "#b4a7d6")
    property color batteryLow:   _c("batteryLow",   "#f3be7c")

    // ------- Workspace dots -------
    property color wsActive:     _c("wsActive",     "#9bb4bc")
    property color wsFocused:    _c("wsFocused",    "#6e94b2")
    property color wsUrgent:     _c("wsUrgent",     "#d8647e")

    // Load theme.json on startup
    Component.onCompleted: _load()

    function _load() {
        const path = Qt.resolvedUrl("theme.json").toString().replace("file://", "")
        _reader.path = path
        _reader.running = true
    }

    // Reload callable via IPC:  qs ipc call theme reload
    IpcHandler {
        target: "theme"
        function reload(): void { theme._load() }
    }

    Process {
        id: _reader
        property string path: ""
        command: ["cat", _reader.path]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    theme._data = JSON.parse(this.text)
                    theme._rev++
                } catch (e) {
                    console.warn("Theme: failed to parse theme.json:", e)
                }
            }
        }
    }
}
