# BBQoutes — Project Summary (Files, Architecture & Data Flow)

This document summarizes the project files and gives a junior‑friendly overview of the app’s architecture, data flow, and best practices. It also explains why and when sample data is loaded.

## File‑by‑File Summary

- App Entry
  - `BBQoutesApp.swift` — `@main` app. Launches `ContentView` in a window.

- Root UI
  - `ContentView.swift` — Tab bar with three shows (Breaking Bad, Better Call Saul, El Camino). Each tab embeds `FetchView(show:)`. Forces dark mode for a consistent look.

- Feature Screen (per show)
  - `FetchView.swift` — Main screen for a show. Themed background image, state‑driven content (quote card, episode card, loading, error), and two buttons to fetch a random quote or episode. Uses `.task` to prefetch a quote on first appearance. Presents `CharacterView` as a sheet when the character card is tapped.

- Components
  - `QuoteView.swift` — Shows the quote bubble and a tappable character card (image + name). Tapping triggers the character sheet.
  - `CharacterView.swift` — Scrollable character details: image gallery (TabView), name, bio info, occupations, nicknames, and a disclosure section for status/death (with auto‑scroll when the death image appears).
  - `EpisodeView.swift` — Episode title, image, synopsis, and credits.

- State & Logic
  - `ViewModel.swift` — `@Observable` + `@MainActor`. Holds `status: FetchStatus` (notStarted, fetching, successQuote, successEpisode, failed), current `quote`, `character`, and `episode`. Loads sample JSON in `init()` so the UI has meaningful content before real network data arrives. Provides async methods `getQuoteData(for:)` and `getEpisode(for:)` that update `status` to drive the UI.

- Networking
  - `FetchService.swift` — Small helper that builds API URLs and uses `URLSession` to fetch data. Validates responses, decodes JSON into models, converts snake_case to camelCase where needed. Endpoints include: random quote (by production), character (by name), deaths (filtered in code), and episodes (returns a random one).

- Models
  - `Quote.swift` — Quote text + character name.
  - `MovieCharacter.swift` — Character metadata and images. Custom decoding loads a bundled sample `Death` (demo‑only). Optional `death` may be filled later by the network.
  - `Death.swift` — Death details: image, last words, and description.
  - `Episode.swift` — Episode info + `seasonEpisode` helper (formats a numeric code into “Season x Episode y”).

- Utilities & Constants
  - `StringExt.swift` — Small helpers to transform strings for asset/color lookups: `removeSpaces()` and `removeCaseAndSpaces()`.
  - `Constants.swift` — Centralized show names used across tabs, assets, and queries.

- Sample Data (in the app bundle)
  - `samplequote.json`, `samplecharacter.json`, `sampleepisode.json`, `sampledeath.json` — Loaded at startup to pre‑populate the UI. Real data replaces these once the first fetch completes.

## Architecture (MVVM)
- **Model** — Simple data types that mirror API responses.
- **ViewModel** — Fetches data via `FetchService`, holds observable state, and exposes it to the UI. Updates happen on the main thread.
- **View** — Renders UI based on `ViewModel.status` and current data. No networking here.
- **Service** — Encapsulates networking and decoding, keeping the ViewModel and Views clean.

## Data Flow
1. App starts → `ContentView` shows tabs.
2. User opens a tab → `FetchView(show:)` appears.
3. `FetchView` runs `.task` once → `ViewModel.getQuoteData(for:)`.
4. `ViewModel` sets `status = .fetching` → UI shows a spinner.
5. `FetchService`:
   - Fetches a random quote for the show
   - Fetches the character for that quote
   - Optionally fetches death info and attaches it to the character
6. On success → `status = .successQuote` → UI shows `QuoteView`.
7. If the user taps “Get Random Episode” → `getEpisode(for:)`:
   - `status = .fetching` → spinner
   - Fetch episodes → choose a random one → `status = .successEpisode` → UI shows `EpisodeView`.
8. On error → `status = .failed(error)` → UI shows the error text.

## Why and When We Load Sample Data
- **Why**: Provide immediate, meaningful UI before the first network call finishes; improve previews and offline development.
- **When**: In `ViewModel.init()`, we decode bundled JSON for a quote, character, and episode. This content is visible until `.task` in `FetchView` fetches live data and updates the state.

## Best Practices Used
- **MVVM separation** keeps responsibilities clear and testable.
- **Async/await + `.task`** for cancel‑aware view lifecycle fetches.
- **State‑driven UI** (`FetchStatus`) avoids multiple booleans and makes logic readable.
- **Small helpers** (`StringExt`, `Constants`) reduce duplication and typos.
- **Bundle samples** for better first impression and dev experience.

## Tips for New Contributors
- Add a show: update `Constants`, then add a tab in `ContentView`.
- Change API behavior: edit `FetchService`.
- Adjust UI states: update `ViewModel.status` transitions and the `switch` in `FetchView`.
- Avoid duplicate loads: guard against re‑fetch when `status == .fetching` if needed.

## One‑liner Summary
“Views render what the ViewModel exposes. The ViewModel talks to a network service to fetch data and tracks a simple loading state. Sample data fills the UI immediately; `.task` replaces it with live data when the screen appears.”
