# NHAOA Association Management System

Responsive bilingual public portal and an interactive demonstration of key member, approval, and payment workflows for **National Housing Authority Officers' Association (nhaoa.org)**.

## Approved fee configuration

- One-time registration fee: **৳2,000**
- Monthly subscription: **৳500**
- Recommended automated schedule: invoice on the 1st of each month; ordinary due date on the 10th. The Treasurer can edit the grace period and late-fee rule from the future Admin Panel.

## Run the demo

Open `index.html` in any modern browser. No dependencies, server, or database are required for the demo UI.

## Production implementation plan

The current UI is the presentation layer. Build the live system with:

1. Next.js / TypeScript frontend and REST API (or NestJS API)
2. PostgreSQL, Prisma migrations, and Redis job queue
3. Object storage for documents, images, challans, and signed receipts
4. RBAC roles: super admin, admin, treasurer, editor, committee member, member
5. SSLCommerz server-side payment callback verification; never store card data
6. Scheduled monthly dues generation, immutable ledger entries, downloadable PDFs
7. SMS/email provider adapters, audit log, daily encrypted backup, monitoring

## Required before go-live

- Final Constitution, committee names/photos, office contact and Google Maps location
- Registration fee, monthly subscription, waiver/late-fee rules, and fiscal-year policy
- SSLCommerz merchant account and sandbox/production credentials
- Domain/DNS, hosting/VPS approval, support email and SMS-provider credentials
- Privacy policy, retention policy, authorized admins, and data migration member list
