import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
  id: centerWindow
  property var notifications
  property bool open: false
  property bool _mapped: false
  property var anchorItem: null
  anchor.item: centerWindow.anchorItem
  anchor.edges: Edges.Bottom | Edges.Right
  anchor.gravity: Edges.Bottom | Edges.Left
  anchor.margins.top: 8

  color: "transparent"

  readonly property real fullWidth: 340
  readonly property real fullHeight: Math.min(480, header.implicitHeight + list.contentHeight + 24)

  implicitWidth: centerWindow.fullWidth
  implicitHeight: centerWindow.fullHeight
  visible: centerWindow._mapped

  onOpenChanged: {
    if (open) centerWindow._mapped = true
    else closeTimer.restart()
  }
  Timer { id: closeTimer; interval: 150; onTriggered: centerWindow._mapped = false }

  MouseArea {
    anchors.fill: parent
    onClicked: centerWindow.open = false
    z: -10
    enabled: centerWindow.open
  }

  readonly property real srcWidth: centerWindow.anchorItem ? centerWindow.anchorItem.width : 40
  readonly property real srcHeight: centerWindow.anchorItem ? centerWindow.anchorItem.height : 24

  Rectangle {
    id: bg
    x: parent.width - width
    y: 0
    width: centerWindow.open ? centerWindow.fullWidth : centerWindow.srcWidth
    height: centerWindow.open ? centerWindow.fullHeight : centerWindow.srcHeight
    radius: centerWindow.open ? 14 : height / 2
    color: centerWindow.open ? Theme.inactiveBg : Theme.bg
    border.width: centerWindow.open ? 1 : 0
    border.color: Theme.comment
    clip: true

    Behavior on width        { NumberAnimation { duration: 180; easing.type: Easing.OutExpo } }
    Behavior on height       { NumberAnimation { duration: 180; easing.type: Easing.OutExpo } }
    Behavior on radius       { NumberAnimation { duration: 180; easing.type: Easing.OutExpo } }
    Behavior on color        { ColorAnimation  { duration: 120 } }
    Behavior on border.width { NumberAnimation { duration: 120 } }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 12
      spacing: 8

      opacity: centerWindow.open ? 1 : 0
      scale: centerWindow.open ? 1 : 0.9
      transformOrigin: Item.Top

      Behavior on opacity {
        SequentialAnimation {
          PauseAnimation { duration: centerWindow.open ? 70 : 0 }
          NumberAnimation { duration: 90; easing.type: Easing.OutCubic }
        }
      }
      Behavior on scale {
        SequentialAnimation {
          PauseAnimation { duration: centerWindow.open ? 70 : 0 }
          NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
        }
      }

      RowLayout {
        id: header
        Layout.fillWidth: true
        Text {
          text: "Notifications"
          color: Theme.fg
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 14
          font.bold: true
          Layout.fillWidth: true
        }
        Text {
          text: "Clear"
          color: Theme.comment
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 12
          visible: centerWindow.notifications.history.length > 0
          MouseArea {
            anchors.fill: parent
            anchors.margins: -6
            cursorShape: Qt.PointingHandCursor
            onClicked: centerWindow.notifications.clearHistory()
          }
        }
      }

      Text {
        visible: centerWindow.notifications.history.length === 0
        text: "No notifications yet"
        color: Theme.comment
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 12
        Layout.topMargin: 8
        Layout.bottomMargin: 8
      }

      ListView {
        id: list
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 6
        model: centerWindow.notifications.history
        delegate: Rectangle {
          width: list.width
          implicitHeight: entryCol.implicitHeight + 16
          radius: 10
          color: Theme.bg

          ColumnLayout {
            id: entryCol
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

            RowLayout {
              Layout.fillWidth: true
              Text {
                text: modelData.appName
                color: Theme.comment
                font.family: "Iosevka Nerd Font"
                font.pixelSize: 11
                Layout.fillWidth: true
                elide: Text.ElideRight
              }
              Text {
                text: modelData.time
                color: Theme.comment
                font.family: "Iosevka Nerd Font"
                font.pixelSize: 11
              }
            }
            Text {
              text: modelData.summary
              color: Theme.fg
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 13
              font.bold: true
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
              visible: text !== ""
            }
            Text {
              text: modelData.body
              color: Theme.fgDim
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 12
              wrapMode: Text.WordWrap
              maximumLineCount: 3
              elide: Text.ElideRight
              Layout.fillWidth: true
              visible: text !== ""
            }
          }
        }
      }
    }
  }
}
