# Implementation log - Member 4 (feature/account-support)

## 01-06 Oct - getting the project running 
- Fixed the developer branch so it builds: wrong import paths, .gitignore, app id, package versions.
- Connected Firebase and started it before anything else in main.dart.
- Security rules for user accounts.
- Hasthakala colours in the theme.
- Agreed the Firestore structure with the group and rewrote the shared models.
- Sign in remembers you after restart; buyer / artisan / supporter contexts and "Continue as"; bottom navigation for buyers and artisans.

Problems we hit: Flutter not on PATH, missing Android command-line tools and NDK 28.2.13676358,
Windows Developer Mode needed for plugins, Kotlin build cache failing across drives, and the app hanging
on launch because Firebase was used before it started.
Started with interfaces I01,105,I13

## 06 Oct - I13 Family Assistance
- Artisan side: add a support user (name, relationship, phone, permissions), invitation code, pending invitations, edit permissions, revoke.
- Supporter side: accept with phone + code, supporter home showing only allowed areas, changes and revokes show up straight away.
- Rules for invites and grants.
- Still to agree with Member 3: a supporter with only the "respond to customers" permission can't reach order chats yet.

## 06 Oct - I05 Manage Artisan Profile
- View, edit (with validation, saving, offline, save failed and discard states), profile updated, profile created.
- Preview Public Profile opens Member 1's screen.
- Changing the name updates it everywhere it's copied.

## 02-06 Oct - I01 sign in and sign up
- Intro (first launch), Welcome Back, forgot password with a real reset email.
- Create Account -> Account Created -> How will you start -> You're all set / artisan setup.

## 06 Oct - I01 UI, part 1
- Animated splash, Choose Language (also in Profile), language saved to the account.
- Translations in lib/core/localization (see docs/TRANSLATION.md).
- Plus Jakarta Sans font, app icon and launch screen.

## 05-07 Oct - intro screen UI enhancement
- Intro is now three pages you can swipe: discover crafts, verified artisans, order/chat/track.
- Centred layout, page dots, Next / Get Started button, Skip in the same spot on every page.
- Pictures drawn with the brand colours until we have the hi-fi images.

## 05-07 Oct - I01 UI, part 2
- Welcome Back and Create Account: centred, labels above fields, live password checks, all text translated (including error messages).
- Account Created, How will you start, You're all set / artisan setup, Reset Password, Check your email, Continue as,
  Checking access and Support access removed restyled and translated.
- Same layout on all of them: content in the middle, buttons at the bottom.
