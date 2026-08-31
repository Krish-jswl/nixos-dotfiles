import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

// Talks to Pipewire directly (Quickshell.Services.Pipewire) instead of
// shelling out to wpctl. Updates instantly and reacts to volume changes
// made anywhere else on the system too (media keys, pavucontrol, etc).
Scope {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink?.audio?.muted ?? false
  readonly property real volume: sink?.audio?.volume ?? 0
  readonly property bool ready: (sink?.ready ?? false) && sink?.audio !== undefined

  // keeps the sink's properties (volume/muted) bound and live-updating
  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
  }

  function setVolume(v) {
    if (!root.ready) return
    const clamped = Math.max(0, Math.min(1.5, v))
    root.sink.audio.muted = false
    root.sink.audio.volume = clamped
  }

  function adjust(delta) {
    root.setVolume(root.volume + delta)
  }

  function toggleMute() {
    if (!root.ready) return
    root.sink.audio.muted = !root.sink.audio.muted
  }
}
