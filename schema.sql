DROP SCHEMA IF EXISTS social_pay CASCADE;
CREATE SCHEMA social_pay;
SET search_path TO social_pay;

SET search_path TO social_pay;

CREATE TYPE holder_type_enum AS ENUM ('INDIVIDUAL','ORG');
CREATE TYPE sub_status_enum AS ENUM ('ACTIVE','CANCELLED','EXPIRED');
CREATE TYPE payment_status_enum AS ENUM ('PENDING','SUCCESS','CANCELLED','FAILED');
CREATE TYPE application_status_enum AS ENUM ('APPLIED','UNDER_REVIEW','REJECTED','ACCEPTED');
CREATE TYPE friendship_status_enum AS ENUM ('PENDING','ACCEPTED','BLOCKED');
CREATE TYPE discount_type_enum AS ENUM ('PERCENT','FIXED');

SET search_path TO social_pay;

CREATE TABLE account_holder (
  account_holder_id BIGSERIAL PRIMARY KEY,
  holder_type holder_type_enum NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

SET search_path TO social_pay;

CREATE TABLE individual_user (
  account_holder_id BIGINT PRIMARY KEY
    REFERENCES account_holder(account_holder_id) ON DELETE CASCADE,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  birth_date DATE,
  gender     VARCHAR(20)
);

SET search_path TO social_pay;

CREATE TABLE employer_org (
  account_holder_id BIGINT PRIMARY KEY
    REFERENCES account_holder(account_holder_id) ON DELETE CASCADE,
  company_name VARCHAR(120) NOT NULL,
  tax_no       VARCHAR(30) UNIQUE,
  sector       VARCHAR(80),
  size_class   VARCHAR(30)
);

SET search_path TO social_pay;

CREATE TABLE platform (
  platform_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(60) NOT NULL UNIQUE
);

SET search_path TO social_pay;

CREATE TABLE platform_account (
  account_id BIGSERIAL PRIMARY KEY,
  platform_id BIGINT NOT NULL REFERENCES platform(platform_id),
  account_holder_id BIGINT NOT NULL REFERENCES account_holder(account_holder_id),
  username VARCHAR(60) NOT NULL,
  email VARCHAR(120),
  password_hash VARCHAR(200),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  status VARCHAR(20) DEFAULT 'ACTIVE',
  UNIQUE(platform_id, username)
);

SET search_path TO social_pay;

CREATE TABLE resume (
  resume_id BIGSERIAL PRIMARY KEY,
  individual_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  title VARCHAR(120) NOT NULL,
  summary TEXT,
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE education (
  edu_id BIGSERIAL PRIMARY KEY,
  resume_id BIGINT NOT NULL REFERENCES resume(resume_id) ON DELETE CASCADE,
  school VARCHAR(120) NOT NULL,
  degree VARCHAR(120),
  start_date DATE,
  end_date DATE
);

CREATE TABLE experience (
  exp_id BIGSERIAL PRIMARY KEY,
  resume_id BIGINT NOT NULL REFERENCES resume(resume_id) ON DELETE CASCADE,
  company VARCHAR(120) NOT NULL,
  role VARCHAR(120) NOT NULL,
  start_date DATE,
  end_date DATE
);

CREATE TABLE skill (
  skill_id BIGSERIAL PRIMARY KEY,
  skill_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE resume_skill (
  resume_id BIGINT NOT NULL REFERENCES resume(resume_id) ON DELETE CASCADE,
  skill_id  BIGINT NOT NULL REFERENCES skill(skill_id),
  level VARCHAR(30),
  PRIMARY KEY (resume_id, skill_id)
);

SET search_path TO social_pay;

CREATE TABLE job_posting (
  job_id BIGSERIAL PRIMARY KEY,
  org_id BIGINT NOT NULL REFERENCES employer_org(account_holder_id) ON DELETE CASCADE,
  title VARCHAR(140) NOT NULL,
  description TEXT,
  city VARCHAR(60),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE application (
  app_id BIGSERIAL PRIMARY KEY,
  job_id BIGINT NOT NULL REFERENCES job_posting(job_id) ON DELETE CASCADE,
  individual_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  resume_id BIGINT NOT NULL REFERENCES resume(resume_id),
  applied_at TIMESTAMP NOT NULL DEFAULT NOW(),
  status application_status_enum NOT NULL DEFAULT 'APPLIED',
  UNIQUE(job_id, individual_id)
);

CREATE TABLE employer_favorite_list (
  list_id BIGSERIAL PRIMARY KEY,
  org_id BIGINT NOT NULL REFERENCES employer_org(account_holder_id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE employer_favorite_candidate (
  list_id BIGINT NOT NULL REFERENCES employer_favorite_list(list_id) ON DELETE CASCADE,
  individual_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  added_at TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY(list_id, individual_id)
);

SET search_path TO social_pay;

CREATE TABLE post (
  post_id BIGSERIAL PRIMARY KEY,
  individual_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  privacy VARCHAR(20) DEFAULT 'PUBLIC'
);

CREATE TABLE comment (
  comment_id BIGSERIAL PRIMARY KEY,
  post_id BIGINT NOT NULL REFERENCES post(post_id) ON DELETE CASCADE,
  individual_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE reaction_type (
  reaction_type_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE reaction (
  post_id BIGINT NOT NULL REFERENCES post(post_id) ON DELETE CASCADE,
  individual_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  reaction_type_id BIGINT NOT NULL REFERENCES reaction_type(reaction_type_id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY(post_id, individual_id)
);

CREATE TABLE friendship (
  user1_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  user2_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  status friendship_status_enum NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY(user1_id, user2_id),
  CHECK (user1_id <> user2_id)
);

CREATE TABLE follow (
  follower_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  followed_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  started_at TIMESTAMP NOT NULL DEFAULT NOW(),
  stopped_at TIMESTAMP,
  PRIMARY KEY(follower_id, followed_id),
  CHECK (follower_id <> followed_id)
);

CREATE TABLE message (
  msg_id BIGSERIAL PRIMARY KEY,
  sender_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  receiver_id BIGINT NOT NULL REFERENCES individual_user(account_holder_id) ON DELETE CASCADE,
  sent_at TIMESTAMP NOT NULL DEFAULT NOW(),
  body TEXT NOT NULL,
  CHECK (sender_id <> receiver_id)
);

-- Friendship'te user1_id < user2_id olsun diye trigger
CREATE OR REPLACE FUNCTION fn_friendship_order()
RETURNS TRIGGER AS $$
DECLARE tmp BIGINT;
BEGIN
  IF NEW.user1_id > NEW.user2_id THEN
    tmp := NEW.user1_id;
    NEW.user1_id := NEW.user2_id;
    NEW.user2_id := tmp;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_friendship_order ON friendship;
CREATE TRIGGER trg_friendship_order
BEFORE INSERT OR UPDATE ON friendship
FOR EACH ROW
EXECUTE FUNCTION fn_friendship_order();
SET search_path TO social_pay;

CREATE TABLE project (
  project_id BIGSERIAL PRIMARY KEY,
  resume_id BIGINT NOT NULL
    REFERENCES resume(resume_id) ON DELETE CASCADE,
  project_name VARCHAR(150) NOT NULL,
  description TEXT,
  project_url VARCHAR(200),
  start_date DATE,
  end_date DATE
);
SET search_path TO social_pay;

CREATE TABLE reference (
  reference_id BIGSERIAL PRIMARY KEY,
  resume_id BIGINT NOT NULL
    REFERENCES resume(resume_id) ON DELETE CASCADE,
  reference_name VARCHAR(120) NOT NULL,
  reference_title VARCHAR(120),
  company VARCHAR(120),
  contact_email VARCHAR(120),
  contact_phone VARCHAR(30)
);
