---
name: components
description: Keeps one component per UI pattern. Use before creating or restyling any UI component, button, input, card, modal, table, list item or layout block, so an existing component is found and reused or extended instead of rebuilt differently. Also run as /components to audit a project for duplicated components, consolidate them and write the project's component inventory.
argument-hint: "[audit | path or component to check]"
---

# Components

One UI pattern, one component. Every time a card, a field or a modal is rebuilt from scratch it comes out slightly different, and the interface drifts until nothing matches. This skill stops the rebuild before it happens and, in audit mode, merges the copies that already exist.

How each component should look and behave belongs to `component-specs`. This skill only decides whether a component should exist, where it lives and what its API looks like.

## Read the inventory first

The project's `CLAUDE.md` holds a `## UI components` section when this skill has run before. It loads every session, so it is the first place to look and the source of truth for what exists.

If the section is missing, build the picture from the code before writing anything:

- `components.json` (shadcn), `package.json` UI dependencies (Radix, Base UI, Headless UI, Ark, MUI, Chakra, daisyUI) and the styling system (Tailwind, CSS modules, plain CSS, CSS-in-JS).
- The component folders: `components/`, `components/ui/`, `src/ui/`, `app/_components/`, `lib/`, and Astro `src/components/`.
- The design tokens: Tailwind theme, CSS custom properties, a tokens file.

Then offer to write the inventory with the audit below, so the next session starts with it.

If the project has no component library yet, build the shared components on Base UI (`@base-ui/react`), or on shadcn's Base UI components when the project uses shadcn. `component-specs` has the details.

## Before creating a component

1. **Search by role, not by name.** The thing you need may exist as `Panel` when you were about to write `Card`. Search the component folders for synonyms and for the markup itself: the class names, the element structure, the props it would take.
2. **Decide with this order, and say which one you picked:**
   - **Reuse** the existing component as it is.
   - **Extend** it with a new `variant`, `size` or slot when the need is a real variation of the same pattern.
   - **Compose** existing primitives inside the feature when the need is a one-off arrangement, not a new pattern.
   - **Create** a new component only when nothing above fits. It goes in the shared folder, not inside the feature.
3. **Never copy and modify.** Duplicating a component file, or pasting its markup into a feature to tweak it, is the failure this skill exists to prevent. If the existing component cannot do what you need, extend it and keep its other call sites working.

## The rule of two

The second time a UI pattern appears, extract it. Do not wait for the third. When you are about to write markup that matches something already on another page, stop, move it into a shared component and use it in both places.

Exceptions: layout wrappers that differ in every use, and markup that only looks alike but means different things (a price and a quantity can share a style without sharing a component).

## API conventions

Match what the project already does. Where it has no convention, use these:

- **Variants as props, not as copies:** `variant` for the visual style, `size` for the scale. Use the project's variant tool (`cva`, `tailwind-variants`) if it has one.
- **Pass through what the native element accepts.** Spread the remaining props onto the root element, forward the `ref`, and merge `className` with the project's `cn` helper so call sites can adjust layout without forking.
- **Compose instead of adding booleans.** Five `showX` props mean the component is doing too much. Give it slots or children (`Card.Header`, `Card.Footer`) instead.
- **Controlled and uncontrolled.** Inputs, selects, tabs and dialogs accept `value`/`onChange` (or `open`/`onOpenChange`) and also work with a default.
- **Styles come from tokens.** No one-off hex values, pixel sizes or shadows inside a component; use the project's tokens so every component moves together when the theme changes.
- **One file per component, named for its role**, exported from the place the rest of the project imports UI from.

## Audit mode

Run when invoked as `/components`, `/components audit`, or when the user complains that the same thing looks different in different places.

1. **Map** every component and every repeated markup pattern. Group them by role: buttons, inputs, selects, cards, modals, tables, badges, empty states, loaders, page headers.
2. **Report duplicates** in a table, without changing code yet:

   | Role | Implementations | Where | Differences |
   |---|---|---|---|
   | Card | 4 | `ProductCard.tsx`, `pages/orders.tsx:40`, ... | radius 8/12/16, two shadow styles |

3. **Propose the consolidation:** the one component each role keeps, the variants it needs to cover the real differences, and the call sites to migrate. Wait for the user's confirmation.
4. **Migrate** call site by call site, keeping behavior. Delete the duplicates once nothing imports them. Run the project's build and typecheck.
5. **Write the inventory** into the project's `CLAUDE.md` (create the file if it does not exist).

## Inventory format

Keep it short. It loads in every session, so list what exists and how to call it, not documentation.

```markdown
## UI components

Before creating UI, use or extend these. Never rebuild one inside a feature.
Styling: Tailwind v4, tokens in `src/styles/theme.css`. Library: shadcn (Radix).

| Component | Path | Use for | API |
|---|---|---|---|
| Button | `src/components/ui/button.tsx` | every action | `variant`: default, secondary, ghost, destructive · `size`: sm, md, lg, icon |
| Field | `src/components/ui/field.tsx` | label + control + help + error | wraps Input, Select, Textarea |
| Select | `src/components/ui/select.tsx` | choosing one option | native under 10 options, `Combobox` above |
| DataTable | `src/components/data-table.tsx` | any tabular data | horizontal scroll, resizable columns |
```

Update the table whenever this skill creates, renames or removes a shared component.
