import QtQuick
import QtQuick.Layouts
import Quickshell

// vague.nvim palette reference (https://github.com/vague-theme/vague.nvim)
// bg #141415  inactiveBg #1c1c24  line #252530  fg #cdcdcd  comment #606079
// floatBorder #878787

Rectangle {
  id: root
  property string icon: ""
  property string label: ""
  property color iconColor: Theme.fg
  property color textColor: Theme.fg
  property int maxLabelWidth: 400
  property bool active: false
  property bool clickable: false

  signal clicked()
  signal rightClicked()
  signal wheel(int delta)

  implicitWidth: row.implicitWidth + 22
  implicitHeight: 24
  radius: height / 2
  color: root.active ? Theme.line : (ma.containsMouse && root.clickable ? Theme.inactiveBg : Theme.bg)
  border.width: root.active ? 1 : 0
  border.color: Theme.comment

  Behavior on color { ColorAnimation { duration: 120 } }

  RowLayout {
      id: row
      anchors.centerIn: parent
      spacing: 7
    Text {
      text: root.icon
      color: root.iconColor
      font.family: "Iosevka Nerd Font"
      font.pixelSize: 16
      visible: root.icon !== ""
    }
    Text {
      text: root.label
      color: root.textColor
      font.family: "Iosevka Nerd Font"
      font.pixelSize: 16
      elide: Text.ElideRight
      Layout.maximumWidth: root.maxLabelWidth
      visible: root.label !== ""
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: root.clickable
    enabled: root.clickable
    cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton) root.rightClicked()
      else root.clicked()
    }
    onWheel: wheelEvent => root.wheel(wheelEvent.angleDelta.y)
  }
}
