# Differences from the Milestone 02 hi-fi

Where the app doesn't match the hi-fi prototype, and why.

| # | Screen | In the hi-fi | In the app | Why | Effect |
|---|---|---|---|---|---|
| DV1 | All | Choose Language: Sinhala / English / Tamil | All fixed text (labels, buttons, messages) is translated. Text people type, like product names and messages, stays as written. | Translating typed text would need a paid translation service | Language barrier mostly handled; some content can still be in another language |
| DV2 | I01 | Google, biometrics and passkey sign in | Email and password only | Time, and Google sign in needs extra setup on each laptop. Flutter does support them. | Fewer sign-in choices; nothing else affected |
| DV3 | I13 | "Tharushi will receive an invitation" | Invitation sent screen shows a 6-digit code, the steps to follow and a "Copy invitation message" button. The code can be opened again from Pending Invitations. | We have no SMS service; a phone number alone doesn't prove who someone is | One extra step for the artisan; safer |
| DV4 | I13 | No screen for the supporter to accept | Profile > Accept support invitation: phone number + code | Needed for DV3 | Supporter still uses their own account |
| DV5 | I13 | Only active support users listed | Pending invitations listed too, with a cancel button | The artisan can see or cancel unused codes | Adds a delete action |
| DV6 | I05 | Change / add profile photo | Change Photo / Add Photo picks from the gallery or camera; a small compressed copy is saved in Firestore (`profilePhotos/{uid}`) | Photo upload to Cloud Storage needs the paid Blaze plan | Works on our screens; other screens still show the initial unless they read profilePhotos |
| DV7 | I01 | "Remember me" checkbox | Not shown | Firebase already keeps you signed in until you sign out | No effect |
| DV8 | I01 | Intro screen with an artisan photo | Uses the logo for now | Waiting for the image | Visual only |
