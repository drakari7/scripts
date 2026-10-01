#!/usr/bin/env bash
anchor_friday="2026-09-25"
days_since=$(( ($(date +%s) - $(date -d "$anchor_friday" +%s)) / 86400 ))
case $(( ((days_since % 14) + 14) % 14 )) in
  13|0)
    echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"The sprint ends this week (Thursday/Friday). Start your first reply by reminding the user to log time on their Jira tickets."}}'
    ;;
esac
