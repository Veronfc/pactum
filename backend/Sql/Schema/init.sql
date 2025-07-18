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

CREATE TYPE bidstatus as ENUM (
  'submitted',
  'withdrawn',
  'accepted',
  'rejected'
);

CREATE TYPE bids (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id uuid REFERENCES projects (id) NOT NULL,
  bidder_id uuid REFERENCES users (id) NOT NULL,
  amount money NOT NULL,
  status bidstatus DEFAULT 'submitted' NOT NULL
);

CREATE TYPE contractstatus as ENUM (
  TODO
);

CREATE TABLE contracts (
  TODO
);

CREATE TYPE paymentstatus as ENUM (
  TODO
);

CREATE TABLE payments (
  TODO
);