import Quickshell
import Quickshell.Io
import QtQuick

// Talks to niri's `niri msg -j event-stream` to keep a live, push-updated
// view of workspaces and windows (no polling delay). Exposes a couple of
// action helpers to switch focus from the bar.
Scope {
  id: root

  property var workspaces: []   // array of {id, idx, name, output, is_active, is_focused, is_urgent, active_window_id}
  property var windows: []      // array of {id, title, app_id, pid, workspace_id, is_focused, is_floating, is_urgent}
  property int focusedWorkspaceId: -1
  property int focusedWindowId: -1

  function focusWorkspace(idx) {
    actionProc.command = ["niri", "msg", "action", "focus-workspace", String(idx)]
    actionProc.running = true
  }

  function focusWindow(id) {
    actionProc.command = ["niri", "msg", "action", "focus-window", "--id", String(id)]
    actionProc.running = true
  }

  Process {
    id: actionProc
    command: ["true"]
  }

  Process {
    id: stream
    command: ["niri", "msg", "-j", "event-stream"]
    running: true
    stdout: SplitParser {
      onRead: line => root.handleEvent(line)
    }
    onRunningChanged: {
      if (!running) restartTimer.restart()
    }
  }

  // If niri restarts or the socket hiccups, try reconnecting.
  Timer {
    id: restartTimer
    interval: 2000
    onTriggered: stream.running = true
  }

  function handleEvent(line) {
    if (!line || line.length === 0) return
    let ev
    try {
      ev = JSON.parse(line)
    } catch (e) {
      return
    }

    if (ev.WorkspacesChanged) {
      const list = ev.WorkspacesChanged.workspaces || []
      root.workspaces = list
      const f = list.find(w => w.is_focused)
      root.focusedWorkspaceId = f ? f.id : -1

    } else if (ev.WorkspaceActivated) {
      const id = ev.WorkspaceActivated.id
      const focused = !!ev.WorkspaceActivated.focused
      const list = root.workspaces.slice()
      const target = list.find(w => w.id === id)
      if (target) {
        for (const w of list) {
          if (w.output === target.output) w.is_active = (w.id === id)
          if (focused) w.is_focused = (w.id === id)
        }
        if (focused) root.focusedWorkspaceId = id
      }
      root.workspaces = list

    } else if (ev.WorkspaceUrgencyChanged) {
      const id = ev.WorkspaceUrgencyChanged.id
      const urgent = !!ev.WorkspaceUrgencyChanged.urgent
      const list = root.workspaces.slice()
      const target = list.find(w => w.id === id)
      if (target) target.is_urgent = urgent
      root.workspaces = list

    } else if (ev.WindowsChanged) {
      const list = ev.WindowsChanged.windows || []
      root.windows = list
      const f = list.find(w => w.is_focused)
      root.focusedWindowId = f ? f.id : -1

    } else if (ev.WindowOpenedOrChanged) {
      const w = ev.WindowOpenedOrChanged.window
      const list = root.windows.slice()
      const idx = list.findIndex(x => x.id === w.id)
      if (idx >= 0) list[idx] = w
      else list.push(w)
      root.windows = list
      if (w.is_focused) root.focusedWindowId = w.id

    } else if (ev.WindowClosed) {
      const id = ev.WindowClosed.id
      root.windows = root.windows.filter(w => w.id !== id)
      if (root.focusedWindowId === id) root.focusedWindowId = -1

    } else if (ev.WindowFocusChanged) {
      const id = ev.WindowFocusChanged.id ?? -1
      root.focusedWindowId = id
      const list = root.windows.slice()
      for (const w of list) w.is_focused = (w.id === id)
      root.windows = list
    }
  }
}
