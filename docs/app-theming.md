# App theming (Flutter)

How the Board Games Companion mobile app is themed: where the styling primitives
live, how the single `ThemeData` is assembled, and the conventions to follow when
building new UI so it looks native to the app.

> **Source of truth:** the Dart files under `board_games_companion/lib/common/`
> always win over this doc. Values quoted here are anchors for orientation, not an
> exhaustive mirror. A visual companion (color swatches, type scale, spacing) lives
> at [`docs/app-theming.html`](./app-theming.html) — open it in a browser.

## The four styling files

All theming primitives are static-member classes in `board_games_companion/lib/common/`:

| File | Class | Role |
|---|---|---|
| `app_colors.dart` | `AppColors` | The palette. Core brand colors, semantic aliases (text, tabs, icons, gradients), and the 15-color chart palette. |
| `app_theme.dart` | `AppTheme` | Assembles the app's single `ThemeData` (`AppTheme.theme`) and a few standalone `TextStyle` constants. |
| `app_styles.dart` | `AppStyles` | Shape & effect constants: corner radii, shadows, elevations, opacity steps, and the shared tile gradient `BoxDecoration`. |
| `dimensions.dart` | `Dimensions` | Sizing: the 8px-based spacing scale, the font-size scale, and many widget-specific sizes (image heights, icon sizes, hexagon sizes…). |

(`app_text.dart` / `AppText` is UI copy strings, not theming.)

## Palette anchors

- **Primary (dark purple)** `AppColors.primaryColor` = `#2D103F` — app bar, gradient end.
- **Primary light (purple)** `AppColors.primaryColorLight` = `#5B217F` — scaffold, cards, dialogs, snackbars, gradient start.
- **Accent (orange)** `AppColors.accentColor` = `#FF9800` — icons, selected states, dividers, text buttons, cursors, tab indicators.
- **Secondary (blues)** `AppColors.secondaryColor` = `#010055`, `secondaryLightColor` = `#2747A5` — element background gradients; `secondaryColor` is `ColorScheme.tertiary`.
- **Text** `defaultTextColor` = white, `secondaryTextColor` = grey, `invertedTextColor` = black.
- **Deselected/disabled icons** `#46FFFFFF` (white at ~27%).
- **Charts** `AppColors.chartColorPallete` — 15 fixed colors; the stat colors (`playedGamesStatColor` etc.) are aliases into it.

Prefer the semantic aliases (`defaultTextColor`, `enabledIconIconColor`,
`deselectedTabIconColor`…) over the raw named colors (`blueColor`, `pinkColor`…)
when one exists for your use case.

## How the theme is assembled

`AppTheme.theme` is a getter that starts from `ThemeData.light()` and `copyWith`s
everything: a hand-built `ColorScheme` (hard-coded `Brightness.light`), a text theme
derived from `GoogleFonts.latoTextTheme()` (Lato is the app font), and per-component
themes (dialog, slider, toggle buttons, input decoration, snackbar, tab bar, etc.).
It is registered once in `app.dart` via `MaterialApp(theme: AppTheme.theme)`.

### Text theme slots

The Material `textTheme` slots are repurposed as follows (size in logical px, all Lato):

| Slot | Size | Weight | Color | Typical use |
|---|---|---|---|---|
| `displayLarge` | 20 | bold | white | Biggest titles, dialog numerals |
| `displayMedium` | 18 | bold | white | Section titles, dialog titles |
| `displaySmall` | 16 | bold | white | Emphasized body, dialog content (weight often reset to normal via `copyWith`) |
| `headlineSmall` | Lato default (24) | — | white | Rarely used |
| `headlineMedium` | 14 | — | white | Secondary body text |
| `titleLarge` | Lato default (22) | — | white | Screen titles |
| `titleMedium` | 12 | — | grey | Subtitles, captions |
| `titleSmall` | 10 | — | grey | Smallest captions |
| `bodyLarge` | 16 | — | white | Primary body text |
| `bodyMedium` | 14 | — | white | Standard body text |

Font-size constants come from `Dimensions` (`extraSmallFontSize` 10 → `doubleExtraLargeFontSize` 26).

## Usage conventions

- **Access the theme statically.** The codebase convention is
  `AppTheme.theme.textTheme.bodyMedium`, `AppColors.accentColor`, etc. — *not*
  `Theme.of(context)`. Follow it for consistency (but see Known limitations).
- **Local overrides wrap with `Theme`.** Screens that need a component tweak wrap a
  subtree in `Theme(data: AppTheme.theme.copyWith(...))` (see `about_page.dart`,
  `settings_page.dart`, `board_game_details_expansions.dart`).
- **Spacing comes from `Dimensions`.** The scale is multiples of
  `standardSpacing = 8` (`quarterStandardSpacing` 2 → `trippleStandardSpacing` 24).
  Don't hard-code paddings.
- **Opacity via `AppStyles.opacityXXPercent`.** These are alpha ints for
  `Color.withAlpha(...)` in 10% steps.
- **Shape via `AppStyles` / `AppTheme.defaultBorderRadius`.** Default corner radius
  is 5; board-game tiles use radius 15; page/tile backgrounds use the shared
  purple gradient (`AppStyles.tileGradientBoxDecoration`,
  `startDefaultPageBackgroundColorGradient` → `endDefaultPageBackgroundColorGradient`).
- **Charts pick from `chartColorPallete`** in order, or use the named stat aliases.

## Known limitations

Recorded so future work starts from an honest map — none of these are conventions
to imitate:

1. **No dark mode.** `Brightness.light` is hard-coded and the static
   `AppTheme.theme` access pattern bypasses widget-tree theme resolution. Flutter's
   idiom is `Theme.of(context)`; the intent is to migrate to it in the future,
   which (together with a second `ColorScheme`) is what would unlock theme
   switching. Until that migration happens, new code should stay consistent with
   the static pattern.
2. **`Dimensions` mixes concerns.** A true spacing/font scale sits alongside dozens
   of widget-specific sizes (`gameSpinnerHeight`, `boardGameDetailsHexagonSize`…).
   There is an in-file `TODO` to rename the spacing constants (`spacing1x` style).
3. **Style definitions are duplicated across files.** `AppTheme` carries standalone
   `TextStyle` constants (`titleTextStyle`…) outside `ThemeData`; `AppStyles` has
   its own one-off `playerScoreTextStyle`; elevation is defined in both
   `AppStyles.defaultElevation` (4) and `Dimensions.defaultElevation` (3).
4. **Raw and semantic color names coexist.** `AppColors` exposes both semantic
   aliases and raw colors (`blueColor`, `pinkColor`…), so semantic usage isn't
   enforced — it's convention only.
