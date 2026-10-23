# Visual bugs

A visual bug needs a loop like any other: a script that opens the page, triggers the symptom and asserts a number. "It looks off" becomes "the neighbour grew by 15px", and the fix is done when that number is 0.

Run it with Playwright against the dev server, as a test file or a one-off `node` script. Measure with `getBoundingClientRect()` and `getComputedStyle()`, never by eye, and repeat a screenshot only to show the user the before and after.

## Pick the measurement for the symptom

| Symptom | Measure | Red when |
|---|---|---|
| Something grows, shrinks or jumps when a popup opens, on hover, focus or error | The rect (`x`, `width`, `height`) of a **flexible neighbour** before and after the trigger | any delta ≠ 0 |
| Page twitches when a select, menu or dialog opens | `html` and `body` computed `padding-right`, `margin-right`, `overflow`, `scrollbar-gutter` and `document.documentElement.clientWidth`, before and after | more than one compensation active, or `clientWidth` changes |
| Indicator off center (check, radio dot, switch thumb, icon) | the indicator's center against the box's inner center (see `component-specs` alignment) | deviation > 0.5px, or uneven switch insets |
| Controls side by side don't line up | `top`, `height` and text baseline of each control | heights or tops differ |
| Click lands on the wrong thing, a handle is hard to grab | `document.elementFromPoint(x, y)` at the target's center | returns another element |
| Popup clipped, under another layer, or off screen | popup rect against the viewport and the clipping ancestor; computed `z-index` of the stack | rect outside the viewport, or `elementFromPoint` hits something else |
| Wrong color, theme or font | computed style of the element in each theme | value differs from the token |
| Flicker or jump during an animation | rects sampled every frame with `requestAnimationFrame` across the transition | a frame jumps against its neighbours |

## The loop

```js
// scripts/repro-shift.mjs — node scripts/repro-shift.mjs
import { chromium } from 'playwright';

// Playwright hides scrollbars by default, which hides every scroll-lock shift.
const browser = await chromium.launch({ ignoreDefaultArgs: ['--hide-scrollbars'] });
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto('http://localhost:5173/pedidos');

const rect = () => page.locator('#cliente-select').evaluate((el) => {
  const r = el.getBoundingClientRect();
  return { x: r.x, width: r.width };
});

const before = await rect();
await page.getByRole('combobox', { name: 'Status' }).click();
await page.getByRole('listbox').waitFor();
const after = await rect();

const dx = after.x - before.x, dw = after.width - before.width;
console.log({ before, after, dx, dw });
await browser.close();
process.exit(dx === 0 && dw === 0 ? 0 : 1);   // red until nothing moves
```

- A scroll-lock shift only appears when the page has a classic scrollbar. Launch with `ignoreDefaultArgs: ['--hide-scrollbars']`, make the page taller than the viewport, and check `innerWidth - document.documentElement.clientWidth` is above 0 before trusting a green result.
- Wait for the state, not for time: the listbox visible, the transition ended (`getAnimations()` empty), fonts loaded (`document.fonts.ready`).
- When the Playwright MCP's real pointer events do not arrive, dispatch the events from `page.evaluate` (`pointerdown`, `mousedown`, `pointerup`, `click`) on the trigger.

## Hypotheses that come up often

- Two scroll-lock compensations stacked, such as `scrollbar-gutter: stable` plus the library's body `margin-right` (see `component-specs` overlays).
- A border, outline or font weight that changes on hover or focus and changes the box size.
- A flex or grid track sized by content (`auto`, `1fr` without `minmax(0, 1fr)`) that grows with the selected value.
- Error or helper text inserted without reserved space.
- A transform or `overflow: hidden` on an ancestor that clips or reparents a popup.
- A sticky element that creates a stacking context and covers a neighbour's handle.

Test each one by changing the single variable it names in DevTools or in the script (`page.addStyleTag`) and re-running the loop, before editing the source.
