import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PopupWindow {
  id: powerWindow
  property bool open: false
  property bool _mapped: false
  property var anchorItem: null   // the Pill that triggers this panel

  anchor.item: powerWindow.anchorItem
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.margins.top: 8

  color: "transparent"
  implicitWidth: 220
  implicitHeight: bg.implicitHeight
  visible: powerWindow._mapped

  onOpenChanged: {
    if (open) powerWindow._mapped = true
    else closeTimer.restart()
  }
  Timer { id: closeTimer; interval: 250; onTriggered: powerWindow._mapped = false }

  // click-away to close
  MouseArea {
    anchors.fill: parent
    onClicked: powerWindow.open = false
    z: -10
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

  // qs ipc call session toggle / open_ / close_
  IpcHandler {
    target: "session"
    function toggle(): void { powerWindow.open = !powerWindow.open }
    function open_(): void { powerWindow.open = true }
    function close_(): void { powerWindow.open = false }
  }

  Rectangle {
    id: bg
    width: parent.width
    implicitHeight: col.implicitHeight + 24
    radius: 14
    color: Theme.inactiveBg
    border.width: 1
    border.color: Theme.comment

    scale: powerWindow.open ? 1 : 0.85
    opacity: powerWindow.open ? 1 : 0
    transformOrigin: Item.Top

    Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 2.5 } }
    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

    ColumnLayout {
      id: col
      anchors.fill: parent
      anchors.margins: 12
      spacing: 6

      Text {
        text: "Session"
        color: Theme.comment
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 12
        Layout.bottomMargin: 4
      }

      // icon left blank on each row below - paste your own nerd font glyph
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
          color: rowMa.containsMouse ? Theme.line : "transparent"
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
