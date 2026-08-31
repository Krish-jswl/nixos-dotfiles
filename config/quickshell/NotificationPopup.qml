import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
  id: toastWindow
  property var notifications   // the Notifications.qml Scope instance

  anchors { top: true; right: true }
  margins { top: 44; right: 20 }
  exclusiveZone: 0
  color: "transparent"
  implicitWidth: 320
  implicitHeight: col.implicitHeight
  visible: notifications.active.length > 0

  ColumnLayout {
    id: col
    width: parent.width
    spacing: 8

    Repeater {
      model: toastWindow.notifications.active
      delegate: Rectangle {
        id: card
        Layout.fillWidth: true
        implicitHeight: inner.implicitHeight + 20
        radius: 12
        color: "#141415"   // inactiveBg
        border.width: 1
        border.color: toastWindow.notifications.urgencyColor(modelData.urgency)

        ColumnLayout {
          id: inner
          anchors.fill: parent
          anchors.margins: 10
          spacing: 4

          RowLayout {
            Layout.fillWidth: true
            spacing: 6
            Text {
              text: modelData.appName || "Notification"
              color: "#606079"   // comment
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 12
              Layout.fillWidth: true
              elide: Text.ElideRight
            }
            Text {
              text: ""   // paste a close-icon glyph here if you'd like one
              color: "#606079"
              font.family: "Iosevka Nerd Font"
              font.pixelSize: 13
              MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: toastWindow.notifications.dismiss(modelData)
              }
            }
          }

          Text {
            text: modelData.summary || ""
            color: "#cdcdcd"   // fg
            font.family: "Iosevka Nerd Font"
            font.pixelSize: 14
            font.bold: true
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            visible: text !== ""
          }
          Text {
            text: modelData.body || ""
            color: "#c3c3d5"   // property
            font.family: "Iosevka Nerd Font"
            font.pixelSize: 12
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            maximumLineCount: 4
            elide: Text.ElideRight
            visible: text !== ""
          }
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton
          onClicked: toastWindow.notifications.dismiss(modelData)
          z: -1
        }
      }
    }
  }
}
