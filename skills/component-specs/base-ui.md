# Base UI

Base UI (`@base-ui/react`, formerly `@base-ui-components/react`) is the default primitive layer for new projects. It ships behavior only: keyboard, focus, ARIA, positioning, collision handling, scroll lock and state attributes. It ships no visuals, so every rule in this skill still applies; this file maps the recipes onto its parts.

- **Project with shadcn/ui:** use shadcn's Base UI components (the `base` variants in its docs) so the theme and the primitives come together. Keep a project that already runs on Radix on Radix.
- **Project without a component library:** install `@base-ui/react` and build the shared components on it, one per role (see `components`).
- **Never** mix Base UI and Radix for the same role in one project.

The package ships its own documentation in `node_modules/@base-ui/react/docs/react/components/*.md`. Read the component's file there for the exact parts and props of the installed version before building.

## State lives in data attributes

Style states with the attributes Base UI sets, not with extra classes or React state:

| Attribute | On |
|---|---|
| `data-checked`, `data-unchecked`, `data-indeterminate` | Checkbox, Radio, Switch and their indicator or thumb |
| `data-disabled`, `data-readonly`, `data-required` | controls |
| `data-invalid`, `data-valid`, `data-dirty`, `data-touched`, `data-filled`, `data-focused` | controls inside `Field.Root` |
| `data-open`, `data-closed`, `data-popup-open` | triggers and popups |
| `data-highlighted`, `data-selected` | items in Select, Menu, Combobox |
| `data-starting-style`, `data-ending-style` | popups and indicators while entering and leaving, for transitions |
| `data-side`, `data-align` | positioned popups, to animate from the right side |

In Tailwind: `data-checked:bg-primary`, `data-invalid:border-destructive`, `data-starting-style:opacity-0`.

## Positioning variables

Positioned popups (Select, Popover, Menu, Combobox, Tooltip) expose CSS variables on the positioner and popup:

| Variable | Use |
|---|---|
| `--anchor-width` | `min-width` of select and combobox popups, so they are never narrower than the trigger |
| `--available-height` | `max-height` of the scrolling list, so it never runs off screen |
| `--available-width` | `max-width` on narrow screens |
| `--transform-origin` | `transform-origin` of the popup, so it scales from the trigger |

## Checkbox

```tsx
<Checkbox.Root className="checkbox">
  <Checkbox.Indicator className="checkbox-indicator">
    <CheckIcon />  {/* the centered 16x16 path from alignment.md */}
  </Checkbox.Indicator>
</Checkbox.Root>
```

```css
.checkbox {
  box-sizing: border-box;
  display: grid;
  place-items: center;
  inline-size: 16px;
  block-size: 16px;
  padding: 0;
  margin: 0;
  border: 1px solid var(--border-strong);
  border-radius: 4px;
  background: var(--surface);
  color: var(--on-primary);
}
.checkbox[data-checked],
.checkbox[data-indeterminate] { background: var(--primary); border-color: var(--primary); }
.checkbox-indicator { display: grid; place-items: center; }
.checkbox-indicator svg { display: block; inline-size: 12px; block-size: 12px; }
.checkbox-indicator[data-indeterminate] { inline-size: 8px; block-size: 2px; border-radius: 1px; background: currentColor; }
.checkbox-indicator[data-indeterminate] svg { display: none; }
```

The root renders a `<span>` (plus a hidden input), so `padding: 0` and `box-sizing: border-box` are needed for the `16px` to include the border.

## Radio

```tsx
<RadioGroup defaultValue="pix">
  <Radio.Root value="pix" className="radio"><Radio.Indicator className="radio-indicator" /></Radio.Root>
</RadioGroup>
```

```css
.radio {
  box-sizing: border-box;
  display: grid;
  place-items: center;
  inline-size: 16px;
  block-size: 16px;
  padding: 0;
  margin: 0;
  border: 1px solid var(--border-strong);
  border-radius: 50%;
  background: var(--surface);
}
.radio[data-checked] { background: var(--primary); border-color: var(--primary); }
.radio-indicator { display: block; inline-size: 6px; block-size: 6px; border-radius: 50%; background: var(--on-primary); }
.radio-indicator[data-unchecked] { display: none; }
```

## Switch

```tsx
<Switch.Root className="switch"><Switch.Thumb className="switch-thumb" /></Switch.Root>
```

