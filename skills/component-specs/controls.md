# Controls

Inputs, selects, textareas, comboboxes, sliders, OTP fields and buttons are one family. They share tokens, so a form built from them lines up without anyone adjusting a pixel.

## Shared control tokens

Define these once and use them in every control:

```css
:root {
  --control-h-sm: 32px;
  --control-h: 36px;
  --control-h-lg: 44px;
  --control-px: 12px;
  --control-radius: var(--radius-md, 8px);
  --control-border: 1px solid var(--border);
  --control-font: 14px;
  --control-icon: 16px;
  --control-gap: 8px;
}
@media (pointer: coarse) {
  :root { --control-h: 44px; --control-font: 16px; }  /* below 16px, iOS zooms the page on focus */
}
```

| State | Treatment |
|---|---|
| Hover | Border one step stronger. No hover on touch (`@media (hover: hover)`). |
| Focus-visible | The project's focus ring (usually `2px` ring with `2px` offset, or a `3px` translucent ring), identical on every control. |
| Invalid (`aria-invalid="true"`) | Destructive border and ring color, plus an error message. Never color alone. |
| Disabled | `opacity: 0.5` and `cursor: not-allowed`, no hover change. |
| Read-only | Normal text, muted background, no focus ring change. |

## Field

One structure for every field in the app: label, control, description, error.

```html
<div class="field">
  <label for="email">Email</label>
  <input id="email" aria-describedby="email-help email-error" aria-invalid="true" />
  <p id="email-help" class="field-help">We'll send the receipt here.</p>
  <p id="email-error" class="field-error">Enter a valid email.</p>
</div>
```

- Label above the control, `6px` to `8px` gap. Required or optional marked in text, consistently across the app.
- Help and error below the control, in the same slot, so the layout does not reorder between states.
- Error appears after submit or blur, not on the first keystroke.
- Build this once as a `Field` component (see `components`) and wrap every control in it.

## Input and input group

- Height `var(--control-h)`, padding `0 var(--control-px)`, `box-sizing: border-box`. Width comes from the layout, not from the `size` attribute.
- Placeholder in the muted text color, never as a replacement for the label.
- Icons and affixes (`R$`, `%`, `.com`, a search icon, a clear button) live in an input group: a flex container that carries the border, with the input inside it borderless. The input's padding on that side shrinks so the text never runs under the icon.

```css
.input-group {
  display: flex;
  align-items: center;
  gap: var(--control-gap);
  block-size: var(--control-h);
  padding-inline: var(--control-px);
  border: var(--control-border);
  border-radius: var(--control-radius);
}
.input-group:focus-within { /* focus ring here, not on the inner input */ }
.input-group > input { flex: 1; min-inline-size: 0; border: 0; padding: 0; background: transparent; outline: none; }
.input-group > svg { inline-size: var(--control-icon); block-size: var(--control-icon); flex: none; display: block; }
```

- Autofill: override Chrome's yellow with the surface color.

```css
input:-webkit-autofill {
  -webkit-text-fill-color: var(--text);
  box-shadow: 0 0 0 1000px var(--surface) inset;
  caret-color: var(--text);
}
```

- `type="number"`: hide the spin buttons unless the stepper is wanted; use `inputmode="decimal"` for money, and right-align numbers only inside tables.

```css
input[type=number] { -moz-appearance: textfield; }
input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
```

- `type="search"`: remove the native clear button and add the app's own if needed (`::-webkit-search-cancel-button { -webkit-appearance: none; }`).
- `type="file"`: hide the native button styling with `::file-selector-button` and style it as the app's secondary button, or build a dropzone.

## Native select

Use the native `<select>` for short, simple lists (under about 10 options, no search, no rich content). It is accessible and opens the OS picker on mobile. Style it so the chevron has room:

```css
.select {
  display: grid;
  grid-template-areas: "stack";
  grid-template-columns: minmax(0, 1fr);  /* the select never grows past its wrapper */
  align-items: center;
}
.select > select {
  grid-area: stack;
  inline-size: 100%;
  min-inline-size: 0;
  text-overflow: ellipsis;
  appearance: none;
  block-size: var(--control-h);
  padding-inline: var(--control-px) calc(var(--control-px) + var(--control-icon) + var(--control-gap));
  border: var(--control-border);
  border-radius: var(--control-radius);
  background: var(--surface);
  color: var(--text);
  font: inherit;
  font-size: var(--control-font);
}
.select > svg {
  grid-area: stack;
  justify-self: end;
  margin-inline-end: var(--control-px);
  inline-size: var(--control-icon);
  block-size: var(--control-icon);
  pointer-events: none;
  color: var(--text-muted);
  display: block;
}
```

