# Tables

A table exists so people can scan and compare rows. Squeezing every column into the viewport destroys that: text wraps into tall rows, numbers break across lines and nothing lines up. The defaults below favor scrolling over squeezing.

## Defaults

1. **Horizontal scroll, not squeezed columns.** The table keeps each column at its natural or set width and the wrapper scrolls horizontally when they do not fit.
2. **Columns are resizable** by dragging the header edge, with a minimum width per column.
3. **The header is sticky** while the body scrolls vertically.
4. **The first column can be sticky** horizontally when it identifies the row (name, ID).
5. **Cells do not wrap by default.** Long text truncates with an ellipsis and shows the full value on hover or focus.

## Structure

```html
<div class="table-wrap" role="region" aria-label="Orders" tabindex="0">
  <table class="table">
    <colgroup>
      <col style="width: var(--col-id)" />
      <col style="width: var(--col-customer)" />
      …
    </colgroup>
    <thead>…</thead>
    <tbody>…</tbody>
  </table>
</div>
```

```css
.table-wrap {
  overflow: auto;              /* both axes; give it a max-height for a sticky header inside a page */
  max-block-size: var(--table-max-h, none);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  background: var(--surface);  /* the same color the sticky cells use, so they blend with the rows */
  overscroll-behavior-x: contain;
}
.table {
  inline-size: 0;              /* with fixed layout, the table becomes the sum of its columns */
  min-inline-size: 100%;       /* and still fills the wrapper when the columns are narrower */
  table-layout: fixed;         /* widths come from <col>, not from the content */
  border-collapse: separate;   /* sticky cells keep their borders */
  border-spacing: 0;
}
.table th, .table td {
  padding: 0 12px;
  block-size: 40px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  border-block-end: 1px solid var(--border);
  text-align: start;
}
.table thead th {
  position: sticky;
  inset-block-start: 0;
  z-index: 2;
  background: var(--surface-raised);
  font-weight: 500;
  color: var(--text-muted);
}
.table .is-sticky-start {
  position: sticky;
  inset-inline-start: 0;
  z-index: 1;
  background: var(--surface);  /* opaque, or scrolled cells show through */
  box-shadow: inset -1px 0 var(--border);  /* divider so scrolled content does not run into it */
}
.table thead .is-sticky-start { z-index: 3; }
```

- Do not use `width: max-content` or `width: auto` on the table. Browsers only apply `table-layout: fixed` when the table has a definite width, so those fall back to automatic layout, the content dictates the widths and resizing has no effect. `width: 0` plus `min-width: 100%` is definite, and in fixed layout the table takes the larger of that and the sum of the columns. With TanStack, set `width: table.getTotalSize()` instead.
- The wrapper is focusable (`tabindex="0"`) with an accessible name, so keyboard users can scroll it.
- Show that more content exists: a fading shadow on the edge that has hidden columns (scroll-driven or toggled by a scroll listener), and a visible scrollbar on desktop. Never hide the scrollbar on a scrollable table.
- Sticky header and sticky column need opaque backgrounds and `border-collapse: separate`; with `collapse`, borders disappear when cells stick.

## Column widths and resizing

Give every column a default and a minimum by content type:

| Content | Default | Minimum |
|---|---|---|
| Checkbox (selection) | `40px` fixed | not resizable |
| ID, code | `96px` | `64px` |
| Name, title | `240px` | `120px` |
| Email, URL | `220px` | `120px` |
| Status badge | `120px` | `96px` |
| Date | `120px` | `104px` |
| Money, number | `120px` | `80px` |
| Actions | fit the buttons, fixed | not resizable |

Resize handle:

- An `8px` hit area **inside** the right edge of each header cell (`inset-inline-end: 0`), `cursor: col-resize`, with a `1px` or `2px` line on the edge that appears on hover and while dragging. Never let it straddle into the next cell (`-right-1`, `-4px`): sticky headers each create their own stacking context, so the next header paints over that half and the handle's center, where people aim, is dead. Check with `document.elementFromPoint` at the handle's center.
- Pointer events with `setPointerCapture`, so the drag keeps tracking outside the header. Read the starting width from the header cell (`th.getBoundingClientRect()`), not from the `<col>`, which has no reliable box. Clamp to the column's minimum, and clean up on `lostpointercapture` as well as `pointerup`.
- Double click on the handle resets the column to its default width.
- Keyboard: the handle is focusable and Arrow Left and Right resize by `16px`.
- Persist widths per table in `localStorage` when the user would expect them to stick (data-heavy admin screens).
- Resizing changes only that column; the table grows or shrinks and the wrapper scrolls. Never redistribute the other columns.

