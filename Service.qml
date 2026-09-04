import QtQuick
import Quickshell
import Quickshell.Io

// Headless service: when enabled, steal Super++ / Super+- from Omarchy's
// window-resize binds and dispatch app-level text zoom instead.
Item {
  id: root

  property var shell: null

  readonly property string pluginDir: {
    var url = Qt.resolvedUrl(".")
    var path = url.toString()
    if (path.indexOf("file://") === 0)
      path = path.substring(7)
    if (path.length > 1 && path.charAt(path.length - 1) === "/")
      path = path.substring(0, path.length - 1)
    return path
  }

  readonly property string bindHelper: pluginDir + "/bin/omarchy-zoom-binds"
  readonly property string zoomHelper: pluginDir + "/bin/omarchy-zoom"

  property string pendingAction: ""

  function runBinds(mode) {
    bindsProcess.command = ["bash", bindHelper, mode]
    bindsProcess.running = true
  }

  function zoom(action) {
    pendingAction = action
    zoomProcess.command = ["bash", zoomHelper, action]
    zoomProcess.running = true
  }

  Process { id: bindsProcess }
  Process { id: zoomProcess }

  Component.onCompleted: root.runBinds("install")
  Component.onDestruction: root.runBinds("remove")

  IpcHandler {
    target: "zoom-in-out"

    function zoomIn(): string {
      root.zoom("in")
      return "in"
    }

    function zoomOut(): string {
      root.zoom("out")
      return "out"
    }

    function reset(): string {
      root.zoom("reset")
      return "reset"
    }
  }
}
