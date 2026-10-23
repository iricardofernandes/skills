# Feedback and content

## Loading: skeleton, spinner, progress

Pick one by what the user is waiting for, and use the same one for the same situation everywhere:

| Situation | Use |
|---|---|
| Content whose layout is known (lists, cards, tables, profiles) | Skeleton |
| An action on a button or a small area | Spinner inside the control |
| A task with known progress (upload, import) | Progress bar with the percentage or count |
| A wait under about `300ms` | Nothing; delay the indicator so it does not flash |

- Skeletons match the real content's shape and size: same line count, avatar size, row height. A generic grey box that jumps to different content is worse than no skeleton.
- Skeleton pulse is subtle (opacity between about `0.5` and `1`, or a soft shimmer), and static under reduced motion.
- Spinners keep the control's size; a button does not change width when it starts loading.
- Refreshing data keeps the old content on screen with a subtle indicator instead of returning to skeletons.

## Empty state

Every list, table, search and dashboard has one, designed:

- What is empty, in plain words ("Nenhum cliente cadastrado").
- Why, or what the user gains by acting ("Clientes aparecem aqui depois do primeiro pedido").
- The primary action, as the app's button ("Cadastrar cliente").
- An icon or small illustration in the muted color, optional.

Distinguish "nothing yet" from "nothing matches your filter" (offer to clear filters) and from "something failed" (offer to retry).

## Alert

- Layout: icon in a fixed-size slot aligned to the first line of the title, title, description, optional actions. Icon and title align on the same line, not centered on the whole block.
- Variants (info, success, warning, destructive) change only the icon and color tokens; the layout is identical.
- Inline alerts sit in the content flow; page-level banners span the width and can be dismissed when they are not critical.

## Badge

- One height and padding per size, `font-size` about `12px`, `font-weight: 500`, numbers in `tabular-nums`.
- Status colors come from semantic tokens (success, warning, destructive, neutral, info) with enough contrast in both themes; never raw palette colors chosen per screen.
- A status means the same color everywhere in the app ("Pago" is always the success variant).
- A dot plus text is clearer than color alone; never rely on color only.

## Avatar

- Square box with `border-radius: 50%` (or the app's radius for organizations), image `object-fit: cover`.
- Fallback with initials (one or two letters, centered by grid, sized relative to the avatar) on a background derived deterministically from the name, so the same person always gets the same color.
- Stacked avatars overlap by about a third with a ring in the surface color, and end with a "+3" avatar.
- A subtle inset outline on photos so light images do not dissolve into light backgrounds.

## Chart

- Series colors come from the app's chart tokens (`--chart-1` to `--chart-5` in shadcn), defined for both themes; never library defaults.
- Axes, grid lines and labels use the muted text and border tokens, so they stay legible in dark mode; grid lines are light and few.
- Tooltip uses the app's floating surface style (see [overlays.md](overlays.md)) and formats numbers and dates in the app's locale.
- Numbers on axes and tooltips in `tabular-nums`, with the same units and decimal places as the tables that show the same data.
- Empty and loading states like any other data component.
