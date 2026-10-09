# Firestore structure

Agreed on 06 Oct. Don't rename or remove any collection or field below - other members' code depends on them.
If you need something new, add an optional field and tell the group.

Use the models in `lib/core/shared_models/` and the names in `lib/core/constants/firestore_collections.dart`
instead of typing field names by hand.

General rules:
- camelCase names
- dates are Firestore Timestamps (`FirestoreConverters` in `lib/core/utils/`)
- money is a number in LKR
- each document keeps its own id as a field (`productId`, `orderId`, ...)
- a few Dart property names differ from the stored names (e.g. `priceLkr` is stored as `price`) - the model's toMap/fromMap handles it

## Who can do what

There's no role field. Everyone can shop. Someone is an artisan if `artisanProfiles/{uid}` exists,
and a supporter if they have an active grant in `supportGrants`. "Continue as" shows when someone has more than one.

## Collections

**users/{uid}** - account (UserModel)
uid, email, displayName, phone, photoUrl, primaryPurpose (`shop` / `sell`), preferredLanguage (`en` / `si` / `ta`),
defaultDeliveryAddress, createdAt, updatedAt.
Cart: `users/{uid}/cart/{productId}` - productId, artisanId, title, unitPrice, quantity, imageUrl, addedAt.

**artisanProfiles/{uid}** - artisan profile (ArtisanProfileModel)
artisanUid, displayName, craftType, about, location, photoUrl, verified, createdAt, updatedAt.
Optional `coverStyle` (`photo`, `collage`, `clay`, `sunset`, `paddy`, `linen`) - the cover the artisan picked; missing means `photo`. Saved on its own, not by the edit form.
Only an admin can change `verified`. Ratings are worked out from reviews.

**products/{productId}** (ProductModel)
productId, artisanId, artisanName, title, description, category, materials, originDistrict, price,
stockQuantity, isAvailable, imageUrls, createdAt, updatedAt, updatedBy.

**orders/{orderId}** (OrderModel) - one order per artisan
orderId, buyerId, buyerName, artisanId, artisanName, items (productId, artisanId, title, unitPrice, quantity, imageUrl),
subtotal, deliveryFee, total, deliveryAddress (recipientName, phone, addressLine, city, district),
paymentMethod (`cash_on_delivery` / `bank_transfer`), paymentStatus (`pending` / `paid`),
status (`pending`, `confirmed`, `preparing`, `shipped`, `delivered`, `cancelled`), statusHistory (status, at, byUid),
deliveryNote, cancelReason, createdAt, updatedAt, updatedBy.

**conversations/{id}** and **conversations/{id}/messages/{messageId}** (ConversationModel, ChatMessageModel)
Every chat belongs to an order (id = orderId) or a product question (id = productId_buyerId).
Conversation: conversationId, type (`order` / `product_query`), orderId, productId, buyerId, artisanId, lastMessage, lastMessageAt, createdAt.
Message: messageId, senderId, senderName, senderContext (`buyer` / `artisan` / `supporter`), text, type (`text` / `prompt`), sentAt.

**reviews/{orderId}_{productId}** (ReviewModel)
orderId, productId, artisanId, buyerId, buyerName, rating (1-5), comment, createdAt. Only after the order is delivered.

**profilePhotos/{uid}** - small profile photo (I05)
data (base64 text of a ~320px JPEG, max 200,000 characters), updatedAt. Only the owner writes it; anyone signed in reads it.
Kept apart from users and artisanProfiles so nobody else's reads get bigger. `photoUrl` fields are unchanged.

**supportGrants/{artisanUid}_{supporterUid}** (SupportGrantModel)
artisanId, artisanName, supporterId, supporterName, relationship, phone, scopes (products, orders, communication),
status (`active` / `revoked`), grantedAt, updatedAt, inviteCode.

**supportInvites/{code}** (SupportInviteModel)
code, artisanId, artisanName, inviteeName, relationship, phone, scopes, status (`pending` / `accepted` / `revoked` / `expired`),
createdAt, expiresAt, acceptedBy.

**admins/{uid}** - added by hand in the Firebase console only.

## Not used any more
users.role, users.isFamilyAssisted, users.bio, users.district, top-level carts, chats, categories, family_permissions.

## Rules
`firestore.rules` (v2.2). Proper rules for every collection:
- products: anyone signed in reads; the artisan (or a supporter with `products`) adds, edits, deletes; `artisanId` can't change.
- orders: only the buyer, the artisan or a supporter with `orders` reads; only the buyer creates (status `pending`); the artisan side changes status fields only; the buyer can cancel while `pending`; never deleted.
- conversations + messages: only people in that order or product chat (or a supporter with `communication`); messages can't be edited or deleted.
- reviews: anyone signed in reads; only the buyer of a `delivered` order creates one, once.

Checkout saves `artisanId` and `artisanName` on every order. Chat lists can be read with `where('buyerId' == me)` or `where('artisanId' == me)`. Rules are not filters: a list query has to ask only for what the person may read, e.g. orders `where('artisanId', isEqualTo: <acting artisan>)` or `where('buyerId', isEqualTo: <uid>)`. A query without the filter is refused as a whole.