With TanStack Table (shadcn's `DataTable`):

```tsx
const table = useReactTable({
  data,
  columns,                                  // each column: size, minSize, maxSize
  columnResizeMode: 'onChange',
  enableColumnResizing: true,
  defaultColumn: { size: 160, minSize: 80 },
  getCoreRowModel: getCoreRowModel(),
});

// Widths as CSS variables, computed once per resize, so rows do not re-render while dragging
const columnSizeVars = useMemo(() => {
  const vars: Record<string, number> = {};
  for (const header of table.getFlatHeaders()) {
    vars[`--header-${header.id}-size`] = header.getSize();
    vars[`--col-${header.column.id}-size`] = header.column.getSize();
  }
  return vars;
}, [table.getState().columnSizingInfo, table.getState().columnSizing]);

<table style={{ ...columnSizeVars, width: table.getTotalSize() }}>
  …
  <th style={{ width: `calc(var(--header-${header.id}-size) * 1px)` }}>
    {flexRender(header.column.columnDef.header, header.getContext())}
    {header.column.getCanResize() && (
      <div
        onDoubleClick={() => header.column.resetSize()}
        onMouseDown={header.getResizeHandler()}
        onTouchStart={header.getResizeHandler()}
        className="resize-handle"
        data-resizing={header.column.getIsResizing() || undefined}
      />
    )}
  </th>
```

For very wide tables or many rows, memoize the body while resizing and virtualize rows beyond a few hundred.

## Cells

- **Numbers and money:** right-aligned, `font-variant-numeric: tabular-nums`, the header right-aligned too. Same decimal places within a column. Currency formatted with `Intl.NumberFormat` in the app's locale.
- **Dates:** one format per app (see [dates.md](dates.md)); relative ("há 2 dias") only where recency matters, with the full date on hover.
- **Text:** truncate with ellipsis; full value in a tooltip or `title`, and available when the row is opened.
- **Status:** the app's badge component, not colored text.
- **Empty value:** a muted em dash (`—`), never blank and never `null`.
- **Row height:** fixed per density (`32px` compact, `40px` default, `48px` comfortable). Cells never wrap unless the column is explicitly a multi-line column.

## Rows and actions

- Hover background on rows, instant (no transition).
- Clickable rows: the whole row is a link or opens a detail, with a visible focus state; inner buttons stop propagation.
- Row actions in the last column, fixed width, as an icon button with a dropdown. Keep them visible, or visible on row hover **and** on row focus. Hover-only actions are unreachable by keyboard and touch.
- Selection: checkbox column first, header checkbox with indeterminate state, and a bulk action bar that appears when rows are selected.

## States

| State | Treatment |
|---|---|
| Loading | Skeleton rows matching the real row height and column count, header visible |
| Empty | Header visible, one full-width cell with a message and the primary action ("Nenhum pedido ainda. Criar pedido") |
| No results for filter | Different message from empty, with "Limpar filtros" |
| Error | Message and retry, header visible |
| Refreshing | Keep the old rows, show a subtle progress indicator; never flash to skeletons |

## Toolbar and pagination

- Toolbar above the table: search, filters, column visibility, density, export. Same control heights as the rest of the app.
- Pagination below, aligned to the end: rows per page select, "1–20 de 312", previous and next icon buttons. One pagination component for the whole app.
- Sorting: click the header; an arrow shows the direction and `aria-sort` reflects it. Sort icons occupy a fixed slot so headers do not shift.

## Mobile

Keep the horizontal scroll with the sticky first column. Convert to cards only when each row is read on its own (a list of orders on a phone), and then build the card as its own component, not as a table with `display: block` hacks.
