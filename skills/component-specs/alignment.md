# Alignment of indicators

A checkmark leaning to one side, a radio dot hugging the bottom of its ring, a switch thumb touching the track on one side and floating on the other: these are the most visible small defects in a form, and they come from a handful of causes. Fix the cause, not the pixel.

## Why indicators end up off center

| Cause | What happens | Fix |
|---|---|---|
| Odd remainder | A `15px` box with an `8px` dot leaves `7px`, so the dot sits `3.5px` from one side and `3.5px` from the other, which the browser rounds to `3` and `4`. | Make `(box − indicator)` even. `16` with `8`, `16` with `6`, `20` with `8`, `18` with `10`. |
| Border not counted | The indicator is positioned from the border edge (`top: 4px` inside a box with a `1px` border), so it is offset by the border width. | Center with grid on the box; grid centers inside the content box, after the border. |
| Manual offsets | `top`, `left`, `margin-top: 1px` tuned at one size break at another size, zoom level or font. | `display: grid; place-items: center` on the box. No offsets. |
| `translate(-50%, -50%)` on odd sizes | Lands on half pixels and renders blurry or one pixel off. | Grid centering, or sizes that halve to whole pixels. |
| Inline indicator | An inline `svg` or `span` sits on the text baseline and inherits line height, so it rides low. | `display: block` on the indicator, and size it explicitly. |
| Glyph as checkmark | `✓` from a font carries the font's side bearings and baseline. | Use an SVG path drawn centered in its viewBox, inline or as a `mask`. |
| Rotated border checkmark | An L-shaped border rotated `45deg` rotates around its own center, which is not the visual center of the check. | Use an SVG, or compensate with a measured `translate` and verify it. |
| Icon not centered in its viewBox | Many icon sets draw the check lower or to one side within `0 0 24 24`. | Pick a check whose path is centered, or draw your own (below). Then judge by eye. |

## Checkbox

```css
.checkbox {
  appearance: none;
  display: grid;
  place-items: center;
  inline-size: 16px;
  block-size: 16px;
  margin: 0;
  border: 1px solid var(--border-strong);
  border-radius: 4px;
  background: var(--surface);
  color: var(--on-primary);
}
.checkbox::before {
  content: "";
  inline-size: 12px;            /* 16 - 2 (border) = 14 content; 14 - 12 = 2, even */
  block-size: 12px;
  background: currentColor;
  mask: var(--check-icon) center / contain no-repeat;
  transform: scale(0);
  transition: transform 120ms ease-out;
}
.checkbox:checked,
.checkbox:indeterminate {
  background: var(--primary);
  border-color: var(--primary);
}
.checkbox:checked::before { transform: scale(1); }
.checkbox:indeterminate::before {
  mask-image: none;
  inline-size: 8px;
  block-size: 2px;               /* 14 - 2 = 12, even */
  border-radius: 1px;
  transform: scale(1);
}
:root {
  --check-icon: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='M3.5 8.5 6.5 11.5 12.5 4.5' fill='none' stroke='black' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
}
```

With a React or headless component, the same rule applies to its indicator element: the root is a `grid` with `place-items: center`, and the check is an SVG with `display: block` and an explicit size. A centered check path for a `0 0 16 16` viewBox:

```html
<svg viewBox="0 0 16 16" width="12" height="12" aria-hidden="true" style="display:block">
  <path d="M3.5 8.5 6.5 11.5 12.5 4.5" fill="none" stroke="currentColor"
        stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
</svg>
```

## Radio

```css
.radio {
  appearance: none;
  display: grid;
  place-items: center;
  inline-size: 16px;
  block-size: 16px;
  margin: 0;
  border: 1px solid var(--border-strong);
  border-radius: 50%;
  background: var(--surface);
}
.radio::before {
  content: "";
  inline-size: 6px;             /* 14 content - 6 = 8, even */
  block-size: 6px;
  border-radius: 50%;
  background: var(--on-primary);
  transform: scale(0);
  transition: transform 120ms ease-out;
}
.radio:checked { background: var(--primary); border-color: var(--primary); }
.radio:checked::before { transform: scale(1); }
```

The outlined style (ring stays neutral, dot in the primary color) follows the same sizes.

## Switch

Every dimension derives from three tokens so the thumb can never touch one side and float on the other:

```css
.switch {
  --thumb: 16px;
  --inset: 2px;
  --travel: 16px;
  appearance: none;
  position: relative;
  display: inline-flex;
  align-items: center;
  box-sizing: border-box;
  inline-size: calc(var(--thumb) + var(--travel) + var(--inset) * 2);  /* 36px */
  block-size: calc(var(--thumb) + var(--inset) * 2);                   /* 20px */
  padding: var(--inset);
  margin: 0;
  border: 0;                     /* a border would break the math; use an inset shadow */
  border-radius: 999px;
  background: var(--switch-off);
  box-shadow: inset 0 0 0 1px var(--border);
  transition: background-color 150ms ease-out;
}
.switch::before {
  content: "";
  inline-size: var(--thumb);
  block-size: var(--thumb);
  border-radius: 50%;
  background: white;
  box-shadow: 0 1px 2px rgb(0 0 0 / 0.2);
  transition: transform 150ms ease-out;
}
.switch:checked { background: var(--primary); box-shadow: none; }  /* the off-state ring would show around the fill */
.switch:checked::before { transform: translateX(var(--travel)); }
:dir(rtl) .switch:checked::before { transform: translateX(calc(var(--travel) * -1)); }
```

