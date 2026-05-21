```markdown
# Field Collection Agent App

A Flutter mobile application for field collection agents to securely manage customer payment collections and calculate gold equivalent weights.

## Features

- **Secure Access** via a persistent 4-digit Agent PIN setup on first launch.
- **Import** customer data from head-office Excel (.xlsx) files.
- **Local SQLite database** via Drift — works fully offline.
- **Search** customers by PassBook No, name, or phone number (live, debounced).
- **Gold Rate Calculation** to automatically convert received amounts into Equivalent Weight (Eq Wt).
- **Record collections** and maintain updated payment states.
- **Export** updated Excel with all collection data to share back to head office.
- **Dashboard** with daily stats (total received, collections made, total customers, current gold rate).

---

## Project Structure

```text
lib/
├── data/
│   ├── tables/customers.dart     # Drift table schema
│   ├── daos/customer_dao.dart    # All DB queries
│   └── database.dart             # AppDatabase singleton
├── providers/
│   ├── auth_provider.dart        # PIN login & security state
│   ├── database_provider.dart    # DB + DAO providers
│   ├── search_provider.dart      # Search query + results
│   ├── excel_provider.dart       # Import/export state
│   └── gold_rate_provider.dart   # Daily gold rate state
├── services/
│   └── excel_service.dart        # Excel read/write logic
├── screens/
│   ├── splash_screen.dart        # Animated startup screen
│   ├── login_screen.dart         # PIN authentication
│   ├── home_screen.dart          # Dashboard + import
│   ├── search_screen.dart        # Search + customer list
│   ├── customer_detail_screen.dart # View + enter collection
│   └── export_screen.dart        # Export & share
├── widgets/
│   ├── stat_card.dart
│   └── customer_tile.dart
├── utils/
│   └── app_theme.dart            # Colors, theme, currency format
└── main.dart

```

---

## Setup

### 1. Install dependencies

```bash
flutter pub get

```

### 2. Run code generation (Drift + Riverpod)

```bash
dart run build_runner build --delete-conflicting-outputs

```

> Run this every time you change a `@DriftDatabase`, table, or DAO file.

### 3. Generate native assets (Icons & Splash Screen)

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create

```

### 4. Run the app

```bash
flutter run

```

---

## Excel Format Expected from Head Office

The import expects these **exact column headers** in the first row:

| Column | Required | Notes |
| --- | --- | --- |
| `PassBookNo.` | ✅ | Unique identifier |
| `Applicant Name` | ✅ | Customer full name |
| `Phone no` | ✅ | Phone number |
| `Amount` | ❌ | Expected due amount |
| `Eq Wt.` | ❌ | Target equivalent weight |

> **Important:** Coordinate with head office to lock down these exact header names. Update `ExcelColumns` constants in `lib/services/excel_service.dart` if they differ.

---

## Excel Export Columns

The export file sent back to head office contains:

| Column | Description |
| --- | --- |
| PassBookNo. | Original ID from import |
| Applicant Name | Customer name |
| Phone no | Phone number |
| Amount | Original expected amount |
| Received Amount | Amount entered by agent |
| Gold Rate | The rate set by the agent during collection |
| Eq. Wt. (Added) | Calculated equivalent weight of received amount |
| Notes | Agent's notes |
| Date/Time | Timestamp of the transaction |

---

## Key Customizations

### Currency symbol

In `lib/utils/app_theme.dart`, update `AppCurrencyFormat.format()`:

```dart
static String format(double amount) {
  return '₹${amount.toStringAsFixed(2)}'; // Change ₹ to your symbol
}

```

### Excel column headers

In `lib/services/excel_service.dart`, update `ExcelColumns` to match the expected format exactly.

### Import behavior

* **"Import and Clear Data"** — Clears the database first, then imports fresh records from the head office file to prevent duplicate or stale entries.

---

## Code Generation Files

After running `build_runner`, these files are auto-generated — do not edit:

* `lib/data/database.g.dart`
* `lib/data/daos/customer_dao.g.dart`

---

## Android Permissions

Copy `android_manifest_sample.xml` content into your actual `android/app/src/main/AndroidManifest.xml`. Also create `android/app/src/main/res/xml/file_paths.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <cache-path name="cache" path="." />
    <external-cache-path name="external_cache" path="." />
    <files-path name="files" path="." />
</paths>

```

---

## Dependencies

| Package | Purpose |
| --- | --- |
| `drift` | Type-safe SQLite ORM |
| `sqlite3_flutter_libs` | Native SQLite binaries |
| `flutter_riverpod` | State management |
| `excel` | Read/write .xlsx files |
| `file_picker` | Pick files from device |
| `share_plus` | Share files via system sheet |
| `path_provider` | App directories |
| `intl` | Date/number formatting |
| `shared_preferences` | Persistent local storage (PIN & Gold Rate) |
| `flutter_launcher_icons` | App icon generation |
| `flutter_native_splash` | Native splash screen generation |

```

```