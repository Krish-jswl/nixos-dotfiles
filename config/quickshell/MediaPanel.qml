import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris

PopupWindow {
  id: panel
  property bool open: false
  property bool _mapped: false
  property var player
  property var anchorItem: null
  anchor.item: panel.anchorItem
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.margins.top: 8

  color: "transparent"

  readonly property real fullWidth: 280
  readonly property real fullHeight: col.implicitHeight + 24

  implicitWidth: panel.fullWidth
  implicitHeight: panel.fullHeight
  visible: panel._mapped

  onOpenChanged: {
    if (open) panel._mapped = true
    else closeTimer.restart()
  }
  Timer { id: closeTimer; interval: 260; onTriggered: panel._mapped = false }

  MouseArea {
    anchors.fill: parent
    onClicked: panel.open = false
    z: -10
    enabled: panel.open
  }

  readonly property bool hasArt: panel.player && panel.player.trackArtUrl !== ""

  Timer {
    running: panel.open && panel.player && panel.player.playbackState === MprisPlaybackState.Playing
    interval: 1000
    repeat: true
    onTriggered: panel.player.positionChanged()
  }

  function formatTime(seconds) {
    if (!seconds || seconds < 0) seconds = 0
    const m = Math.floor(seconds / 60)
    const s = Math.floor(seconds % 60)
    return m + ":" + (s < 10 ? "0" : "") + s
  }

  readonly property real srcWidth: panel.anchorItem ? panel.anchorItem.width : 40
  readonly property real srcHeight: panel.anchorItem ? panel.anchorItem.height : 24

  Rectangle {
    id: card
    x: 0
    y: 0
    width: panel.open ? panel.fullWidth : panel.srcWidth
    height: panel.open ? panel.fullHeight : panel.srcHeight
    radius: panel.open ? 18 : height / 2
    color: panel.open ? Theme.inactiveBg : Theme.bg
    border.width: panel.open ? 1 : 0
    border.color: Theme.comment
    clip: true

    Behavior on width        { NumberAnimation { duration: 320; easing.type: Easing.OutExpo } }
    Behavior on height       { NumberAnimation { duration: 320; easing.type: Easing.OutExpo } }
    Behavior on radius       { NumberAnimation { duration: 320; easing.type: Easing.OutExpo } }
    Behavior on color        { ColorAnimation  { duration: 220 } }
    Behavior on border.width { NumberAnimation { duration: 220 } }

    ColumnLayout {
      id: col
      anchors.fill: parent
      anchors.margins: 12
      spacing: 10

      opacity: panel.open ? 1 : 0
      scale: panel.open ? 1 : 0.9
      transformOrigin: Item.Top

      Behavior on opacity {
        SequentialAnimation {
          PauseAnimation { duration: panel.open ? 140 : 0 }
          NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
        }
      }
      Behavior on scale {
        SequentialAnimation {
          PauseAnimation { duration: panel.open ? 140 : 0 }
          NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
      }

      ClippingRectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        radius: 14
        color: Theme.bg

        Image {
          anchors.fill: parent
          source: panel.hasArt ? panel.player.trackArtUrl : ""
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          visible: panel.hasArt
        }

        Text {
          anchors.centerIn: parent
          visible: !panel.hasArt
          text: "󰝚"
          color: Theme.comment
          font.pixelSize: 40
          font.family: "Iosevka Nerd Font"
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Text {
          text: panel.player ? (panel.player.trackTitle || "Unknown title") : "Nothing playing"
          color: Theme.fg
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 15
          font.bold: true
          elide: Text.ElideRight
          Layout.fillWidth: true
        }
        Text {
          text: panel.player ? (panel.player.trackArtist || "Unknown artist") : ""
          color: Theme.comment
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 12
          elide: Text.ElideRight
          Layout.fillWidth: true
          visible: text !== ""
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 4
        visible: !!(panel.player && panel.player.lengthSupported)

        Rectangle {
          id: track
          Layout.fillWidth: true
          height: 4
          radius: 2
          color: Theme.trackBg

          Rectangle {
            height: parent.height
            radius: 2
            color: Theme.warning
            width: (panel.player && panel.player.length > 0)
                   ? track.width * Math.min(1, panel.player.position / panel.player.length)
                   : 0
            Behavior on width { NumberAnimation { duration: 250 } }
          }

          MouseArea {
            anchors.fill: parent
            enabled: !!(panel.player && panel.player.canSeek)
            cursorShape: Qt.PointingHandCursor
            onClicked: mouse => {
              if (panel.player && panel.player.length > 0) {
                panel.player.position = (mouse.x / width) * panel.player.length
              }
            }
          }
        }

        RowLayout {
          Layout.fillWidth: true
          Text {
            text: panel.formatTime(panel.player ? panel.player.position : 0)
            color: Theme.comment; font.pixelSize: 10; font.family: "Iosevka Nerd Font"
          }
          Item { Layout.fillWidth: true }
          Text {
            text: panel.formatTime(panel.player ? panel.player.length : 0)
            color: Theme.comment; font.pixelSize: 10; font.family: "Iosevka Nerd Font"
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        spacing: 26

        Text {
          text: "⏮"
          color: (panel.player && panel.player.canGoPrevious) ? Theme.fg : Theme.disabled
          font.pixelSize: 20
          MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            enabled: !!(panel.player && panel.player.canGoPrevious)
            cursorShape: Qt.PointingHandCursor
            onClicked: panel.player.previous()
          }
        }

        Text {
          text: (panel.player && panel.player.isPlaying) ? "⏸" : "▶"
          color: Theme.warning
          font.pixelSize: 26
          MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            enabled: !!(panel.player && panel.player.canTogglePlaying)
            cursorShape: Qt.PointingHandCursor
            onClicked: panel.player.togglePlaying()
          }
        }

        Text {
          text: "⏭"
          color: (panel.player && panel.player.canGoNext) ? Theme.fg : Theme.disabled
          font.pixelSize: 20
          MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            enabled: !!(panel.player && panel.player.canGoNext)
            cursorShape: Qt.PointingHandCursor
            onClicked: panel.player.next()
          }
        }
      }
    }
  }
}