Rules:

- Track height = thumb + 2 × inset. Track width = thumb + travel + 2 × inset. Travel is the translate distance. Change one token and the rest follows.
- Never give the track a border. It shrinks the inner space by `2px` and the thumb sits off center unless every value is recomputed. Draw the edge with `box-shadow: inset`.
- Center the thumb vertically with `align-items: center`, never with `top`.
- With a library switch (Radix, Base UI, shadcn), set the root and thumb sizes so the same equations hold, and check that its `data-state="checked"` translate equals the travel.

## Aligning the control with its label

A `16px` box next to text with a `24px` line height should center on the first line, not on the whole label block:

```html
<label class="choice">
  <span class="choice-control"><input type="checkbox" class="checkbox" /></span>
  <span>Aceito os termos de uso e a política de privacidade</span>
</label>
```

```css
.choice {
  display: grid;
  grid-template-columns: auto 1fr;
  column-gap: 8px;
  align-items: start;
}
.choice-control {
  display: grid;
  place-items: center;
  block-size: 1lh;   /* one line of the label's text, so the box centers on the first line */
}
```

The wrapper is what makes this work: `1lh` resolves against the element's own line height, and form controls do not inherit the label's, so `margin-top: calc((1lh - 16px) / 2)` on the input itself computes against the wrong line. Where `lh` is unsupported, set the wrapper's height to the label's line height token. Never use `align-items: center` on a label that can wrap to two lines; the box drifts to the middle of the block.

Make the whole label clickable (wrap the control in `<label>` or connect `for`/`id`) and give the row at least `24px` of height so the target meets WCAG 2.5.8.

## Icons inside controls

Chevrons in selects, icons in buttons and inputs, close buttons in dialogs: the icon box is square, `display: block`, sized explicitly (`16px` for most controls) and centered by the parent's flex or grid. If the glyph itself looks off center (a chevron drawn low in its viewBox, a play triangle), nudge it optically by `0.5px` to `1px`, by eye, and leave a comment saying the offset is optical.

## Measure it

Run this in the browser console or through Playwright's `evaluate`. It reports every indicator whose center is more than half a pixel from its box's center:

```js
(() => {
  const pairs = [
    ['input[type=checkbox]', '::before'],
    ['input[type=radio]', '::before'],
    ['[role=checkbox]', 'svg, span'],
    ['[role=radio]', 'span, svg'],
    ['[role=switch]', 'span'],
  ];
  const report = [];
  for (const [boxSel, childSel] of pairs) {
    for (const box of document.querySelectorAll(boxSel)) {
      const b = box.getBoundingClientRect();
      const bs = getComputedStyle(box);
      const inner = {
        x: b.left + parseFloat(bs.borderLeftWidth),
        y: b.top + parseFloat(bs.borderTopWidth),
        w: b.width - parseFloat(bs.borderLeftWidth) - parseFloat(bs.borderRightWidth),
        h: b.height - parseFloat(bs.borderTopWidth) - parseFloat(bs.borderBottomWidth),
      };
      const child = childSel.startsWith('::') ? null : box.querySelector(childSel);
      if (!child) continue;  // pseudo-elements: check visually or give the indicator a real element
      const c = child.getBoundingClientRect();
      const dx = (c.left + c.width / 2) - (inner.x + inner.w / 2);
      const dy = (c.top + c.height / 2) - (inner.y + inner.h / 2);
      const isSwitch = box.getAttribute('role') === 'switch';
      if (Math.abs(dy) > 0.5 || (!isSwitch && Math.abs(dx) > 0.5)) {
        report.push({ box: boxSel, dx: dx.toFixed(2), dy: dy.toFixed(2), el: box.outerHTML.slice(0, 80) });
      }
    }
  }
  for (const sw of document.querySelectorAll('[role=switch]')) {
    const t = sw.getBoundingClientRect(), th = sw.querySelector('span')?.getBoundingClientRect();
    if (!th) continue;
    const left = th.left - t.left, right = t.right - th.right, top = th.top - t.top, bottom = t.bottom - th.bottom;
    const gap = Math.min(left, right);
    if (Math.abs(gap - top) > 0.5 || Math.abs(top - bottom) > 0.5) {
      report.push({ box: 'switch', left, right, top, bottom });
    }
  }
  return report.length ? report : 'all indicators centered';
})();
```

Also zoom to 200% and look. Rounding errors that hide at 100% show up there.
