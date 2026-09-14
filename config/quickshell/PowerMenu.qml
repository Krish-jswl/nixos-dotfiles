import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PanelWindow {
  id: powerWindow
  property bool open: false
  property bool _mapped: false
  property var anchorItem: null   // kept only to size the grow-from animation

  anchors { top: true; right: true }
  margins { top: 0; right: 14 }
  exclusiveZone: 0
  focusable: powerWindow.open

  color: "transparent"

  readonly property real fullWidth: 220
  readonly property real fullHeight: col.implicitHeight + 24

  implicitWidth: powerWindow.fullWidth
  implicitHeight: powerWindow.fullHeight
  visible: powerWindow._mapped

  property int currentIndex: 0

  onOpenChanged: {
    if (open) {
      powerWindow._mapped = true
      powerWindow.currentIndex = 0
      focusTimer.restart()
    } else {
      closeTimer.restart()
    }
  }
  Timer { id: closeTimer; interval: 150; onTriggered: powerWindow._mapped = false }
  Timer { id: focusTimer; interval: 10; onTriggered: bg.forceActiveFocus() }

  // click-away to close
  MouseArea {
    anchors.fill: parent
    onClicked: powerWindow.open = false
    z: -10
    enabled: powerWindow.open
  }

  Process { id: runner }
  function run(cmd) {
    runner.command = ["sh", "-c", cmd]
    runner.running = true
    powerWindow.open = false
  }

  // Edit these commands to match what you have installed.
  function lock()     { run("hyprlock") }
  function logout()   { run("niri msg action quit --skip-confirmation") }
  function suspend()  { run("systemctl suspend") }
  function reboot()   { run("systemctl reboot") }
  function shutdown() { run("systemctl poweroff") }

  readonly property var actionOrder: ["lock", "logout", "suspend", "reboot", "shutdown"]
  function activateCurrent() {
    const a = powerWindow.actionOrder[powerWindow.currentIndex]
    if (a === "lock") powerWindow.lock()
    else if (a === "logout") powerWindow.logout()
    else if (a === "suspend") powerWindow.suspend()
    else if (a === "reboot") powerWindow.reboot()
    else if (a === "shutdown") powerWindow.shutdown()
  }

  // qs ipc call session toggle / open_ / close_
  IpcHandler {
    target: "session"
    function toggle(): void { powerWindow.open = !powerWindow.open }
    function open_(): void { powerWindow.open = true }
    function close_(): void { powerWindow.open = false }
  }

  readonly property real srcWidth: powerWindow.anchorItem ? powerWindow.anchorItem.width : 40
  readonly property real srcHeight: powerWindow.anchorItem ? powerWindow.anchorItem.height : 24

  Rectangle {
    id: bg
    x: parent.width - width
    y: 0
    focus: true

    Keys.onPressed: event => {
      if (event.key === Qt.Key_Down) {
        powerWindow.currentIndex = (powerWindow.currentIndex + 1) % powerWindow.actionOrder.length
        event.accepted = true
      } else if (event.key === Qt.Key_Up) {
        powerWindow.currentIndex = (powerWindow.currentIndex - 1 + powerWindow.actionOrder.length) % powerWindow.actionOrder.length
        event.accepted = true
      } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
        powerWindow.activateCurrent()
        event.accepted = true
      } else if (event.key === Qt.Key_Escape) {
        powerWindow.open = false
        event.accepted = true
      }
    }
    width: powerWindow.open ? powerWindow.fullWidth : powerWindow.srcWidth
    height: powerWindow.open ? powerWindow.fullHeight : powerWindow.srcHeight
    radius: powerWindow.open ? 14 : height / 2
    color: powerWindow.open ? Theme.inactiveBg : Theme.bg
    border.width: powerWindow.open ? 1 : 0
    border.color: Theme.comment
    clip: true

    Behavior on width        { NumberAnimation { duration: 180; easing.type: Easing.OutExpo } }
    Behavior on height       { NumberAnimation { duration: 180; easing.type: Easing.OutExpo } }
    Behavior on radius       { NumberAnimation { duration: 180; easing.type: Easing.OutExpo } }
    Behavior on color        { ColorAnimation  { duration: 120 } }
    Behavior on border.width { NumberAnimation { duration: 120 } }

    ColumnLayout {
      id: col
      anchors.fill: parent
      anchors.margins: 12
      spacing: 6

      opacity: powerWindow.open ? 1 : 0
      scale: powerWindow.open ? 1 : 0.9
      transformOrigin: Item.Top

      Behavior on opacity {
        SequentialAnimation {
          PauseAnimation { duration: powerWindow.open ? 70 : 0 }
          NumberAnimation { duration: 90; easing.type: Easing.OutCubic }
        }
      }
      Behavior on scale {
        SequentialAnimation {
          PauseAnimation { duration: powerWindow.open ? 70 : 0 }
          NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
        }
      }

      Text {
        text: "Session"
        color: Theme.comment
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 12
        Layout.bottomMargin: 4
      }

      Repeater {
        model: [
          { label: "Lock",      icon: "󰌾", action: "lock" },
          { label: "Log out",   icon: "󰍃", action: "logout" },
          { label: "Suspend",   icon: "󰒲", action: "suspend" },
          { label: "Restart",   icon: "󰑓", action: "reboot" },
          { label: "Shut down", icon: "󰐥", action: "shutdown" }
        ]
        delegate: Rectangle {
          Layout.fillWidth: true
          implicitHeight: 34
          radius: 10
          color: (rowMa.containsMouse || index === powerWindow.currentIndex) ? Theme.line : "transparent"
          Behavior on color { ColorAnimation { duration: 100 } }

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10
            Text {
              text: modelData.icon
              color: modelData.action === "shutdown" || modelData.action === "logout" ? Theme.error : Theme.fg
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 15
              visible: modelData.icon !== ""
            }
            Text {
              text: modelData.label
              color: Theme.fg
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 13
              Layout.fillWidth: true
            }
          }

          MouseArea {
            id: rowMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: powerWindow.currentIndex = index
            onClicked: {
              if (modelData.action === "lock") powerWindow.lock()
              else if (modelData.action === "logout") powerWindow.logout()
              else if (modelData.action === "suspend") powerWindow.suspend()
              else if (modelData.action === "reboot") powerWindow.reboot()
              else if (modelData.action === "shutdown") powerWindow.shutdown()
            }
          }
        }
      }
    }
  }
}
