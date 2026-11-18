# Adapter: FigCraft (FigCraft MCP)

How the skill's verbs map to the FigCraft MCP tools. FigCraft builds layers with commands, not HTML: auto layout frames, text, components with variants, and variables. Attached to the open app (`figcraft-cli mcp --attach <port>`) every step shows on screen; headless (`figcraft-cli mcp`) it edits the file. Parameters for every call: [figcraft-commands.md](../figcraft-commands.md).

| Skill verb | In FigCraft |
|---|---|
| Start | `inspect_ui`, then `inspect_document {outline: true, allPages: true}` for pages and boards. An unsaved document: `save_file {path: "design.figcraft"}` in the project folder first |
| Read the design system | `variable.export {format: "css"}` for tokens; the guide page from `inspect_document`; `get_node {id, outline: true}` on its boards |
| Read exact values | `get_node {id, fields}` or `inspect.code {id, language: "css"}`. Never read sizes or colours from a screenshot |
| Create a board | `page.add`/`page.select` for the page, then a top-level `create_node {type: "frame"}` with vertical `layout` and `sizingV: "hug"`, named `<n> · <page> · <state>`, one row per page, in the order of the confirmed scope |
| Build a section | One `batch` per visual group: auto layout frames, then text. Colours bind with `$var`, radius and spacing with `variable.bind`. Name every layer after what it is |
| Reuse a piece | Instances, never copied layers: `instance.create`, then `instance.setProperties` for what changes per copy |
| Make a state variant of a board | `edit.duplicate {ids: [board]}`, `object.rename`, then change only what the state changes |
| Look at it | `screenshot {ids: [board]}` after each section (raise `scale` only for small text) |
| Fix clipping | Boards hug their height; don't guess heights |
| Temporary exploration area | A page `Exploration · <topic>` (`page.add`), deleted after the pick |
| Finish | `save_file` so the work is on disk; tell the person the file name |

Notes:
- Inter is built into FigCraft; for other families check `text.missingFonts` before the first text.
- Icons are SVG files in a folder of the project, imported once as components (the app reads only inside the project).
- Repeated rows: fixed-width slots for icons and trailing actions, so columns line up.
- Don't show layer ids to the person; refer to boards by name.
