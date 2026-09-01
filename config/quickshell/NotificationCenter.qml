import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
  id: centerWindow
  property var notifications
  property bool open: false
  property bool _mapped: false
  property var anchorItem: null   // the Pill that triggers this panel

  anchor.item: centerWindow.anchorItem
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.margins.top: 8

  color: "transparent"
  implicitWidth: 340
  implicitHeight: Math.min(480, bg.implicitHeight)
  visible: centerWindow._mapped

  onOpenChanged: {
    if (open) centerWindow._mapped = true
    else closeTimer.restart()
  }
  Timer { id: closeTimer; interval: 250; onTriggered: centerWindow._mapped = false }

  MouseArea {
    anchors.fill: parent
    onClicked: centerWindow.open = false
    z: -10
  }

  Rectangle {
    id: bg
    width: parent.width
    implicitHeight: header.implicitHeight + list.contentHeight + 24
    height: Math.min(implicitHeight, 480)
    radius: 14
    color: Theme.inactiveBg
    border.width: 1
    border.color: Theme.comment
    clip: true

    scale: centerWindow.open ? 1 : 0.85
    opacity: centerWindow.open ? 1 : 0
    transformOrigin: Item.Top

    Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 2.5 } }
    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 12
      spacing: 8

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
