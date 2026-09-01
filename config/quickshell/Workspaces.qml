import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
  id: root
  property var niri
  property string output: ""   // "" = all outputs, or filter to one monitor's name

  function sortedWorkspaces() {
    let list = (root.niri && root.niri.workspaces) ? root.niri.workspaces.slice() : []
    if (root.output !== "") list = list.filter(w => w.output === root.output)
    list.sort((a, b) => a.idx - b.idx)
    return list
  }

  implicitWidth: bg.implicitWidth
  implicitHeight: 24

  Rectangle {
    id: bg
    height: 24
    implicitWidth: rowLay.implicitWidth + 20
    radius: height / 2
    color: Theme.bg

    RowLayout {
      id: rowLay
      anchors.centerIn: parent
      spacing: 7

      Repeater {
        model: root.sortedWorkspaces()
        delegate: Rectangle {
          Layout.alignment: Qt.AlignVCenter
          width: modelData.is_focused ? 18 : 8
          height: 8
          radius: 4
          color: modelData.is_urgent ? Theme.wsUrgent
                 : modelData.is_focused ? Theme.wsFocused
                 : (modelData.is_active ? Theme.wsActive : Theme.comment)

          Behavior on width { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
          Behavior on color { ColorAnimation { duration: 140 } }

          MouseArea {
            anchors.fill: parent
            anchors.margins: -6
            cursorShape: Qt.PointingHandCursor
            onClicked: root.niri.focusWorkspace(modelData.idx)
          }
        }
      }
    }
  }
}