```css
.switch {
  --thumb: 16px; --inset: 2px; --travel: 16px;
  box-sizing: border-box;
  display: inline-flex;
  align-items: center;
  inline-size: calc(var(--thumb) + var(--travel) + var(--inset) * 2);
  block-size: calc(var(--thumb) + var(--inset) * 2);
  padding: var(--inset);
  margin: 0;
  border: 0;
  border-radius: 999px;
  background: var(--switch-off);
  box-shadow: inset 0 0 0 1px var(--border);
  transition: background-color 150ms ease-out;
}
.switch[data-checked] { background: var(--primary); box-shadow: none; }
.switch-thumb {
  display: block;
  inline-size: var(--thumb);
  block-size: var(--thumb);
  border-radius: 50%;
  background: white;
  box-shadow: 0 1px 2px rgb(0 0 0 / 0.2);
  transition: transform 150ms ease-out;
}
.switch-thumb[data-checked] { transform: translateX(var(--travel)); }
```

## Select

```tsx
<Select.Root items={items} defaultValue="all">
  <Select.Trigger className="select-trigger">
    <Select.Value />
    <Select.Icon className="select-icon"><ChevronDownIcon /></Select.Icon>
  </Select.Trigger>
  <Select.Portal>
    <Select.Positioner className="select-positioner" sideOffset={4} alignItemWithTrigger={false}>
      <Select.Popup className="select-popup">
        <Select.List className="select-list">
          {items.map((item) => (
            <Select.Item key={item.value} value={item.value} className="select-item">
              <Select.ItemIndicator className="select-item-indicator"><CheckIcon /></Select.ItemIndicator>
              <Select.ItemText className="select-item-text">{item.label}</Select.ItemText>
            </Select.Item>
          ))}
        </Select.List>
      </Select.Popup>
    </Select.Positioner>
  </Select.Portal>
</Select.Root>
```

```css
.select-trigger {
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--control-gap);
  min-inline-size: 0;
  block-size: var(--control-h);
  padding-inline: var(--control-px);
  border: 1px solid var(--border);
  border-radius: var(--control-radius);
  background: var(--surface);
  color: var(--text);
  font: inherit;
  text-align: start;
}
.select-trigger > :first-child { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.select-icon { display: grid; place-items: center; flex: none; color: var(--text-muted); }
.select-icon svg { display: block; inline-size: var(--control-icon); block-size: var(--control-icon); }
.select-positioner { z-index: 50; outline: none; }
.select-popup {
  box-sizing: border-box;
  min-inline-size: var(--anchor-width);
  max-inline-size: min(360px, var(--available-width));
  padding: 4px;
  border: 1px solid var(--border);
  border-radius: var(--control-radius);
  background: var(--surface-raised);
  transform-origin: var(--transform-origin);
  transition: opacity 120ms ease-out, scale 120ms ease-out;
}
.select-popup[data-starting-style],
.select-popup[data-ending-style] { opacity: 0; scale: 0.97; }
.select-list { max-block-size: min(320px, var(--available-height)); overflow-y: auto; }
.select-item {
  display: grid;
  grid-template-columns: 16px 1fr;   /* fixed check slot: labels align whether checked or not */
  align-items: center;
  gap: 8px;
  block-size: 32px;
  padding-inline: 8px;
  border-radius: 6px;
  outline: none;
}
.select-item[data-highlighted] { background: var(--surface-hover); }
.select-item-indicator { grid-column: 1; display: grid; place-items: center; }
.select-item-text { grid-column: 2; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
```

- The chevron sits `--control-px` from the edge, the same distance as the text from the start edge, because the trigger's padding is symmetric and the icon is a flex item, not absolutely positioned.
- `alignItemWithTrigger` (default `true`) overlaps the popup on the trigger, macOS style. Set it to `false` for a dropdown that opens below the trigger, which is what most web apps expect; keep it when the design asks for the overlap.

## Scroll lock

Select and Menu are modal by default (`modal: true`) and Dialog is modal; they lock page scroll while open. Base UI compensates for the disappearing scrollbar by putting `scrollbar-gutter: stable` on `<html>` during the lock, so nothing on the page moves. Do not add your own compensation on top (`margin-right` or `padding-right` on the body); that would shift the page by the scrollbar width. See [overlays.md](overlays.md#nothing-moves-when-a-popup-opens).

## Field

Wrap each control in `Field.Root` with `Field.Label`, `Field.Description` and `Field.Error`. It wires the label, `aria-describedby` and the validation attributes (`data-invalid`, `data-touched`) onto the control, which is the `Field` structure from [controls.md](controls.md#field) without hand-written ids.
