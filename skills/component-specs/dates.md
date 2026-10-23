# Dates

The native `<input type="date">` renders the browser's own field and calendar: unthemed, in the OS locale, different on every platform. Use it only for internal tools or as the mobile fallback. Everywhere else, build a date picker from an input plus a themed calendar in a popover.

## Locale first

Dates are read by people in one locale. Decide it once for the app and pass it to every date component:

| Setting | pt-BR | en-US |
|---|---|---|
| Display format | `dd/MM/yyyy` (`23/10/2026`) | `MM/dd/yyyy` |
| Long format | `23 de out. de 2026` | `Oct 23, 2026` |
| First day of week | Sunday (`0`) in Brazil; Monday in Portugal | Sunday |
| Month and weekday names | from `Intl` or the date library's locale, never hardcoded | |

Store and send dates as ISO (`2026-10-23`), and format only for display. Use the project's date library (`date-fns`, `dayjs`, Temporal) and its locale; with shadcn's `Calendar` (react-day-picker), pass `locale={ptBR}` and `weekStartsOn`.

## The field

- The trigger looks exactly like an input (same height, border, radius, padding) with a calendar icon in the input group slot. See [controls.md](controls.md#input-and-input-group).
- The user can type the date as well as pick it: accept `23/10/2026`, `23/10/26` and `23102026`, format on blur, and show an error for impossible dates. Picking-only fields are slow for birthdays and far dates.
- Empty state shows the format as placeholder (`dd/mm/aaaa`).
- A clear button appears when the field is optional and has a value.

## The calendar

- Day cells are square, equal size (`36px` on desktop, `40px` or more on touch), with numbers centered by grid and set in `tabular-nums`.
- Always render six weeks (`fixedWeeks` in react-day-picker) so the popover does not change height between months.
- Header: month and year, with previous and next buttons that are icon buttons from the app's button component. For birth dates and far ranges, a month and year dropdown (`captionLayout="dropdown"`).
- States, all from tokens:

| Day | Style |
|---|---|
| Today | Ring or bold, not filled |
| Selected | Primary fill, on-primary text |
| Range start and end | Primary fill, rounded on the outer side |
| Inside range | Primary at low opacity, square corners, continuous across the row |
| Outside the month | Muted text, still clickable or hidden, consistent across the app |
| Disabled | Muted, line-through or reduced opacity, `cursor: not-allowed` |
| Hover and keyboard focus | Subtle fill, and a visible focus ring |

- Keyboard: arrows move by day and week, Page Up and Page Down by month, Home and End to week edges, Enter selects, Escape closes and returns focus to the field.
- The popover follows [overlays.md](overlays.md#popover-dropdown-context-menu-hover-card): aligned to the field's start edge, flips above when there is no room.

## Ranges

- Two months side by side on desktop, one on mobile.
- Presets for common ranges in a column beside the calendar (Today, Last 7 days, This month, Last month), when the domain uses them.
- The field shows `01/10/2026 – 23/10/2026`, and the first click sets the start, the second the end; clicking before the start restarts the range.

## Time

- Time in a separate field next to the date, same control height, `HH:mm` in 24h for pt-BR.
- A native `type="time"` is acceptable when themed with `color-scheme`; otherwise a select in 15 or 30 minute steps, or a typed field with validation.

## Mobile

On touch devices, a native `type="date"` opens the OS wheel, which is often better than a small popover. Either use it with `color-scheme` set, or open the calendar in a bottom drawer rather than a floating popover.

```css
input[type=date]::-webkit-calendar-picker-indicator {
  opacity: 0.6;
  cursor: pointer;
  filter: var(--date-icon-filter, none);  /* invert(1) in dark mode if color-scheme alone does not */
}
```
