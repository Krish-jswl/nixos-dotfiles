import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
  id: calWindow
  property bool open: false
  property bool _mapped: false
  property var viewDate: new Date()
  property var anchorItem: null   // the Pill that triggers this panel

  anchor.item: calWindow.anchorItem
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.margins.top: 8

  color: "transparent"

  readonly property real fullWidth: 260
  readonly property real fullHeight: col.implicitHeight + 24

  // mapped at full size immediately - only the inner card resizes, so the
  // grow animation stays a pure scene-graph animation (smooth on Wayland)
  implicitWidth: calWindow.fullWidth
  implicitHeight: calWindow.fullHeight
  visible: calWindow._mapped

  onOpenChanged: {
    if (open) calWindow._mapped = true
    else closeTimer.restart()
  }
  Timer { id: closeTimer; interval: 150; onTriggered: calWindow._mapped = false }

  MouseArea {
    anchors.fill: parent
    onClicked: calWindow.open = false
    z: -10
    enabled: calWindow.open
  }

  function monthLabel() {
    return calWindow.viewDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")
  }

  // Build a 6x7 grid of day numbers (0 = not part of this month)
  function buildGrid() {
    const y = calWindow.viewDate.getFullYear()
    const m = calWindow.viewDate.getMonth()
    const first = new Date(y, m, 1)
    const startOffset = first.getDay() // 0 = Sunday
    const daysInMonth = new Date(y, m + 1, 0).getDate()
    const today = new Date()
    const isCurrentMonth = today.getFullYear() === y && today.getMonth() === m

    let cells = []
    for (let i = 0; i < startOffset; i++) cells.push({ day: 0, isToday: false })
    for (let d = 1; d <= daysInMonth; d++) {
      cells.push({ day: d, isToday: isCurrentMonth && d === today.getDate() })
    }
    while (cells.length % 7 !== 0) cells.push({ day: 0, isToday: false })
    return cells
  }

  readonly property real srcWidth: calWindow.anchorItem ? calWindow.anchorItem.width : 40
  readonly property real srcHeight: calWindow.anchorItem ? calWindow.anchorItem.height : 24

  Rectangle {
    id: bg
    x: 0
    y: 0
    width: calWindow.open ? calWindow.fullWidth : calWindow.srcWidth
    height: calWindow.open ? calWindow.fullHeight : calWindow.srcHeight
    radius: calWindow.open ? 14 : height / 2
    color: calWindow.open ? Theme.inactiveBg : Theme.bg
    border.width: calWindow.open ? 1 : 0
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
      spacing: 10

      opacity: calWindow.open ? 1 : 0
      scale: calWindow.open ? 1 : 0.9
      transformOrigin: Item.Top

      Behavior on opacity {
        SequentialAnimation {
          PauseAnimation { duration: calWindow.open ? 70 : 0 }
          NumberAnimation { duration: 90; easing.type: Easing.OutCubic }
        }
      }
      Behavior on scale {
        SequentialAnimation {
          PauseAnimation { duration: calWindow.open ? 70 : 0 }
          NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        Text {
          text: "󰅁"   // left chevron
          color: Theme.comment
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 13
          MouseArea {
            anchors.fill: parent
            anchors.margins: -6
            cursorShape: Qt.PointingHandCursor
            onClicked: calWindow.viewDate = new Date(calWindow.viewDate.getFullYear(), calWindow.viewDate.getMonth() - 1, 1)
          }
        }
        Text {
          text: calWindow.monthLabel()
          color: Theme.fg
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 14
          font.bold: true
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
        }
        Text {
          text: "󰅂"   // right chevron
          color: Theme.comment
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 13
          MouseArea {
            anchors.fill: parent
            anchors.margins: -6
            cursorShape: Qt.PointingHandCursor
            onClicked: calWindow.viewDate = new Date(calWindow.viewDate.getFullYear(), calWindow.viewDate.getMonth() + 1, 1)
          }
        }
      }

      GridLayout {
        columns: 7
        rowSpacing: 6
        columnSpacing: 4
        Layout.fillWidth: true

        Repeater {
          model: ["S", "M", "T", "W", "T", "F", "S"]
          delegate: Text {
            text: modelData
            color: Theme.comment
            font.family: "Iosevka Nerd Font"
            font.pixelSize: 11
            Layout.preferredWidth: 30
            horizontalAlignment: Text.AlignHCenter
          }
        }

        Repeater {
          model: calWindow.buildGrid()
          delegate: Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 26
            radius: 8
            color: modelData.isToday ? Theme.warning : "transparent"
            Text {
              anchors.centerIn: parent
              text: modelData.day === 0 ? "" : String(modelData.day)
              color: modelData.isToday ? Theme.bg : Theme.fg
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 12
              font.bold: modelData.isToday
            }
          }
        }
      }
    }
  }
}
