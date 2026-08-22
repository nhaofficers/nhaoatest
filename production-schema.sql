-- PostgreSQL foundation for the live AMS. Apply using a managed migration tool.
CREATE TYPE user_role AS ENUM ('SUPER_ADMIN','ADMIN','TREASURER','EDITOR','COMMITTEE','MEMBER');
CREATE TYPE member_status AS ENUM ('PENDING','APPROVED','REJECTED','SUSPENDED');
CREATE TYPE ledger_kind AS ENUM ('REGISTRATION_FEE','MONTHLY_FEE','LATE_FEE','ADJUSTMENT','PAYMENT','REFUND');
CREATE TYPE payment_status AS ENUM ('PENDING','PAID','FAILED','CANCELLED','REFUNDED');
CREATE TABLE users (id uuid PRIMARY KEY, email text UNIQUE NOT NULL, password_hash text NOT NULL, role user_role NOT NULL DEFAULT 'MEMBER', created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE members (id uuid PRIMARY KEY, user_id uuid UNIQUE REFERENCES users(id), member_no text UNIQUE, officer_id text UNIQUE NOT NULL, full_name_bn text NOT NULL, full_name_en text, phone text NOT NULL, office text, status member_status NOT NULL DEFAULT 'PENDING', approved_by uuid REFERENCES users(id), approved_at timestamptz, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE fee_rules (id uuid PRIMARY KEY, code text UNIQUE NOT NULL, title_bn text NOT NULL, amount numeric(12,2) NOT NULL CHECK(amount >= 0), frequency text NOT NULL, active boolean NOT NULL DEFAULT true);
CREATE TABLE ledger_entries (id uuid PRIMARY KEY, member_id uuid NOT NULL REFERENCES members(id), fee_rule_id uuid REFERENCES fee_rules(id), kind ledger_kind NOT NULL, amount numeric(12,2) NOT NULL, due_date date, reference text UNIQUE, note text, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE payments (id uuid PRIMARY KEY, member_id uuid NOT NULL REFERENCES members(id), gateway text NOT NULL, transaction_id text UNIQUE, amount numeric(12,2) NOT NULL CHECK(amount > 0), status payment_status NOT NULL DEFAULT 'PENDING', paid_at timestamptz, raw_callback jsonb, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE notices (id uuid PRIMARY KEY, title_bn text NOT NULL, title_en text, body_bn text NOT NULL, published_at timestamptz, attachment_url text, created_by uuid REFERENCES users(id));
CREATE TABLE audit_logs (id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, actor_id uuid REFERENCES users(id), action text NOT NULL, entity text NOT NULL, entity_id text, metadata jsonb, created_at timestamptz NOT NULL DEFAULT now());
CREATE INDEX ledger_member_due_idx ON ledger_entries(member_id, due_date); CREATE INDEX audit_created_idx ON audit_logs(created_at DESC);
