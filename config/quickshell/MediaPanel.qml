import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris

PopupWindow {
  id: panel
  property bool open: false
  property bool _mapped: false
  property var player   // pass in the currently active MprisPlayer (or null)
  property var anchorItem: null   // the Pill that triggers this panel

  anchor.item: panel.anchorItem
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.margins.top: 8

  color: "transparent"
  implicitWidth: 280
  implicitHeight: card.implicitHeight
  visible: panel._mapped

  // keep the window mapped a little longer than "open" so the close
  // animation has time to play before the surface disappears
  onOpenChanged: {
    if (open) panel._mapped = true
    else closeTimer.restart()
  }
  Timer { id: closeTimer; interval: 250; onTriggered: panel._mapped = false }

  MouseArea {
    anchors.fill: parent
    onClicked: panel.open = false
    z: -10
  }

  readonly property bool hasArt: panel.player && panel.player.trackArtUrl !== ""

  // MPRIS position doesn't update every frame on its own - nudge it while
  // the panel is open and something is playing, per the Quickshell docs.
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

  Rectangle {
    id: card
    width: parent.width
    implicitHeight: col.implicitHeight + 24
    radius: 18
    color: "#1c1c24"   // inactiveBg
    border.width: 1
    border.color: "#606079"   // comment

    scale: panel.open ? 1 : 0.85
    opacity: panel.open ? 1 : 0
    transformOrigin: Item.Top

    Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 2.5 } }
    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

    ColumnLayout {
      id: col
      anchors.fill: parent
      anchors.margins: 12
      spacing: 10

      ClippingRectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        radius: 14
        color: "#141415"   // bg

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
          text: "󰝚"   // music-note glyph for the no-art placeholder
          color: "#606079"   // comment
          font.pixelSize: 40
          font.family: "Iosevka Nerd Font"
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Text {
          text: panel.player ? (panel.player.trackTitle || "Unknown title") : "Nothing playing"
          color: "#cdcdcd"   // fg
          font.family: "Iosevka Nerd Font"
          font.pixelSize: 15
          font.bold: true
          elide: Text.ElideRight
          Layout.fillWidth: true
        }
        Text {
          text: panel.player ? (panel.player.trackArtist || "Unknown artist") : ""
          color: "#606079"   // comment
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
          color: "#333738"   // visual

          Rectangle {
            height: parent.height
            radius: 2
            color: "#f3be7c"   // warning
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
            color: "#606079"; font.pixelSize: 10; font.family: "Iosevka Nerd Font"
          }
          Item { Layout.fillWidth: true }
          Text {
            text: panel.formatTime(panel.player ? panel.player.length : 0)
            color: "#606079"; font.pixelSize: 10; font.family: "Iosevka Nerd Font"
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        spacing: 26

        Text {
          text: "⏮"
          color: (panel.player && panel.player.canGoPrevious) ? "#cdcdcd" : "#3a3a3d"
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
          color: "#f3be7c"   // warning
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
          color: (panel.player && panel.player.canGoNext) ? "#cdcdcd" : "#3a3a3d"
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
