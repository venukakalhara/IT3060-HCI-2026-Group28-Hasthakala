# Decisions

Things we agreed on while building the app, and why. Newest at the bottom.

| # | Date | What we decided | Why |
|---|---|---|---|
| T1 | 01 Oct | Flutter + Firebase (Auth, Firestore, Storage) | No separate backend to build and host,experimenting and fixing issues |
| T2 | 01-05 Oct | Everyone uses Flutter 3.47.6 / Dart 3.13.5 | Same builds on every laptop |
| T3 | 01-05 Oct | App ID `lk.hasthakala.app` | Had to be fixed before registering the app in Firebase |
| T4 | 01-05 Oct | `kotlin.incremental=false` in android/gradle.properties | Builds failed on Windows when the project and the pub cache were on different drives |
| T5 | 01-06 Oct | Firebase project `hasthakala-group28`, Firestore in asia-south1, email/password sign in | Closest region; simplest sign in for the time we had |
| T6 | 06 Oct | Cloud Storage not enabled yet | It needs the Blaze billing plan - still to decide as a group |
| D1 | 06 Oct | No role field. A person can be a buyer, an artisan (if they have an artisan profile) and a supporter (if an artisan invited them). "Continue as" only shows when someone has more than one | The hi-fi shows the same person as buyer and artisan, and we didn't want to ask every time someone signs in |
| D2 | 06 Oct | English, Sinhala and Tamil for all fixed text (`context.tr('key')`), saved on the phone and in `users.preferredLanguage` | Language was a must for the group; Milestone 01 showed language barriers |
| D3 | 06 Oct | Email/password only for now (no Google, biometrics or passkey) | Time, and Google sign in needs setup on every developer's laptop |
| D3a | 01-09 Oct | Google sign in added (google_sign_in + Firebase); fingerprint and passkey shown as "Soon" | Matches the hi-fi more closely; Google needs each laptop's SHA-1 in Firebase |
| D4 | 06 Oct | Family support invites use the phone number form from the hi-fi plus a 6-digit code | We have no SMS service, and a typed phone number alone doesn't prove who someone is |
| D5 | 06 Oct | Order status: pending, confirmed, preparing, shipped, delivered, cancelled | Matches the labels in the hi-fi |
| S1 | 06 Oct | Firestore field names are fixed (docs/FIREBASE_SCHEMA.md) - only new optional fields can be added | Four people work on the same data |
| S2 | 06 Oct | One order per artisan; cart stored in users/{uid}/cart | Each artisan only sees their own orders |
| S3 | 06 Oct | Ratings worked out from reviews, not stored | They can't get out of sync or be edited by hand |
| R1 | 06 Oct | products, orders, conversations and reviews have simple "signed in only" rules for now | So everyone could start building - to be replaced before functional testing |
| I13a | 06 Oct | Accepting an invite needs both the code and the phone number, and the grant must match the invite (checked in the rules) | A guessed code isn't enough, and a supporter can't give themselves extra permissions |
| I13b | 06 Oct | Pending invitations are listed on Family Assistance with a cancel button | The artisan can see or cancel codes that haven't been used |
| I13c | 06 Oct | Revoking access keeps the grant with status `revoked` | We keep a record; inviting the person again creates a new invite |
| I13d | 06 Oct | supportGrants has an extra optional field `inviteCode` | The rules use it to check the grant against its invite |
| I13e | 06 Oct | Permission labels in plain words (Manage products / Manage orders / Respond to customers) | Interface codes like I11 mean nothing to real users |
| I13f | 06 Oct | "Copy invitation message" button | Families already use WhatsApp and SMS for this kind of thing (Milestone 01) |
| I01a | 06 Oct | Sign out asks "Sign out?" first | Stops accidental sign outs |
| I01b | 06 Oct | Sign up has two steps: Create Account, then "How will you start using HASTHAKALA?" writes users/{uid} | Same order as the hi-fi; if the app closes in between, it goes back to that question |
| I01c | 06 Oct | Intro screen only on first launch (`shared_preferences`) | Nobody wants to see it every time |
| I01d | 06 Oct | Circular logo (`assets/images/hasthakala_logo.png`) | The logo had to be circular; works well at small sizes |
| I05a | 06 Oct | Changing the artisan name also updates the account name, products, support grants and pending invites | The old name was still showing on some screens |
| I05b | 06 Oct | If a save gets no reply in 10 seconds we show "You're offline" | Firestore waits instead of failing when there's no connection |
| I05c | 07 Oct | Artisans can pick a profile cover (2 photos or 4 colour covers from our palette) | Lets artisans make their profile a bit more their own while keeping the brand colours and readable text |
| R2 | 08 Oct | Security rules v2 in two phases: products, chats and reviews now; orders once checkout saves artisanId and the artisan list is filtered | Checks must run on the server, not just by hiding buttons; phasing keeps everyone's current code working |
| R2a | 08 Oct | redesidn Order and chat list queries must filter by artisanId / buyerId | Firestore refuses a whole query that could return documents the person can't read |
| I05d | 08 Oct |   REFIXED Profile photo saved as a small base64 avatar in profilePhotos/{uid}, outside the profile forms | Free (no Blaze), changes no existing field or form logic; low resolution is fine for an avatar only |
| U1 | 06 Oct | Dark mode is a planned improvement, not done now | Colours are set per screen in everyone's code, so a half-done dark mode would look broken in testing |
| B1 | 06 Oct | Animated splash, Hasthakala app icon and launch screen | Replace the default Flutter logo |
| B2 | 06 Oct | Plus Jakarta Sans font included; Sinhala and Tamil use the phone's fonts | Font from the hi-fi; it has no Sinhala or Tamil letters |
