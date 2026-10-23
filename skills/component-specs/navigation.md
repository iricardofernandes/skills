# Navigation and structure

## Tabs

- Tab list as a row of buttons with the selected state on an indicator (underline or pill) that moves between tabs with a transform transition, not a jump. Instant under reduced motion.
- The panel area keeps a stable height when tabs have different content lengths, or the content below is allowed to move but the tab list never does.
- Overflowing tab lists scroll horizontally with the selected tab scrolled into view; they never wrap to two rows.
- Arrow keys move between tabs (roving tabindex), and the URL reflects the tab when it is a page-level view.

## Accordion and collapsible

- Animate the height. Use the library's measured height variable (`--radix-accordion-content-height`) or `interpolate-size: allow-keywords` with `height: auto`, never a fixed `max-height` guess that cuts content or delays the close.
- The chevron rotates `180deg` (or `90deg` for a side chevron) with the same duration as the height.
- The whole header row is the button, with a hover state and a visible focus ring.
- Content inside keeps its own padding so it does not touch the edges during the animation (put `overflow: hidden` on the animated wrapper, padding on an inner element).

## Sidebar

- One active style for the current page (background, weight or a side indicator) applied by route matching, consistent at every nesting level.
- Collapsed state shows icons with tooltips; the expanded and collapsed widths are tokens, and the transition animates width or a transform, not both.
- On mobile it becomes a sheet from the start edge, opened by a menu button, and closes on navigation.
- Groups have muted labels, and long lists scroll inside the sidebar while the header and footer stay fixed.

## Navigation menu

- Top-level items as one row, dropdown panels positioned from the trigger with the overlay rules in [overlays.md](overlays.md).
- Hover opens with a short delay and stays open while moving the pointer into the panel; click and keyboard also open it.
- On mobile, it collapses into a sheet or drawer with the same structure.

## Breadcrumb

- Separators are icons or `/` with `aria-hidden`, spaced equally.
- Long paths collapse the middle items into an ellipsis menu; the last item (current page) is plain text with `aria-current="page"` and truncates when too long.

## Pagination

- One component for the whole app: previous, page numbers with ellipsis, next; or "1–20 de 312" with previous and next for tables.
- Page buttons are square icon buttons of the control height, the current page uses the selected style and `aria-current="page"`.
- Disabled previous on the first page and next on the last, not hidden, so the layout does not shift.

## Scroll area

- Prefer the native scrollbar, styled thin with `scrollbar-width: thin` and `scrollbar-color: var(--scrollbar-thumb) transparent`. Use a custom scroll area (Radix `ScrollArea`) only when the design needs an overlay scrollbar.
- Never hide the scrollbar on content that scrolls; on desktop it is the only sign that more content exists. Add an edge fade where the scrollbar is subtle.
- `scrollbar-gutter: stable` on containers whose content can grow past their height, so the layout does not jump when the scrollbar appears.

## Carousel

- Built on native horizontal scroll with `scroll-snap-type: x mandatory` and `scroll-snap-align: start`, so touch, trackpad and keyboard all work. A JS library (Embla) when it needs loops, autoplay or synced thumbnails.
- `touch-action: pan-y` on a JS-driven carousel, so vertical page scrolling still works on mobile.
- Previous and next buttons as icon buttons, disabled at the ends; dots or a counter show position.
- No autoplay by default; if it autoplays, it pauses on hover, focus and reduced motion.
