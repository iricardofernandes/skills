# FigCraft commands

The calls the design skills use, with their real parameters. Every adapter's `figcraft.md` points here. A command not in this table: `list_commands {filter: "<id>"}` gives its parameters; read them before the first call, since a guessed parameter costs a failed round trip.

## Tools

| Tool | Parameters | Use |
|---|---|---|
| `inspect_document` | `{outline: true, allPages: true}` | Pages, boards and their ids |
| `get_node` | `{id, depth?, fields?, outline?}`; `fields` such as `name`, `absoluteBounds`, `layout`, `sizing`, `visible` | Exact values of one layer and its children |
| `create_node` | `{type, parent?, name?, x?, y?, width?, height?, text?, props?}` | One frame, text, rectangle, component… |
| `set_properties` | `{ids, props}` | Change layers (fills, strokes, radius, auto layout, text…) |
| `batch` | `{commands: [{command, params, as?}], label?}` | Several commands as one undo step; `{"$ref": "<as>"}` in a later step is the id an earlier step returned |
| `run_command` | `{command, params}` | Any command below |
| `screenshot` | `{ids?, scale?, maxSize?}` | PNG of a board or layers |
| `save_file` | `{path?}` | Write the `.figcraft` file |

## Commands (`run_command`)

| Command | Parameters |
|---|---|
| `page.add` / `page.select` | `{name?}` / `{id \| index}` |
| `edit.duplicate` | `{ids?, dx?, dy?, map?}`; `map: true` returns each original id → its copy |
| `edit.delete` | `{ids?}` |
| `object.rename` | `{ids?, name}` |
| `node.find` | `{root?, name?, type?, text?, limit?}`; without `root` it searches only the current page |
| `component.create` | `{ids?}` (a frame becomes a component) |
| `component.combineVariants` | `{ids?}`; name each main `Property=value` first (`State=Hover`) |
| `component.addVariant` | `{id}` |
| `component.addProperty` | `{id?, name, type: boolean\|text\|instanceSwap\|variant\|slot, default?, layer?}` |
| `component.bindProperty` | `{layer?, property, field?: visible\|characters\|mainComponent\|slot}` |
| `instance.create` | `{component, x?, y?, parent?}` (a set gives its default variant) |
| `instance.setProperties` | `{ids, properties}` |
| `variable.createCollection` | `{name}` |
| `variable.create` | `{collection, name, type, value}`; `/` in the name groups it (`color/primary`) |
| `variable.set` / `variable.bind` | change a value / bind a field that `$var` can't reach (radius, gap, padding) |
| `variable.export` | `{format: "css" \| "tailwind" \| "json"}` |
| `file.import` | `{path, x?, y?}` (an SVG comes in as editable layers) |
| `inspect.code` | `{id, language: "css" \| "tailwind" \| "react" …}` |

## Gotchas

- **Colours bind in place:** `{"fill": {"$var": "color/primary"}}` in `props` creates and binds in one step. Only `fill` and `stroke` take `$var`.
- **Auto layout places children:** set `layout`, `gap`, `padding`, `sizingH`/`sizingV`, `mainAlign`, `crossAlign`, never child `x`/`y`. Boards hug their height (`sizingV: "hug"`).
- **Files stay in the project:** the app only reads and writes inside the folders it was started with, so icons and images go in a folder of the project (`design/icons/*.svg`), never `/tmp`. Make each icon a component once (`file.import`, then `component.create`) and place instances.
- **Text props on the component, labels on the copy:** a button's label is a `text` component property, so every instance can say "Salvar", "Ver fatura" or "Excluir conta".
