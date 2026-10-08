# Purchase notes - Member 2 (feature/buyer-purchase)

Cart (I06), checkout (I07), my orders and tracking (I08) and the buyer side of order chat (I09).

## Changes from the Milestone 02 hi-fi

| # | Screen | Hi-fi | App | Why | Effect |
|---|---|---|---|---|---|
| P1 | I07 Payment | Card and Koko / Mintpay | Cash on delivery and bank transfer | Only these two are in the schema and we have no payment gateway | No card form |
| P2 | I07 Processing / failed | "Securing your payment", "Payment could not be completed", "Retry with another card" | "Placing your order" and "Order could not be placed" (no internet or item sold out), with Try again / Return to cart | No card payment, so a card can't fail | Same screens, different reasons |
| P3 | I07 | One order number for two artisans | One order per artisan, all listed on Order placed | Decision S2, each artisan sees only their own order | Buyer can get two order numbers |
| P4 | I06 / I07 | Rs. 450 delivery | Rs. 450 once per checkout, split between the orders (225 + 225 for two artisans) | Keeps the hi-fi total and each order's total right | Nothing changes on screen |
| P5 | I07 Delivery | Home / Workplace presets, postal code | Name and phone from the account, "Use saved" and "Save as my delivery address", city and district | Schema has one saved address and no postal code | One saved address |
| P6 | Several | SMS sent, 256-bit SSL, "85% goes to the artisan", route verified, courier ID, LankaPay, online status | Left out | The app doesn't do these | No false claims in testing |
| P7 | I08 | PDF receipt, emailed invoice | "View full order info" opens the Order info tab | No PDF or email service | Same details in the app |
| P8 | I08 | Exact delivery date | 5 - 7 days from the order date | Not in the schema | Shown as a range |
| P9 | I09 Inbox | Unread / Archived | Search only | No read or archive fields | Fewer filters |
| P10 | I09 Chat | Call, attachments, voice, photos | Text and quick questions | Needs extra services, Storage is not enabled | Text only |
| P11 | All | "Craft Checkout" title everywhere | My Cart, Checkout, Order Placed, My Orders, Order #..., Messages | Placeholder title in the hi-fi | Real titles |

## Log

### 08 Oct - cart, checkout, orders and chat
- Cart saved in users/{uid}/cart, so it stays after closing the app. Product details still uses addProduct / quantityFor / totalItemCount.
- Checkout in four steps: Review, Delivery, Payment, Confirm. Buy Now buys only that product, the cart stays the same.
- Placing an order checks stock from the server first (this also fails early offline), then saves one order per artisan in one batch.
- My Orders is the Orders tab (Active / Completed). Order details has Tracking, Order info and Delivery tabs and updates when the artisan changes the status.
- Order chat uses the order id as the chat id, so Member 3's artisan chat reads the same messages. Quick questions are saved as type "prompt".
- Text in English, Sinhala and Tamil (lib/core/localization/purchase_strings.dart).
