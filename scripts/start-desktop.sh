#!/usr/bin/env bash
set -e

export USER="${USER:-ros}"
export HOME="${HOME:-/home/ros}"
export DISPLAY="${DISPLAY:-:1}"
export VNC_RESOLUTION="${VNC_RESOLUTION:-1440x900}"

mkdir -p "$HOME/.vnc"
chmod 700 "$HOME/.vnc"
NOVNC_WEB_ROOT="${HOME}/novnc"

vncserver -kill "$DISPLAY" >/dev/null 2>&1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

vncserver "$DISPLAY" \
  -geometry "$VNC_RESOLUTION" \
  -depth 24 \
  -localhost no \
  --I-KNOW-THIS-IS-INSECURE \
  -SecurityTypes None \
  -xstartup "$HOME/.vnc/xstartup"

rm -rf "$NOVNC_WEB_ROOT"
mkdir -p "$NOVNC_WEB_ROOT"
cp -R /usr/share/novnc/. "$NOVNC_WEB_ROOT"/

awk '
  {
    print
    if ($0 ~ /rfb.resizeSession = WebUtil.getConfigVar/) {
      print "            function sendGuestPaste(terminalPaste) {"
      print "                if (!rfb) return;"
      print "                var control = 0xffe3;"
      print "                var shift = 0xffe1;"
      print "                var v = 0x0076;"
      print "                rfb.sendKey(control, \"ControlLeft\", true);"
      print "                if (terminalPaste) rfb.sendKey(shift, \"ShiftLeft\", true);"
      print "                rfb.sendKey(v, \"KeyV\", true);"
      print "                rfb.sendKey(v, \"KeyV\", false);"
      print "                if (terminalPaste) rfb.sendKey(shift, \"ShiftLeft\", false);"
      print "                rfb.sendKey(control, \"ControlLeft\", false);"
      print "            }"
      print "            function pasteTextToGuest(text, terminalPaste) {"
      print "                if (!rfb || !text) return;"
      print "                rfb.clipboardPasteFrom(text);"
      print "                window.setTimeout(function() { sendGuestPaste(terminalPaste); }, 120);"
      print "            }"
      print "            var latestGuestClipboard = \"\";"
      print "            function copyTextToHostClipboard(text) {"
      print "                if (!text) return;"
      print "                if (navigator.clipboard && navigator.clipboard.writeText) {"
      print "                    navigator.clipboard.writeText(text).catch(function() {});"
      print "                }"
      print "            }"
      print "            rfb.addEventListener(\"clipboard\", function(e) {"
      print "                var text = e.detail && e.detail.text;"
      print "                if (!text) return;"
      print "                latestGuestClipboard = text;"
      print "                copyTextToHostClipboard(text);"
      print "            });"
      print "            document.addEventListener(\"keydown\", function(e) {"
      print "                var key = (e.key || \"\").toLowerCase();"
      print "                var isTerminalPaste = e.ctrlKey && e.shiftKey && key === \"v\";"
      print "                var isAppPaste = e.metaKey && key === \"v\";"
      print "                var isHostCopy = e.metaKey && key === \"c\";"
      print "                if (isHostCopy && latestGuestClipboard) {"
      print "                    e.preventDefault();"
      print "                    e.stopImmediatePropagation();"
      print "                    copyTextToHostClipboard(latestGuestClipboard);"
      print "                    return;"
      print "                }"
      print "                if (!isTerminalPaste && !isAppPaste) return;"
      print "                e.preventDefault();"
      print "                e.stopImmediatePropagation();"
      print "                if (!navigator.clipboard || !navigator.clipboard.readText) return;"
      print "                navigator.clipboard.readText().then(function(text) {"
      print "                    pasteTextToGuest(text, isTerminalPaste);"
      print "                });"
      print "            }, true);"
    }
  }
' "$NOVNC_WEB_ROOT/vnc_auto.html" > "$NOVNC_WEB_ROOT/vnc_hotkey.html"

cat > "$NOVNC_WEB_ROOT/index.html" <<'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="refresh" content="0; url=/vnc_hotkey.html?path=websockify&shared=true&scale=true">
    <title>ROS 2 Desktop</title>
  </head>
  <body>
    Redirecting to ROS 2 desktop...
  </body>
</html>
EOF

websockify --web="$NOVNC_WEB_ROOT" 6080 localhost:5901 &

echo ""
echo "ROS 2 desktop is running."
echo "Open: http://localhost:6080/"
echo ""
echo "Inside Ubuntu desktop, open Terminal and try:"
echo "  rviz2"
echo "  gazebo"
echo "  gz sim"
echo ""

tail -f "$HOME/.vnc/"*.log
