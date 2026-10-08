# Contributing

> [← Back to README](../README.md) · [Architecture](ARCHITECTURE.md) · [Data Layer](DATA_LAYER.md) · [UI Components](UI_COMPONENTS.md)

Thanks for your interest in improving GH Followers. This guide covers the conventions the codebase follows, step-by-step recipes for common changes, and a list of known limitations that make good first contributions.

---

## Contents

1. [Workflow](#workflow)
2. [Code conventions](#code-conventions)
3. [Recipes](#recipes)
4. [Manual test checklist](#manual-test-checklist)
5. [Known limitations](#known-limitations)
6. [Roadmap](#roadmap)

---

## Workflow

1. Fork the repo and create a branch from `master` (`feature/<short-name>` or `fix/<short-name>`).
2. Open `GHFollowers.xcodeproj` in **Xcode 26.6+** and build with an **iOS 26.5+** simulator.
3. Keep each commit focused on one logical change. Use present-tense, imperative messages that match the history (`Implement …`, `Add …`, `Refactor …`).
4. Go through the [manual test checklist](#manual-test-checklist) in Light **and** Dark Mode.
5. Open a pull request that explains *what* changed and *why*, with before/after screenshots for UI changes.

> **Synchronized folders:** The project uses Xcode's file-system-synchronized groups (`objectVersion = 77`). Any file you add under `GHFollowers/` joins the app target automatically, so you don't need to drag files into Xcode. This also means non-code files placed there (such as `Screenshots/`) are copied into the app bundle unless you exclude them under **Target Membership**.

---

## Code conventions

| Area | Convention |
|---|---|
| **Naming** | Reusable UI types use the `GF` prefix (`GFButton`, `GFAlertVC`). Screens end in `VC`. |
| **Folders** | Screens go in `Screens/`, reusable UI in `Custom Views/<Kind>/`, services in `Managers/`, and plain data in `Model/`. Shared helpers go in `Extensions/` or `Utilities/`. |
| **UI construction** | Programmatic only. No new storyboards or XIBs. |
| **Initializers** | Custom views do their setup in a `private func configure()` called from `init(frame:)`, and add convenience initializers for common options. `init?(coder:)` is `fatalError`. |
| **Auto Layout** | Components set `translatesAutoresizingMaskIntoConstraints = false` themselves. Use `NSLayoutConstraint.activate([...])`, `addSubviews(_:)`, and `pinToEdges(of:)`. |
| **Colors** | Semantic system colors only (`.label`, `.systemBackground`, `.systemGreen`, …) so Dark Mode keeps working. See [Design tokens](UI_COMPONENTS.md#design-tokens). |
| **Icons** | Add SF Symbols to `enum SFSymbols` and images to `enum Images`. Don't scatter string literals through the code. |
| **Helpers** | Stateless helpers are case-less `enum`s with `static` members. |
| **Errors** | Add a case to `GFError` whose raw value is a friendly, complete sentence. Show it with `presentGFAlertOnMainThread`. |
| **Memory** | Capture `[weak self]` in escaping closures. Delegate properties are `weak`, with protocols constrained to `AnyObject`. |
| **Threading** | Touch UIKit only on the main queue. Models that are decoded off the main thread must be `nonisolated`. |
| **Organization** | Put protocol conformances in extensions marked with `// MARK: -`. |

---

## Recipes

### Add a field to the profile header (for example, `company`)

1. Add `var company: String?` to `Model/User.swift`. Snake_case JSON keys are mapped automatically.
2. Add a `GFSecondaryTitleLabel` to `GFUserInfoHeaderVC`, include it in `addSubviews`, constrain it in `layoutUI()`, and set its text in `configureUIElements()` with a fallback.
3. If the header grows taller, update `headerView.heightAnchor` (190 pt) and the `contentView` height (600 pt) in `UserInfoVC.layoutUI()` / `configureScrollView()`.

### Add a new stats card

1. Add a case to `ItemInfoType` and its symbol and title in `GFItemInfoView.set(itemInfoType:withCount:)`. Add the SF Symbol to `SFSymbols`.
2. Create `GFMyItemVC: GFItemInfoVC` with its own `…Delegate` protocol. Configure `itemInfoViewOne`, `itemInfoViewTwo`, and `actionButton` in `viewDidLoad`, and override `actionButtonTapped()`.
3. In `UserInfoVC`, add a container `UIView` to `itemViews`, constrain it below the existing cards, and embed it with `add(childVC:to:)`. Conform to the new delegate.

### Add a new API call

1. Add a model in `Model/` that is `nonisolated` and `Codable`.
2. Add a method to `NetworkManager` that follows the [request pipeline](DATA_LAYER.md#request-pipeline). Return `Result<Model, GFError>` and map each failure to a `GFError`.
3. Call it from the view controller with `[weak self]`, and switch to the main queue for UI updates.

### Add a new screen

1. Create `Screens/MyVC.swift`. Inherit from `GFDataLoadingVC` if it loads data, or from `UIViewController` otherwise.
2. Build it from existing `GF*` components where possible.
3. Push it onto the current `navigationController` or present it modally. For a new tab, add a `createMyNC()` factory to `GFTabBarController` and add it to `viewControllers`.

---

## Manual test checklist

There is no automated test target yet, so check these by hand before opening a PR:

- [ ] Searching with an empty field shows the *"Empty username"* alert.
- [ ] Searching with a real username shows the followers grid with avatars.
- [ ] Searching for a non-existent username shows an error alert.
- [ ] A user with more than 50 followers loads more when you scroll to the bottom. A user with fewer stops paginating.
- [ ] A user with zero followers shows the empty state.
- [ ] Filtering narrows the grid, and tapping a filtered result opens the **correct** user.
- [ ] The details sheet shows the avatar, name, location, bio, all four stats, and "GitHub since …".
- [ ] **GitHub Profile** opens Safari in the app. **Get Followers** reloads the grid for that user.
- [ ] **+** adds a favorite, and a second **+** shows *"already favorited"*.
- [ ] Favorites are still there after quitting and relaunching the app.
- [ ] Tapping a favorite opens their followers. Swiping left removes the favorite.
- [ ] Airplane Mode shows the *"check your internet connection"* alert.
- [ ] Everything looks correct in Light and Dark Mode, and on a small device (iPhone SE).

---

## Known limitations

These are areas the current code doesn't handle yet. Each one is a good, self-contained contribution.

| # | Area | Limitation | Suggested direction |
|---|---|---|---|
| 1 | **Follower hopping** | `FollowerListVC.didRequestFollowers(for:)` resets `page` and the arrays, but not `hasMoreFollowers`, `isSearching`, or the search bar text. After viewing a user with fewer than 50 followers, switching to a user with more won't paginate. If you hop while a filter is active, `isSearching` stays `true` but `filteredFollowers` is empty, so the next tap on a cell indexes an empty array and crashes. | Reset all list state when the user changes, and dismiss the search controller. |
| 2 | **Empty-state artwork** | `Images.emptyStateLogo` loads `"empty-state-logo"`, but the image set is named `empty-state-logo-dark`, so the logo never appears. | Rename the image set to `empty-state-logo`. |
| 3 | **Favorites empty state** | Deleting the last favorite leaves an empty table until the screen appears again. A new `GFEmptyStateView` is added on every `viewWillAppear` while the list is empty, so they stack up. | Keep one empty-state view and show or hide it. Check `favorites.isEmpty` after deleting. |
| 4 | **Threading** | Network callbacks run on a background queue and change some view-controller state (`followers`, `isLoadingMoreFollowers`) before switching to main. | Move to `async/await` with `@MainActor` view controllers. |
| 5 | **Rate limiting** | Requests are unauthenticated (60/hour). A 403 shows the generic *"Invalid response"*. | Add an optional token and specific messages for 403 and 404. |
| 6 | **Search scope** | The search bar filters only the pages already loaded, not all of the user's followers. | Mention this in the placeholder, or load all pages while a search is active. |
| 7 | **Cell reuse** | `FollowerCell` and `FavoriteCell` don't reset the avatar in `prepareForReuse`, so a reused cell can briefly show the previous image. A failed download sets the image to `nil` rather than the placeholder. | Reset to the placeholder in `prepareForReuse`, and fall back to it when a download fails. |
| 8 | **Image cache** | Avatars are cached in memory only, so they're downloaded again on every launch. | Use `URLCache`, or a disk cache in addition to `NSCache`. |
| 9 | **Testability** | There's no test target, and `NetworkManager` is a hard-coded singleton. | Put networking behind a protocol, inject it, and add unit tests for decoding, persistence, and date formatting. |
| 10 | **Bundle size** | `GHFollowers/Screenshots/` (~3.3 MB) sits inside the synchronized app folder, so it is bundled into the `.app`. | Move it to a top-level `docs/screenshots/` folder (and update the README paths), or exclude it from target membership. |
| 11 | **Input** | The username isn't trimmed, so a trailing space causes a 404. | Trim whitespace and newlines before searching. |

---

## Roadmap

- [ ] Fix known limitations 1–3 (quick wins)
- [ ] Migrate `NetworkManager` to `async/await`
- [ ] Add a unit-test target
- [ ] Optional GitHub token support with a settings screen
- [ ] Pull-to-refresh on the followers grid
- [ ] Show more profile fields (company, blog, Twitter/X) in the header
- [ ] Landscape and iPad-optimized layouts (for example, more grid columns on wider screens)
- [ ] Accessibility pass (VoiceOver labels for avatars and stats, Dynamic Type for title labels)
