# Implementation Log — Hasthakala (Group 28)

## Session 1 — 05/06 Oct 2026 — Member 4 — branch `feature/account-support`

**Task:** Project foundation so all members can build on a working app.

| Commit | What | Requirement / Interface |
|---|---|---|
| 3f83d9c | Fixed 45 broken import paths, app `.gitignore`, app ID `lk.hasthakala.app`, packages upgraded for Flutter 3.47, `kotlin.incremental=false` | Build (all) |
| 0167f17 | Firebase project connected (`flutterfire configure`), Firebase initialised in `main.dart` before services | NFR3, all |
| 5aa5dd5 | Firestore rules v1 (strict `users`) | I01, NFR3 |
| fdc7b78 | Hasthakala palette in `app_colors.dart` / `app_theme.dart` | NFR5, hi-fi fidelity |
| ad00fbd | Locked schema + shared models, contexts instead of role, rules v1.1 | All FRs, D1–D5 |
| (this) | Session restore, context resolution, "Continue as", artisan profile setup, buyer/artisan navigation shells, friendly auth errors, rules v1.2 | I01, I05 (create), FR1, FR9 (context only), NFR1, NFR3 |

**Errors met and fixes**
- `flutter` not on PATH → installed Flutter 3.47.6 at `D:\dev\flutter`, added to user PATH.
- Android cmdline-tools / licences missing → installed via SDK Manager, `flutter doctor --android-licenses`.
- NDK 28.2.13676358 missing → installed via SDK Manager (Show Package Details).
- Windows symlink error → enable Developer Mode.
- Kotlin incremental cache crash (project on D:, pub cache on C:) → `kotlin.incremental=false`.
- App stuck on launch screen → Firebase was used before `Firebase.initializeApp`; fixed in `main.dart`.

**Tests executed (manual)**
- Register buyer → `users` doc created, rules allow own write. PASS.
- Register seller (`primaryPurpose: sell`) → Timestamp dates, no legacy fields. PASS.

**Pending**
- I01 hi-fi polish (visual fidelity, reset password, sign-out confirmation, session-expired state).
- I05 Manage (view/edit/preview) and I13 (invite, accept, permissions, revoke, rules v2).
- Replace TEMPORARY rules (R1) before functional testing.
- Cloud Storage decision (T6) for profile/product photos.
