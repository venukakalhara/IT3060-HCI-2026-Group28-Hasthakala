# Hasthakala — Firestore Schema (LOCKED)

**Status:** Locked on 06 Oct 2026 (Group 28).
**Rule:** Collection and field names below are **never renamed or removed**.
Only **new optional fields** may be added, after telling the whole group.

Shared Dart models live in `lib/core/shared_models/`. Collection names live in
`lib/core/constants/firestore_collections.dart`. Always use those — never type
collection or field names by hand.

## Conventions

- Collection and field names: `camelCase`.
- Dates: Firestore `Timestamp` (use `FirestoreConverters` in `lib/core/utils/`).
- Money: number, Sri Lankan Rupees (LKR).
- Every document stores its own ID as a field (e.g. `productId`, `orderId`).
- Some Dart property names differ from stored field names for compatibility
  with existing code. The **stored** name is what is locked (see each model's header comment).

## Contexts (decision D1)

There is **no role field**. What a person can do is worked out from data:

| Context | Exists when | Notes |
|---|---|---|
| Buyer | Always | Every account can shop |
| Artisan | `artisanProfiles/{uid}` exists | Created by I05 artisan profile setup |
| Supporting an artisan | An `active` document in `supportGrants` with `supporterId == uid` | Only via I13 invitation — never self-selected |

"Continue as…" is shown only when a user has more than one context.

## Collections

### `users/{uid}` — account (I01, Member 4) — model: `UserModel`
| Field | Type | Notes |
|---|---|---|
| uid, email, displayName | string | |
| phone | string \| null | Used to match I13 invites |
| photoUrl | string \| null | |
| primaryPurpose | `"shop"` \| `"sell"` | Answer to "How will you start using HASTHAKALA?" Not a permission. |
| preferredLanguage | string | `"en"` (D2: other languages may be added later) |
| defaultDeliveryAddress | map \| null | Same shape as `orders.deliveryAddress` |
| createdAt, updatedAt | timestamp | |
Subcollection `users/{uid}/cart/{productId}` (I06, Member 2) — model: `OrderItemModel`:
productId, artisanId, title, unitPrice, quantity, imageUrl, addedAt.

### `artisanProfiles/{artisanUid}` — I05 (manage: Member 4, public view: Member 1) — model: `ArtisanProfileModel`
| Field | Type | Notes |
|---|---|---|
| artisanUid, displayName, craftType, about, location | string | Matches hi-fi edit form |
| photoUrl | string \| null | |
| verified | bool | **Admin only** (FR4). Artisan cannot change it. |
| createdAt, updatedAt | timestamp | |
Ratings are **calculated from `reviews`** when displayed — never stored.

### `products/{productId}` — I11 writes (Member 3 / authorised supporter), I02–I04 read (Member 1) — model: `ProductModel`
| Field | Type |
|---|---|
| productId, artisanId, artisanName, title, description, category, materials, originDistrict | string |
| price | number (LKR) |
| stockQuantity | int |
| isAvailable | bool |
| imageUrls | list of string |
| createdAt, updatedAt | timestamp |
| updatedBy | uid of last editor (shows if a supporter made the change) |

### `orders/{orderId}` — I07/I08 (Member 2), I12 (Member 3) — model: `OrderModel`
**One order per artisan** (a cart with two artisans becomes two orders).
| Field | Type | Notes |
|---|---|---|
| orderId, buyerId, buyerName, artisanId, artisanName | string | |
| items | list of {productId, artisanId, title, unitPrice, quantity, imageUrl} | Prices copied at order time |
| subtotal, deliveryFee, total | number | deliveryFee = 0 unless the team agrees a charge |
| deliveryAddress | {recipientName, phone, addressLine, city, district} | |
| paymentMethod | `"cash_on_delivery"` \| `"bank_transfer"` | See `PaymentMethods` |
| paymentStatus | `"pending"` \| `"paid"` | |
| status | `pending` \| `confirmed` \| `preparing` \| `shipped` \| `delivered` \| `cancelled` | Decision D5 |
| statusHistory | list of {status, at, byUid} | Drives I08 progress |
| deliveryNote, cancelReason | string \| null | |
| createdAt, updatedAt | timestamp | |
| updatedBy | uid | |

### `conversations/{conversationId}` + `messages/{messageId}` — I09 (buyer: Member 2, artisan: Member 3)
Model: `ConversationModel`, `ChatMessageModel`. Every conversation is tied to an
**order** or a **product** — never a generic messenger.
- ID: the orderId (order chat) or `{productId}_{buyerId}` (product question).
- Conversation: conversationId, type (`"order"` \| `"product_query"`), orderId, productId, buyerId, artisanId, lastMessage, lastMessageAt, createdAt.
- Message: messageId, senderId, senderName, senderContext (`"buyer"` \| `"artisan"` \| `"supporter"`), text, type (`"text"` \| `"prompt"`), sentAt.

### `reviews/{orderId}_{productId}` — FR4 (create: Member 2, display: Member 1) — model: `ReviewModel`
orderId, productId, artisanId, buyerId, buyerName, rating (1–5), comment, createdAt.
Only the buyer of a **delivered** order may create one (enforced in rules v2).

### `supportGrants/{artisanUid}_{supporterUid}` — I13 (Member 4; checked by Member 3's screens) — model: `SupportGrantModel`
artisanId, artisanName, supporterId, supporterName, relationship, phone,
scopes {products, orders, communication}, status (`"active"` \| `"revoked"`), grantedAt, updatedAt.

### `supportInvites/{code}` — I13 (Member 4) — model: `SupportInviteModel`
code, artisanId, artisanName, inviteeName, relationship, phone, scopes,
status (`pending` \| `accepted` \| `revoked` \| `expired`), createdAt, expiresAt, acceptedBy.

### `admins/{uid}`
Created **only in the Firebase console**. Lets an admin set `artisanProfiles.verified`.

## Removed from the original scaffold (do not use)
`users.role`, `users.isFamilyAssisted`, `users.bio`, `users.district`, top-level `carts`,
`chats`, `categories`, `family_permissions`, ISO date strings.

## Security rules
Enforced in `firestore.rules`. Current version: **v1.1** — `users`, `users/{uid}/cart`,
`artisanProfiles` and `admins` are final; `products`, `orders`, `conversations`, `reviews`
are TEMPORARY (signed-in only) and must be replaced (v2) before functional testing.
