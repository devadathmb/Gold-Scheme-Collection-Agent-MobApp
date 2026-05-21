# Collection Agent App

A Flutter mobile application for field collection agents to manage customer payment collections.

## Features

- **Import** customer data from head-office Excel (.xlsx) files
- **Local SQLite database** via Drift — works fully offline
- **Search** customers by ID, name, or phone number (live, debounced)
- **Record collections** with validation against outstanding amounts
- **Export** updated Excel with all collection data to share back to head office
- Dashboard with daily stats (total collected, count, customers)

---

## Project Structure

```
lib/
├── data/
│   ├── tables/customers.dart     # Drift table schema
│   ├── daos/customer_dao.dart    # All DB queries
│   └── database.dart             # AppDatabase singleton
├── providers/
│   ├── database_provider.dart    # DB + DAO providers
│   ├── search_provider.dart      # Search query + results
│   └── excel_provider.dart       # Import/export state
├── services/
│   └── excel_service.dart        # Excel read/write logic
├── screens/
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

### 3. Run the app

```bash
flutter run
```

---

## Excel Format Expected from Head Office

The import expects these **exact column headers** in the first row:

| Column | Required | Notes |
|---|---|---|
| `Customer ID` | ✅ | Unique identifier |
| `Name` | ✅ | Customer full name |
| `Phone` | ✅ | Phone number |
| `Address` | ❌ | Optional |
| `Outstanding Amount` | ❌ | Numeric, e.g. `5000.00` |

> **Important:** Coordinate with head office to lock down these exact header names. Update `ExcelColumns` constants in `lib/services/excel_service.dart` if they differ.

---

## Excel Export Columns

The export file sent back to head office contains:

| Column | Description |
|---|---|
| Customer ID | Original ID from import |
| Name | Customer name |
| Phone | Phone number |
| Address | Address |
| Outstanding Amount | Original amount due |
| Collected Amount | Amount entered by agent |
| Balance | Outstanding − Collected |
| Notes | Agent's notes |
| Updated At | Timestamp of last edit |

---

## Key Customisations

### Currency symbol
In `lib/utils/app_theme.dart`, update `AppCurrencyFormat.format()`:
```dart
static String format(double amount) {
  return '₹${amount.toStringAsFixed(2)}'; // Change ₹ to your symbol
}
```

### Excel column headers
In `lib/services/excel_service.dart`, update `ExcelColumns`:
```dart
class ExcelColumns {
  static const customerId = 'Customer ID';  // match head office exactly
  static const name = 'Name';
  static const phone = 'Phone';
  static const address = 'Address';
  static const outstandingAmount = 'Outstanding Amount';
}
```

### Import behaviour
- **"Import Excel"** — upserts customers, preserves existing collected amounts
- **"Replace All"** — clears database first, then imports fresh (use at start of day)

---

## Code Generation Files

After running `build_runner`, these files are auto-generated — do not edit:
- `lib/data/database.g.dart`
- `lib/data/daos/customer_dao.g.dart`

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
|---|---|
| `drift` | Type-safe SQLite ORM |
| `sqlite3_flutter_libs` | Native SQLite binaries |
| `flutter_riverpod` | State management |
| `excel` | Read/write .xlsx files |
| `file_picker` | Pick files from device |
| `share_plus` | Share files via system sheet |
| `path_provider` | App directories |
| `intl` | Date/number formatting |
