-- WHEN SEARCHING --
-- WHERE username ILIKE '%search%'
--    OR username % 'search'

CREATE EXTENSION IF NOT EXISTS pg_trgm;


CREATE TABLE users (
  id uuid 
    DEFAULT gen_random_uuid() 
    PRIMARY KEY,
  username varchar(30) 
    NOT NULL 
    UNIQUE,
  password_hash text 
    NOT NULL,
  password_salt bytea 
    NOT NULL,
  full_name varchar(100),
  business_name varchar(200) 
    UNIQUE,
  about text,
  based_in text,
  joined_on timestamptz 
    DEFAULT CURRENT_TIMESTAMP 
    NOT NULL
);

-- Searching indices
CREATE INDEX index_users_username_trgm ON users USING GIN (username gin_trgm_ops);
CREATE INDEX index_users_full_name_trgm ON users USING GIN (full_name gin_trgm_ops);
CREATE INDEX index_users_business_name_trgm ON users USING GIN (business_name gin_trgm_ops);

-- Filtering indices
CREATE INDEX index_users_based_in ON users (based_in);

-- Sorting indices
CREATE INDEX index_users_joined_on ON users (joined_on);


-- CREATE TABLE contractor_profiles (
--   user_id uuid REFERENCES users (id) NOT NULL
-- );

-- CREATE TABLE client_profiles (
--   user_id uuid REFERENCES users (id) NOT NULL
-- );


CREATE TYPE projectstatus AS enum (
  'draft',
  'open',
  'in_progress',
  'completed',
  'cancelled'
);

CREATE TABLE projects (
  id uuid 
    DEFAULT gen_random_uuid() 
    PRIMARY KEY,
  creator_id uuid 
    REFERENCES users (id) 
    NOT NULL,
  title varchar(200) 
    NOT NULL,
  description text 
    NOT NULL,
  is_modular boolean 
    DEFAULT FALSE 
    NOT NULL,
  drafted_on timestamptz 
    DEFAULT CURRENT_TIMESTAMP 
    NOT NULL,
  opened_on timestamptz
    CHECK (opened_on >= drafted_on),
  starting_amount numeric(10,2)
    CHECK (starting_amount > 0),
  status projectstatus DEFAULT 'draft' 
    NOT NULL,
  CHECK (status != 'open' OR opened_on IS NOT NULL)
);

-- Join indices
CREATE INDEX index_projects_creator_id ON projects (creator_id);

-- Sorting indices
CREATE INDEX index_projects_drafted_on ON projects (drafted_on);
CREATE INDEX index_projects_opened_on ON projects (opened_on);
CREATE INDEX index_projects_starting_amount ON projects (starting_amount);

-- Filtering indices
CREATE INDEX index_projects_status ON projects (status);

-- Searching indices
CREATE INDEX index_projects_title_trgm ON projects USING GIN (title gin_trgm_ops);
CREATE INDEX index_projects_description_trgm ON projects USING GIN (description gin_trgm_ops);


CREATE TYPE modulestatus AS enum (
  'draft',
  'open',
  'in_progress',
  'completed',
  'cancelled'
);

CREATE TABLE modules (
  id uuid 
    DEFAULT gen_random_uuid() 
    PRIMARY KEY,
  project_id uuid 
    REFERENCES projects (id) 
    NOT NULL,
  title varchar(200) 
    NOT NULL,
  description text 
    NOT NULL,
  starting_amount numeric(10,2)
    CHECK (starting_amount > 0),
  status modulestatus 
    DEFAULT 'draft' 
    NOT NULL,
);

-- Join indices
CREATE INDEX index_modules_project_id ON modules (project_id);

-- Sorting indices
CREATE INDEX index_modules_drafted_on ON modules (drafted_on);
CREATE INDEX index_modules_opened_on ON modules (opened_on);
CREATE INDEX index_modules_starting_amount ON modules (starting_amount);

-- Filtering indices
CREATE INDEX index_modules_status ON modules (status);

