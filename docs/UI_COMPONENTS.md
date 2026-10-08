# UI Components

> [← Back to README](../README.md) · [Architecture](ARCHITECTURE.md) · [Data Layer](DATA_LAYER.md) · [Contributing](CONTRIBUTING.md)

GH Followers ships with a small in-house UI kit under `GHFollowers/Custom Views/`. Every component uses the **`GF`** prefix (GitHub Followers), sets up its own Auto Layout (`translatesAutoresizingMaskIntoConstraints = false`), and uses semantic system colors, so it works in Light and Dark Mode without extra code.

---

## Contents

- [Design tokens](#design-tokens)
- [Buttons](#buttons) · [Text fields](#text-fields) · [Labels](#labels)
- [Image views](#image-views) · [Cells](#cells)
- [Views](#views) · [View controllers](#view-controllers) · [Tab bar](#tab-bar)
- [Assets](#assets)
- [Component map by screen](#component-map-by-screen)

---

## Design tokens

These values are hard-coded in the components. They're listed here so new UI stays consistent.

### Color

| Token | UIKit color | Where |
|---|---|---|
| Accent | `.systemGreen` | Tab bar and nav bar tint, **Get Followers** buttons, **+** and **Done** bar buttons |
| Secondary action | `.systemPurple` | **GitHub Profile** button |
| Alert action | `.systemPink` | `GFAlertVC` button |
| Screen background | `.systemBackground` | All screens, alert container, loading overlay |
| Card background | `.secondarySystemBackground` | `GFItemInfoVC` cards |
| Input background | `.tertiarySystemBackground` | `GFTextField` |
| Input border | `.systemGray4` | `GFTextField` (2 pt) |
| Primary text | `.label` | `GFTitleLabel`, `GFTextField`, stat icons |
| Secondary text | `.secondaryLabel` | `GFSecondaryTitleLabel`, `GFBodyLabel`, location pin, empty-state message |
| Alert scrim | `UIColor.black` at 75% | `GFAlertVC` background |

### Corner radius

| Value | Components |
|---|---|
| 10 pt | `GFButton`, `GFTextField`, `GFAvatarImageView` |
| 16 pt | `GFAlertContainerView` |
| 18 pt | `GFItemInfoVC` cards |

### Typography

| Component | Font |
|---|---|
| `GFTitleLabel` | `systemFont(ofSize: n, weight: .bold)`, with the size set per use |
| `GFSecondaryTitleLabel` | `systemFont(ofSize: n, weight: .medium)` |
| `GFBodyLabel` | `preferredFont(forTextStyle: .body)` (Dynamic Type) |
| `GFButton` | `preferredFont(forTextStyle: .headline)` |
| `GFTextField` | `preferredFont(forTextStyle: .title2)` |

Title sizes used in the app: **34** (profile username), **28** (empty-state message), **26** (favorite row), **20** (alert title), **16** (grid username), **14** (stat title and count).

### Common heights

| Element | Height |
|---|---|
| Primary buttons and text field (`SearchVC`) | 50 pt |
| Card / alert buttons | 44 pt |
| Favorite row | 80 pt |
| Profile avatar | 90 × 90 pt |
| Favorite avatar | 60 × 60 pt |

---

## Buttons

### `GFButton`

`Custom Views/Buttons/GFButton.swift`, a subclass of `UIButton`.

| | |
|---|---|
| Style | 10 pt corners, white title, `.headline` font |
| Initializers | `init(frame:)`, and the convenience `init(backgroundColor:title:)` |
| Methods | `set(backgroundColor:title:)` to restyle after creation (used by the item cards) |

```swift
let cta = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
```

---

## Text fields

### `GFTextField`

`Custom Views/TextFields/GFTextField.swift`, a subclass of `UITextField`, built for entering usernames.

| Setting | Value | Reason |
|---|---|---|
| `autocorrectionType` | `.no` | Usernames aren't dictionary words |
| `autocapitalizationType` | `.none` | Keeps input exactly as typed |
| `returnKeyType` | `.go` | The return key starts the search (handled by `SearchVC`) |
| `clearButtonMode` | `.whileEditing` | Quick reset |
| `adjustsFontSizeToFitWidth` / `minimumFontSize` | `true` / 12 | Long usernames still fit |
| `placeholder` | "Enter a username" | |

---

## Labels

All labels shrink text to fit (`adjustsFontSizeToFitWidth`) before truncating.

| Component | Initializer | Color | Min scale | Line break |
|---|---|---|---|---|
| `GFTitleLabel` | `init(textAlignment:fontSize:)` | `.label` | 0.90 | `.byTruncatingTail` |
| `GFSecondaryTitleLabel` | `init(fontSize:)` | `.secondaryLabel` | 0.90 | `.byTruncatingTail` |
| `GFBodyLabel` | `init(textAlignment:)` | `.secondaryLabel` | 0.75 | `.byWordWrapping` |

---

## Image views

### `GFAvatarImageView`

`Custom Views/ImageViews/GFAvatarImageView.swift`, a subclass of `UIImageView`.

- Rounded (10 pt) and clipped, and starts with the `avatar-placeholder` asset.
- `downloadImage(fromURL:)` asks `NetworkManager` for the image (cache first) and sets it on the main queue.

> **Cell reuse:** The avatar isn't reset to the placeholder in `prepareForReuse`. During very fast scrolling, a reused cell can briefly show the previous avatar until the new one arrives. See [Known limitations](CONTRIBUTING.md#known-limitations).

---

## Cells

### `FollowerCell` (grid)

`Custom Views/Cells/FollowerCell.swift`, a `UICollectionViewCell` with `reuseID = "FollowerCell"`.

```text
┌──────────────┐
│ ┌──────────┐ │  ← GFAvatarImageView, square, 8 pt inset
│ │  avatar  │ │
│ └──────────┘ │
│   username   │  ← GFTitleLabel(.center, 16), 12 pt below, 20 pt tall
└──────────────┘
```

API: `set(follower: Follower)`.

### `FavoriteCell` (list)

`Custom Views/Cells/FavoriteCell.swift`, a `UITableViewCell` with `reuseID = "FavoriteCell"`.

```text
┌─────────────────────────────────────────┐
│ [60×60 avatar]   username           >   │  ← GFTitleLabel(.left, 26), disclosure indicator
└─────────────────────────────────────────┘
```

API: `set(favorite: Follower)`.

---

## Views

### `GFItemInfoView`

`Custom Views/Views/GFItemInfoView.swift`. One stat: an SF Symbol, a title, and a count.

```swift
enum ItemInfoType { case repos, gists, following, followers }
```

| Type | SF Symbol | Title |
|---|---|---|
| `.repos` | `folder` | Public Repos |
| `.gists` | `text.alignleft` | Public Gists |
| `.followers` | `heart` | Followers |
| `.following` | `person.2` | Following |

API: `set(itemInfoType:withCount:)`.

### `GFEmptyStateView`

`Custom Views/Views/GFEmptyStateView.swift`. A centered message (`GFTitleLabel`, 28 pt, `.secondaryLabel`, 3 lines) above the oversized `empty-state-logo`, which is anchored to the bottom-right corner and partly off-screen as a decorative accent. On iPhone SE and iPhone 8 Display Zoom, the offsets are reduced.

API: `init(message:)`. Normally shown through `GFDataLoadingVC.showEmptyStateView(with:in:)`.

### `GFAlertContainerView`

`Custom Views/Views/GFAlertContainerView.swift`. The card behind `GFAlertVC`: a `systemBackground` fill, 16 pt corners, and a 2 pt white border.

---

## View controllers

### `GFAlertVC`

`Custom Views/ViewControllers/GFAlertVC.swift`. A branded replacement for `UIAlertController`.

```text
╔════════════════════════════╗   280 × 220 pt card, centered on a 75% black scrim
║        Alert Title         ║   GFTitleLabel(.center, 20)
║                            ║
║   Message text, up to 4    ║   GFBodyLabel(.center)
║   lines, centered.         ║
║                            ║
║  ┌──────────────────────┐  ║
║  │         Ok           │  ║   GFButton(.systemPink), dismisses
║  └──────────────────────┘  ║
╚════════════════════════════╝
```

Always present it through the extension. It handles switching to the main queue and the presentation style:

```swift
presentGFAlertOnMainThread(title: "Empty username",
                           message: "Please enter a username.",
                           buttonTitle: "Ok")
```

### `GFDataLoadingVC`

`Custom Views/ViewControllers/GFDataLoadingVC.swift`. A base class for screens that load data.

| Method | Effect |
|---|---|
| `showLoadingView()` | Adds a full-screen overlay that fades to 0.8 opacity over 0.25 s, with a large spinner |
| `dismissLoadingView()` | Removes the overlay on the main queue |
| `showEmptyStateView(with:in:)` | Adds a full-size `GFEmptyStateView` |

### `GFUserInfoHeaderVC`

`Custom Views/ViewControllers/GFUserInfoHeaderVC.swift`. The top of the details sheet.

```text
┌────────┐  username (bold 34)
│ avatar │  Full Name (medium 18, secondary)
│ 90×90  │  📍 Location (medium 18, secondary)
└────────┘
Bio text, up to 3 lines (body, secondary)
```

Fallbacks: no name shows an empty string, no location shows "No Location", and no bio shows "No bio available".

### `GFItemInfoVC` and its subclasses

`Custom Views/ViewControllers/ItemInfoVCs/`. A reusable stats card that subclasses fill in:

```text
╭──────────────────────────────────────╮  secondarySystemBackground, 18 pt corners
│  [icon] Title          [icon] Title  │  horizontal UIStackView (.equalSpacing), 50 pt
│         123                    45    │
│  ┌────────────────────────────────┐  │
│  │         Action Button          │  │  GFButton, 44 pt
│  └────────────────────────────────┘  │
╰──────────────────────────────────────╯
```

| Subclass | Items | Button | Delegate |
|---|---|---|---|
| `GFRepoItemVC` | Public Repos · Public Gists | **GitHub Profile** (`.systemPurple`) | `GFRepoItemVCDelegate.didTapGitHubProfile(for:)` |
| `GFFollowerItemVC` | Followers · Following | **Get Followers** (`.systemGreen`) | `GFFollowerItemVCDelegate.didTapGetFollowers(for:)` |

To make a new card, subclass `GFItemInfoVC`, configure `itemInfoViewOne` / `itemInfoViewTwo` / `actionButton` in `viewDidLoad`, and override `actionButtonTapped()`.

---

## Tab bar

### `GFTabBarController`

`Custom Views/TabBarControllers/GFTabBarController.swift`.

| Tab | Root | Icon | Tag |
|---|---|---|---|
| Search | `SearchVC` in a `UINavigationController` | `magnifyingglass` | 0 |
| Favorites | `FavoritesListVC` in a `UINavigationController` | `star.fill` | 1 |

The tab bar tint is set globally with `UITabBar.appearance().tintColor = .systemGreen`.

> The tab item title is set to "Favorite" in `createFavoritesNC()`, but `FavoritesListVC.viewDidLoad()` sets `title = "Favorites"`, which also renames the tab. That's why the screenshots show **Favorites**.

---

## Assets

`Support/Assets.xcassets`

| Asset | Constant | Light / Dark | Used in |
|---|---|---|---|
| `AppIcon` | — | Light | Home screen |
| `gh-logo` | `Images.ghLogo` | ✓ / ✓ | `SearchVC` hero (200 × 200 pt) |
| `avatar-placeholder` | `Images.placeholder` | ✓ / ✓ | `GFAvatarImageView` default |
| `empty-state-logo-dark` (asset set) | `Images.emptyStateLogo` → `"empty-state-logo"` | ✓ / ✓ | `GFEmptyStateView` |
| `AccentColor` | — | Default | Global accent (not customized; components use `.systemGreen` directly) |

> **Heads-up:** Asset-catalog images are looked up by **image set name**. The set is named `empty-state-logo-dark`, but `Images.emptyStateLogo` calls `UIImage(named: "empty-state-logo")`, which returns `nil`, so the decorative logo never appears on empty screens. Rename the image set to `empty-state-logo` (the light and dark variants inside it are already set up correctly) to fix it.

SF Symbols are collected in `Utilities/Constants.swift` → `enum SFSymbols` (`location`, `repos`, `gists`, `followers`, `following`).

---

## Component map by screen

| Screen | Components |
|---|---|
| **SearchVC** | `UIImageView` (gh-logo), `GFTextField`, `GFButton` |
| **FollowerListVC** | `UICollectionView` + `FollowerCell` (`GFAvatarImageView`, `GFTitleLabel`), `UISearchController`, `GFEmptyStateView`, loading overlay |
| **UserInfoVC** | `GFUserInfoHeaderVC` (`GFAvatarImageView`, `GFTitleLabel`, `GFSecondaryTitleLabel` × 2, `GFBodyLabel`), `GFRepoItemVC` and `GFFollowerItemVC` (`GFItemInfoView` × 2, `GFButton`), `GFBodyLabel` (date) |
| **FavoritesListVC** | `UITableView` + `FavoriteCell` (`GFAvatarImageView`, `GFTitleLabel`), `GFEmptyStateView` |
| **Everywhere** | `GFAlertVC` (`GFAlertContainerView`, `GFTitleLabel`, `GFBodyLabel`, `GFButton`) |
