# Reading a FigCraft file

How **Read the design at its source** gets values out of a `.figcraft` file. Run the FigCraft MCP headless (`figcraft-cli mcp`) and `open_file {path}` the file: the app the person has open stays untouched. Parameters for every call are in [the design skill's command table](../design/references/figcraft-commands.md).

## The calls

| Call | Gives you | Use it for |
| --- | --- | --- |
| `inspect_document {outline: true, allPages: true}` | Pages, boards, ids | Finding the boards in scope (`1 · <page> · <state>`) and the guide |
| `get_node {id, depth, fields: ["name", "absoluteBounds", "layout", "sizing", "visible"]}` | Exact boxes, auto layout and sizing of a subtree | Positions to compare against, and the layout intent |
| `inspect.code {id, language: "css"}` | One layer's CSS with its token references | Exact padding, gap, radius, border and colour of a component |
| `inspect.code {id, language: "tailwind"}` | The whole board as React + Tailwind | A reference for measurements only (see below) |
| `variable.export {format: "tailwind"}` | Every variable as `@theme` blocks | The starting point of the project's theme |
| `style.list` | Text and effect styles | Line heights, weights, font features and shadows |
| `figcraft-cli export --node <id> --out board.png <file>` | A PNG of one board | The comparison target |

## What to trust

- **Auto layout and sizing over boxes.** `sizing.vertical: "fixed"` with a height means the row is that tall whatever its content; `hug` with padding means padding plus content. A row that looks like "8px padding" may be a 52px minimum: read both before writing the class.
- **Hidden layers are not in the build.** `visible: false` children (a note, an icon, a spinner) are variant slots; build the slot, not the layer.
- **The generated React is a measuring tape, not code.** It draws icons as dozens of rotated divs and controls as `<p>` in `<div>`. Take its numbers; write semantic markup with the project's components.
- **The token export needs renaming.** It infers units from use and keeps the file's names: durations come out as `px`, control heights as `--spacing-md`, the type scale as `--type-*`. Map each into the project's namespaces (Tailwind: `--text-*` with `--line-height`, `--spacing-*`, `--radius-*`, durations in `ms`) and list every rename in the report.

## Comparing

- Compare at the board's width **of content**. A browser at the board's width loses the scrollbar's ~15px, so fixed-width columns shrink: set the viewport to the board width plus the scrollbar, or hide it, before measuring.
- Compare boxes first (`getBoundingClientRect` against `absoluteBounds` relative to the board), then pixels. Text antialiasing differs between FigCraft and the browser, so a pixel diff shows every glyph edge: what matters is a region that differs as a block.