-- Searching indices
CREATE INDEX index_modules_title_trgm ON modules USING GIN (title gin_trgm_ops);
CREATE INDEX index_modules_description_trgm ON modules USING GIN (description gin_trgm_ops);


CREATE TYPE bidstatus AS enum (
  'submitted',
  'withdrawn',
  'accepted',
  'rejected'
);

CREATE TABLE bids (
  id uuid 
    DEFAULT gen_random_uuid() 
    PRIMARY KEY,
  bidder_id uuid 
    REFERENCES users (id) 
    NOT NULL,
  project_id uuid 
    REFERENCES projects (id),
  module_id uuid 
    REFERENCES modules (id),
  amount numeric(10,2) 
    NOT NULL 
    CHECK (amount > 0),
  submitted_on timestamptz 
    DEFAULT CURRENT_TIMESTAMP 
    NOT NULL,
  status bidstatus 
    DEFAULT 'submitted' 
    NOT NULL,
  CHECK (
    (project_id IS NOT NULL AND module_id IS NULL) OR
    (module_id IS NOT NULL AND project_id IS NULL)
  )
);

-- Join indices
CREATE INDEX index_bids_project_id ON bids (project_id);
CREATE INDEX index_bids_bidder_id ON bids (bidder_id);

-- Sorting indices
CREATE INDEX index_bids_amount ON bids (amount);
CREATE INDEX index_bids_submitted_on ON bids (submitted_on);

-- Filtering indices
CREATE INDEX index_bids_status ON bids (status);


CREATE TYPE contractstatus AS enum (
  'offered',
  'active',
  'delivered',
  'approved',
  'disputed',
  'cancelled'
);

CREATE TABLE contracts (
  id uuid 
    DEFAULT gen_random_uuid() 
    PRIMARY KEY,
  contractor_id uuid 
    REFERENCES users (id) 
    NOT NULL,
  project_id uuid 
    REFERENCES projects (id) 
    NOT NULL,
  bid_id uuid 
    REFERENCES bids (id) 
    NOT NULL,
  terms text 
    NOT NULL,
  agreed_value numeric(10,2) 
    NOT NULL
    CHECK (agreed_value > 0),
  offered_on timestamptz 
    DEFAULT CURRENT_TIMESTAMP 
    NOT NULL
  accepted_on timestamptz
    CHECK (accepted_on >= offered_on),
  status contractstatus 
    DEFAULT 'offered' 
    NOT NULL,
  CHECK (status != 'active' OR accepted_on IS NOT NULL)
);

-- Join indices
CREATE INDEX index_contracts_contractor_id ON contracts (contractor_id);
CREATE INDEX index_contracts_project_id ON contracts (project_id);
CREATE INDEX index_contracts_bid_id ON contracts (bid_id);

-- Sorting indices
CREATE INDEX index_contracts_agreed_value ON contracts (agreed_value);
CREATE INDEX index_contracts_offered_on ON contracts (offered_on);
CREATE INDEX index_contracts_accepted_on ON contracts (accepted_on);

-- Filtering indices
CREATE INDEX index_contracts_status ON contracts (status);


CREATE TYPE paymentstatus AS enum (
  'scheduled',
  'due',
  'processing',
  'completed',
  'failed',
  'refunded'
);

CREATE TABLE payments (
  id uuid 
    DEFAULT gen_random_uuid() 
    PRIMARY KEY,
  contract_id uuid 
    REFERENCES contracts (id) 
    NOT NULL,
  amount numeric(10,2) 
    NOT NULL
    CHECK (amount > 0),
  due_on timestamptz 
    DEFAULT CURRENT_TIMESTAMP 
    NOT NULL
  terms text 
    NOT NULL,
  status paymentstatus 
    DEFAULT 'scheduled' 
    NOT NULL
);

-- Join indices
CREATE INDEX index_payments_contract_id ON payments (contract_id);

-- Sorting indices
CREATE INDEX index_payments_amount ON payments (amount);
CREATE INDEX index_payments_due_on ON payments (due_on);

-- Filtering indices
CREATE INDEX index_payments_status ON payments (status);