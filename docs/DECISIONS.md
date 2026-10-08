# Decisions Log — Hasthakala (Group 28)

| ID | Date | Decision | Reason | Affects |
|---|---|---|---|---|
| T1 | 05 Oct | Stack: Flutter + Firebase (Auth, Firestore, Storage) | No custom API layer to build/host; integrated mobile services | All |
| T2 | 05 Oct | Flutter 3.47.6 / Dart 3.13.5 for all members | `.metadata` revision 5fc3468; identical builds | All |
| T3 | 05 Oct | Android application ID `lk.hasthakala.app` | Must be final before Firebase registration | All |
| T4 | 05 Oct | `kotlin.incremental=false` in android/gradle.properties | Kotlin cache fails when project (D:) and pub cache (C:) are on different drives on Windows | All (Windows) |
| T5 | 06 Oct | Firebase project `hasthakala-group28`, Firestore `asia-south1`, Email/Password auth | Closest region; simplest auth for 3-day scope | All |
| T6 | 06 Oct | Cloud Storage deferred (needs Blaze billing) | Pending group decision on billing | I05, I11 images |
| D1 | 06 Oct | Contexts instead of a role field; "Continue as" only with >1 context | Hi-fi shows multi-context accounts; Prompt 2 forbids asking every login | I01, all routing |
| D2 | 06 Oct | English only for now; language screen not implemented yet | Time; may be added if time allows (users.preferredLanguage reserved) | I01 (deviation) |
| D3 | 06 Oct | Email/password only for now; Google/passkey/biometrics not implemented yet | Time and per-machine setup cost; may be added if time allows | I01 (deviation) |
| D4 | 06 Oct | I13 invite: phone-number form as designed + 6-digit invite code | No SMS backend; a typed phone number does not prove identity (NFR3) | I13 (minor deviation) |
| D5 | 06 Oct | Order status: pending, confirmed, preparing, shipped, delivered, cancelled | Matches hi-fi labels | I07, I08, I10, I12 |
| S1 | 06 Oct | Firestore schema locked (docs/FIREBASE_SCHEMA.md); additions only | Four members share the same data | All |
| S2 | 06 Oct | One order per artisan; cart in users/{uid}/cart | Clear ownership for I12 and security rules | I06, I07, I12 |
| S3 | 06 Oct | Ratings computed from reviews, not stored | Cannot be faked or go out of sync (FR4, NFR2) | I04, I05 |
| R1 | 06 Oct | **TEMPORARY** signed-in-only rules for products/orders/conversations/reviews | Unblock development; MUST become v2 owner/grant rules before functional testing | NFR3 — OPEN |