```html
<div class="select">
  <select aria-label="Status">…</select>
  <svg viewBox="0 0 16 16" aria-hidden="true"><path d="m4 6 4 4 4-4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
</div>
```

- The right padding is the outer padding plus the icon plus the gap, so a long option never runs under the chevron, and the chevron sits exactly `--control-px` from the edge, the same distance the text sits from the left.
- The chevron is centered by the grid, not by `top: 50%`.
- A select sizes itself to its longest option. Without `minmax(0, 1fr)` and `width: 100%`, one long option pushes it out of its wrapper and over the next control.
- `color-scheme` on `:root` makes the options popup follow dark mode. Give `option` the surface and text colors for browsers that honor it.
- Progressive enhancement where supported (Chromium 135+), for a fully styleable picker:

```css
@supports (appearance: base-select) {
  .select > select, .select > select::picker(select) { appearance: base-select; }
  .select > select::picker(select) {
    border: var(--control-border);
    border-radius: var(--control-radius);
    background: var(--surface);
    padding: 4px;
    box-shadow: var(--shadow-popover);
  }
  .select > select::picker-icon { display: none; }  /* the grid chevron stays */
}
```

## Custom select and combobox

Use a custom select (Radix, Base UI, shadcn `Select`) when options need icons, descriptions or groups, and a combobox (shadcn `Combobox`/`Command`) when the list is long enough to need search (more than about 10 options).

- The trigger is styled exactly like the native select above: same height, padding, chevron position.
- The popup is at least as wide as the trigger (`min-width: var(--radix-select-trigger-width)` or the library's equivalent), and can grow wider for long options.
- Max height about `min(320px, 50vh)` with internal scroll; the selected item is scrolled into view when it opens.
- Items: `--control-h-sm` tall, the same horizontal padding as the trigger, a check icon in a fixed-width slot so labels stay aligned whether checked or not.
- Combobox: input on top, "No results" empty state, keyboard highlight visible, typing filters without moving focus out of the input.
- On touch screens, consider the native select or a drawer instead of a tiny floating popup.

## Textarea

- Same border, radius, padding (`8px var(--control-px)`) and font as the input.
- `min-block-size` of about three lines; `resize: vertical` only, never horizontal.
- Auto-grow where content length varies: `field-sizing: content` where supported, with `max-block-size` and scroll beyond it.

## Slider

Restyle both the track and the thumb; the native ones differ across browsers.

```css
input[type=range] { appearance: none; inline-size: 100%; block-size: 20px; background: transparent; }
input[type=range]::-webkit-slider-runnable-track { block-size: 4px; border-radius: 999px; background: var(--track); }
input[type=range]::-moz-range-track { block-size: 4px; border-radius: 999px; background: var(--track); }
input[type=range]::-webkit-slider-thumb {
  appearance: none; inline-size: 16px; block-size: 16px; border-radius: 50%;
  background: var(--surface); border: 2px solid var(--primary);
  margin-block-start: -6px;   /* (track 4 - thumb 16) / 2 */
}
input[type=range]::-moz-range-thumb { inline-size: 16px; block-size: 16px; border-radius: 50%; background: var(--surface); border: 2px solid var(--primary); box-sizing: border-box; }
input[type=range]::-moz-range-progress { block-size: 4px; border-radius: 999px; background: var(--primary); }
```

The WebKit thumb is aligned to the top of the track, so it needs `margin-top: (track − thumb) / 2`; keep track and thumb heights both even so the result is a whole pixel. Show the current value next to the slider when the exact number matters.

## OTP input

- One input per digit or a single input styled as boxes (shadcn `InputOTP`); boxes are square, the same height as `--control-h`, digits centered with `tabular-nums`.
- Pasting a full code fills every box; backspace moves to the previous box.
- `autocomplete="one-time-code"` and `inputmode="numeric"`.

## Button

- Same heights as the controls (`--control-h-sm`, `--control-h`, `--control-h-lg`) so a button next to an input lines up.
- Icon button: square, width equals height, icon centered by flex.
- Icon plus label: `gap: var(--control-gap)`, icon `16px`, and `2px` less padding on the icon side (optical balance).
- Loading: keep the width fixed (place the spinner over the hidden label, or reserve its space) so the layout does not jump; disable the button while loading.
- Limit variants to what the app uses: usually default, secondary, outline, ghost, destructive, link.
