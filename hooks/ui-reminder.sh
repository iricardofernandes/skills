#!/usr/bin/env bash
# UserPromptSubmit: remind the model to load the right skills before acting.
# UI prompts get the component skills, bug reports get the debug loop. Silent otherwise.
input="$(cat)"

ui_terms='\b(ui|ux|interface|layout|design|page|screen|component|components|form|table|data ?table|select|combobox|dropdown|input|checkbox|radio|switch|toggle|slider|date ?picker|calendar|button|modal|dialog|sheet|drawer|popover|tooltip|toast|tabs|sidebar|navbar|nav|card|badge|avatar|skeleton|css|tailwind|shadcn|styl(e|ing)|p[aá]gina|tela|componente|componentes|formul[aá]rio|tabela|bot[aã]o|filtro|filtros|estilo|estiliza[cç][aã]o)\b'

if printf '%s' "$input" | grep -qiE "$ui_terms"; then
  cat <<'MSG'
This request involves UI. Before writing or changing any UI code:
1. Invoke the `components` skill: look for an existing component to reuse or extend before creating one, extract a shared component the second time a pattern appears, and keep the project's `## UI components` inventory in CLAUDE.md up to date.
2. Invoke the `component-specs` skill and read the reference file for each component family you build (controls, alignment, dates, tables, overlays, navigation, feedback).
MSG
fi

bug_terms='\b(bug|bugs|broken|breaks|crash(es|ed)?|error|fails?|failing|regression|flicker(s|ing)?|jumps?|shifts?|glitch|debug|diagnose|quebr(ou|ado|ada|a)|n[aã]o funciona|erro|falha|travou|trava|bugado|bugou|pula|pulando|mexe|mexida|mexendo|treme|tremendo|aumentada e diminu[ií]da|desalinhad[oa]|torto|torta)\b'

if printf '%s' "$input" | grep -qiE "$bug_terms"; then
  cat <<'MSG'
This request reports a bug. Your first tool call is the Skill tool with `debug`. Follow its loop: a command that goes red on the user's symptom (for visual bugs, a measuring script from its visual.md) before reading code for a cause or editing anything.
MSG
fi
exit 0
