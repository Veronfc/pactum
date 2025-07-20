CREATE EXTENSION IF NOT EXISTS pg_trgm;


CREATE TABLE users (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  username varchar(30) NOT NULL UNIQUE,
  password_hash text NOT NULL,
  password_salt bytea NOT NULL,
  full_name varchar(100),
  business_name varchar(200) UNIQUE,
  about text,
  based_in text,
  joined_on timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Searching indices
CREATE INDEX index_users_username_trgm ON users USING GIN (username gin_trgm_ops);
CREATE INDEX index_users_full_name_trgm ON users USING GIN (full_name gin_trgm_ops);
CREATE INDEX index_users_business_name_trgm ON users USING GIN (business_name gin_trgm_ops);
-- WHEN SEARCHING --
-- WHERE username ILIKE '%search%'
--    OR username % 'search'
--------------------

-- Sorting indices
CREATE INDEX index_users_based_in ON users (based_in);
CREATE INDEX index_users_joined_on ON users (joined_on)


CREATE TYPE projectstatus as ENUM (
  'draft',
  'open',
  'in_progress',
  'completed',
  'cancelled'
);

CREATE TABLE projects (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  creator_id uuid REFERENCES users (id) NOT NULL,
  title varchar(200) NOT NULL,
  description text NOT NULL,
  drafted_on timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  opened_on timestamptz,
  starting_amount money,
  status projectstatus DEFAULT 'draft' NOT NULL
);

-- Searching indices
-- CREATE INDEX index_projects_drafted_on ON projects (drafted_on);
-- CREATE INDEX index_projects_starting_amount ON projects (starting_amount);
-- CREATE INDEX index_projects_status ON projects (status);
-- CREATE INDEX index_projects_title_trgm ON projects USING GIN (title gin_trgm_ops);
-- CREATE INDEX index_projects_description_trgm ON projects USING GIN (description gin_trgm_ops);

-- Sorting indices
TODO


CREATE TYPE bidstatus as ENUM (
  'submitted',
  'withdrawn',
  'accepted',
  'rejected'
);

CREATE TABLE bids (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id uuid REFERENCES projects (id) NOT NULL,
  bidder_id uuid REFERENCES users (id) NOT NULL,
  amount money NOT NULL,
  submitted_on timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  status bidstatus DEFAULT 'submitted' NOT NULL
);


CREATE TYPE contractstatus as ENUM (
  'offered',
  'active',
  'delivered',
  'approved',
  'disputed',
  'cancelled'
);

CREATE TABLE contracts (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  contractor_id uuid REFERENCES users (id) NOT NULL,
  project_id uuid REFERENCES projects (id) NOT NULL,
  bid_id uuid REFERENCES bids (id) NOT NULL,
  terms text NOT NULL,
  agreed_value money NOT NULL,
  offered_on timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  accepted_on timestamptz,
  status contractstatus DEFAULT 'offered' NOT NULL
);


CREATE TYPE paymentstatus as ENUM (
  'scheduled',
  'due',
  'processing',
  'completed',
  'failed',
  'refunded'
);

CREATE TABLE payments (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  contract_id uuid REFERENCES contracts (id) NOT NULL,
  amount money NOT NULL,
  due_on timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
  terms text NOT NULL,
  status paymentstatus DEFAULT 'scheduled' NOT NULL
);