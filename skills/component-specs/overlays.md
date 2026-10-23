# Overlays

Everything that floats above the page shares the same problems: it escapes the viewport, the page scrolls behind it, it stacks under something else, or it closes the wrong way. Build them on a library that handles focus and positioning (Radix, Base UI, Ark, React Aria, or the native `<dialog>` and Popover API), never from a hand-made `position: fixed` div.

## Shared rules

- **One z-index scale** in tokens, used by every overlay: dropdown and popover `50`, sticky headers below them, modal `100`, toast `200`, tooltip `300`. No component invents its own number.
- **Portal to the body** (or use the top layer: `<dialog>.showModal()`, `popover`), so no parent `overflow: hidden` or `transform` clips it.
- **Same surface** for all floating panels: the app's raised background, border, radius and shadow tokens.
- **Animate from the origin.** Popovers and dropdowns scale from the side of the trigger (`transform-origin` from the library's CSS variable, such as `--radix-popover-content-transform-origin`), modals scale from the center, sheets slide from their edge. Exits are faster than enters. Reduced motion falls back to a fade.
- **Escape closes, focus returns** to the element that opened it.

## Nothing moves when a popup opens

Modal popups (dialogs, and by default Base UI and Radix selects and menus) lock page scroll. Hiding the scrollbar widens the content area by its width, about `15px` on desktop, so flexible columns grow, centered content jumps and the page twitches every time a select opens. Libraries compensate, and the bug appears when two compensations stack.

Use exactly one:

| Library | What it does on lock | What you do |
|---|---|---|
| Base UI | Sets `scrollbar-gutter: stable` on `<html>` while locked | Nothing. Do not add body margin or padding. A permanent `scrollbar-gutter: stable` on `html` is also fine. |
| Radix (shadcn on Radix), via `react-remove-scroll` | Adds `margin-right: <scrollbar width>` to `body[data-scroll-locked]` | Do **not** also set `scrollbar-gutter: stable` on `html`. If the project needs it (to stop shifts between short and long pages), cancel Radix's margin with a more specific selector: `html body[data-scroll-locked] { margin-right: 0 !important; }`. The plain `body[...]` version loses, because Radix injects its own `!important` rule when the popup opens, after yours. |
| Native `<dialog>` and Popover API | Nothing | `scrollbar-gutter: stable` on `html` |

Fixed elements (headers, bottom bars, toasts) are outside that compensation: with Radix they need the `right-scroll-bar-position` class, with Base UI the gutter covers them.

A dropdown that does not need to block the page can skip the lock entirely: `modal={false}` on Base UI Select and Menu, `modal={false}` on Radix DropdownMenu.

Verify by opening each popup and measuring a flexible neighbor:

```js
const w = () => document.querySelector('#neighbor').getBoundingClientRect().width;
const before = w();  // then open the select
// after opening:
console.log(w() - before);  // must be 0
```

## Dialog and alert dialog

- Width: `min(100% - 32px, 480px)` for forms and confirmations, larger tokens for content dialogs; never full-bleed on desktop.
- Height: `max-height: calc(100dvh - 32px)`, with the header and footer fixed and the **body scrolling inside**. A long dialog never pushes its buttons off screen.
- The page behind does not scroll (the library's scroll lock), and nothing shifts when the scrollbar disappears. See [Nothing moves when a popup opens](#nothing-moves-when-a-popup-opens).
- Footer: actions aligned to the end, primary last, the same button sizes as the rest of the app. On mobile, buttons stack full width.
- Alert dialog (destructive confirmation): no close on overlay click, focus starts on the cancel button, the destructive button says what it does ("Excluir pedido", not "OK").
- Close button: an icon button in the top end corner, at least `32px`, the icon centered (see [alignment.md](alignment.md#icons-inside-controls)).

## Sheet and drawer

- Sheet: slides from a side on desktop, `min(100% - 48px, 400px)` wide for forms, full height, body scrolls inside like the dialog.
- Drawer: a bottom sheet on mobile, with a drag handle, swipe to dismiss, and snap points when content varies. Use it instead of a centered dialog on small screens for menus, filters and pickers.
- Respect safe areas: `padding-bottom: env(safe-area-inset-bottom)` on bottom sheets.

## Popover, dropdown, context menu, hover card

- Positioned by the library with collision handling: flips to the other side and shifts to stay inside the viewport with an `8px` margin. Never a fixed `top`/`left`.
- Width: at least the trigger's width for selects and comboboxes; content-based for menus, with a max width so long labels truncate.
- Max height relative to the available space (`var(--radix-popper-available-height)` or the library's equivalent), with internal scroll.
- Offset `4px` to `8px` from the trigger, the same everywhere.
- Menu items: one height (`--control-h-sm`), icon slot of fixed width so labels align, shortcut hints end-aligned in a muted `Kbd`, separators between groups, destructive items in the destructive color.
- Hover card: open delay about `500ms`, close delay about `300ms`, never the only way to reach the information (touch has no hover).

## Tooltip

- Only for short labels, mostly on icon buttons. Never put essential or interactive content in a tooltip.
- Delay about `500ms` on the first tooltip, then instant while moving between triggers (Radix `delayDuration` with `skipDelayDuration`). No animation after the first one in a group.
- Does not cover the trigger: placed above or beside with a small offset.
- Shows on keyboard focus as well as hover; on touch it does not appear, so the element needs an accessible name of its own.

## Toast

- One toast system for the app (Sonner, or the library's), in one position (usually bottom end on desktop, top or bottom center on mobile).
- Stacks newest on top, limits the visible count (three), pauses the timer on hover and when the window loses focus.
- Duration about `4s` for information, longer or persistent for errors and anything with an action. An undo action outlives the default.
- Success, error, warning and info variants share the layout and differ by icon and color token only.
- Announced to screen readers through a live region (built into Sonner and Radix Toast).
- Never use a toast for an error the user must fix in a form; that belongs next to the field.
