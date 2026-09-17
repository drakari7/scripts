#!/bin/bash
input=$(cat)
dir=$(echo "$input" | jq -r '.cwd')
msg=$(echo "$input" | jq -r '.message // empty')
urgency=${1:-normal}

# Skip if this session's pane is in the currently visible tab
if [ -n "$WEZTERM_PANE" ]; then
  panes=$(wezterm cli list --format json)
  my_tab=$(echo "$panes" | jq -r --arg p "$WEZTERM_PANE" '.[] | select(.pane_id == ($p|tonumber)) | .tab_id')
  focused_pane=$(wezterm cli list-clients --format json | jq -r '.[0].focused_pane_id')
  focused_tab=$(echo "$panes" | jq -r --arg p "$focused_pane" '.[] | select(.pane_id == ($p|tonumber)) | .tab_id')
  [ -n "$my_tab" ] && [ "$my_tab" = "$focused_tab" ] && exit 0
fi

if [ -n "$msg" ]; then
  # Notification event
  msg="Input needed: $msg"
else
  # Stop event → tail of Claude's last reply
  transcript=$(echo "$input" | jq -r '.transcript_path')
  if [ -f "$transcript" ]; then
    reply=$(tac "$transcript" | jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null | head -1 | cut -c1-120)
  fi
  msg="Reply: ${reply:-Task finished ✅}"
fi

notify-send -i ~/.claude/claude-icon.png -u "$urgency" "Claude Code · $dir" "$msg"
