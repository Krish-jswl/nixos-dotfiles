import Quickshell
import Quickshell.Io
import QtQuick

// Reads brightness reactively straight from sysfs via FileView (push updates
// on change, no polling loop). Writing still goes through brightnessctl,
// since there is no native Quickshell API for changing backlight brightness -
// brightnessctl handles the udev permissions so it works without root.
Scope {
  id: root

  property string device: ""

  Process {
    id: detect
    command: ["sh", "-c", "ls /sys/class/backlight | head -n1"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.device = this.text.trim()
    }
  }

  FileView {
    id: maxFile
    path: root.device !== "" ? "/sys/class/backlight/" + root.device + "/max_brightness" : ""
  }

  FileView {
    id: curFile
    path: root.device !== "" ? "/sys/class/backlight/" + root.device + "/brightness" : ""
    watchChanges: true
    onFileChanged: reload()
  }

  readonly property int max: parseInt(maxFile.text()) || 1
  readonly property int current: parseInt(curFile.text()) || 0
  readonly property real percent: root.max > 0 ? (root.current / root.max) : 0

  Process { id: setProc }

  function setPercent(p) {
    if (root.device === "") return
    const clamped = Math.max(2, Math.min(100, Math.round(p * 100)))
    setProc.command = ["brightnessctl", "--device=" + root.device, "set", clamped + "%"]
    setProc.running = true
  }

  function adjust(deltaPercent) {
    root.setPercent(root.percent + deltaPercent)
  }
}
