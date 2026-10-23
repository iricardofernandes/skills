---
name: component-specs
description: How common UI components should look and behave so they match the app instead of shipping browser defaults. Use when building or styling selects, comboboxes, inputs, checkboxes, radios, switches, sliders, textareas, date pickers, calendars, data tables, dialogs, sheets, drawers, popovers, dropdowns, tooltips, toasts, tabs, accordions, sidebars, pagination, skeletons, empty states, badges, avatars or buttons — with or without shadcn/ui, on Base UI by default. Triggers on layout shift when a select or popup opens, elements growing or shrinking on open, hover or focus, default-looking controls, select arrow touching the border, unstyled date picker, off-center checkmark, radio dot or switch thumb, misaligned controls, cramped or squeezed table columns, column resizing.
---

# Component specs

The exact behavior and styling of the components every app needs. Browser defaults and copy-pasted examples ship controls that ignore the app's tokens: a select with its arrow against the border, a native date input in light mode inside a dark app, a checkmark one pixel off center, a table squeezing twelve columns into one screen. This skill names the standard for each.

Whether a component should exist and what its API is belongs to `components`. Run that first, then build to the spec here.

## Universal rules

1. **Controls are one family.** Input, select, combobox, textarea, date field and button share the same height, radius, border, horizontal padding, font size, and focus, invalid and disabled styles, all from tokens. Put two side by side: their edges and baselines line up.
2. **Style from the project's tokens.** Never leave a control on the browser's colors, and never invent a one-off value inside a component.
3. **Every state is designed:** default, hover, focus-visible, active, disabled, invalid, read-only, loading, empty. A state you did not style is a state that looks broken.
4. **Indicators are centered by layout, not by offsets.** Checkmarks, radio dots, switch thumbs, chevrons and icons are centered with grid or flex on a box whose size leaves an even remainder. Never with `top`/`left` magic numbers. Read [alignment.md](alignment.md) before building any of them.
5. **Declare `color-scheme`.** Set `color-scheme: light dark` (or the app's single scheme) on `:root` and switch it with the theme, so native popups, scrollbars, date pickers and autofill follow the theme.
6. **Build on Base UI by default.** New project or no component library: `@base-ui/react`, or shadcn's Base UI components when the project uses shadcn. A project already on Radix, React Aria or another headless library keeps it. Fix visuals in the theme or the component file; never mix two libraries for the same role. Read [base-ui.md](base-ui.md).
7. **Nothing moves unless it was touched.** Opening a select, hovering a row, focusing an input or showing an error never changes the size or position of another element. The usual causes: double scrollbar compensation when a popup locks scroll, borders or font weight that change on hover or focus, error text inserted without reserved space. See [overlays.md](overlays.md#nothing-moves-when-a-popup-opens).

## Where each component's spec lives

| Building | Read |
|---|---|
| Base UI parts, data attributes, positioning variables | [base-ui.md](base-ui.md) |
| Checkbox, radio, switch, any centered indicator or icon | [alignment.md](alignment.md) |
| Input, input group, select, native select, combobox, textarea, slider, OTP, field, label, button | [controls.md](controls.md) |
| Date picker, calendar, date range, time | [dates.md](dates.md) |
| Table, data table, pagination | [tables.md](tables.md) |
| Dialog, alert dialog, sheet, drawer, popover, dropdown, context menu, hover card, tooltip, toast | [overlays.md](overlays.md) |
| Tabs, accordion, collapsible, sidebar, navigation menu, breadcrumb, scroll area, carousel | [navigation.md](navigation.md) |
| Skeleton, spinner, progress, empty state, alert, badge, avatar, chart | [feedback.md](feedback.md) |

Read only the file for the family you are building.

## Verify before calling it done

Open the page in a browser (dev server plus Playwright, or the user's browser) and check:

- Controls placed side by side have equal heights and aligned edges.
- Every indicator passes the centering measurement in [alignment.md](alignment.md#measure-it).
- Every state listed above renders, in light and dark mode.
- Native popups (select options, date picker) follow the theme.
- Opening each popup (select, menu, combobox, dialog) leaves every other element where it was: measure a flexible neighbor's width before and after opening, the difference is `0`.
- The page works at 375px wide and at 200% zoom.

If you cannot open a browser, say which checks you could not run.
