import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Scope {
  id: root

  property var active: []     // Notification objects currently shown as toasts
  property var history: []    // plain JS objects, newest first, for the notification center
  property int maxHistory: 50
  property int defaultTimeoutMs: 6000

  NotificationServer {
    id: server
    keepOnReload: false
    actionsSupported: true
    bodySupported: true
    bodyMarkupSupported: true
    bodyHyperlinksSupported: true
    imageSupported: true

    onNotification: notif => {
      notif.tracked = true

      const entry = {
        ntfId: notif.id,
        appName: notif.appName || "Notification",
        summary: notif.summary || "",
        body: notif.body || "",
        appIcon: notif.appIcon || "",
        image: notif.image || "",
        urgency: notif.urgency,
        time: Qt.formatTime(new Date(), "hh:mm")
      }
      const hist = root.history.slice()
      hist.unshift(entry)
      root.history = hist.slice(0, root.maxHistory)

      root.active = root.active.concat([notif])

      notif.closed.connect(() => {
        root.active = root.active.filter(n => n !== notif)
      })

      const t = autoDismiss.createObject(root, { targetNotif: notif })
      t.start()
    }
  }

  Component {
    id: autoDismiss
    Timer {
      property var targetNotif: null
      interval: root.defaultTimeoutMs
      running: false
      repeat: false
      onTriggered: {
        if (targetNotif && targetNotif.tracked) targetNotif.dismiss()
        destroy()
      }
    }
  }

  function dismiss(notif) {
    if (notif && notif.tracked) notif.dismiss()
  }

  function clearHistory() {
    root.history = []
  }

  // vague.nvim palette: error / warning / comment
  function urgencyColor(u) {
    if (u === NotificationUrgency.Critical) return "#d8647e"  // error
    if (u === NotificationUrgency.Low) return "#606079"       // comment
    return "#6e94b2"                                          // warning
  }
}
