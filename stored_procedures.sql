--Stored  Procedures
--1
SET search_path TO social_pay;

CREATE OR REPLACE PROCEDURE sp_apply_to_job_auto(
  p_individual_id BIGINT,
  p_job_id BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_resume_id BIGINT;
BEGIN
  -- Kullanıcı var mı?
  IF NOT EXISTS (
    SELECT 1 FROM individual_user iu
    WHERE iu.account_holder_id = p_individual_id
  ) THEN
    RAISE EXCEPTION 'Individual user not found: %', p_individual_id;
  END IF;

  -- İlan var mı?
  IF NOT EXISTS (
    SELECT 1 FROM job_posting j
    WHERE j.job_id = p_job_id
  ) THEN
    RAISE EXCEPTION 'Job posting not found: %', p_job_id;
  END IF;

  -- Zaten başvurmuş mu? (Hata vermesin, sessizce çık)
  IF EXISTS (
    SELECT 1
    FROM application a
    WHERE a.individual_id = p_individual_id
      AND a.job_id = p_job_id
  ) THEN
    RAISE NOTICE 'User % already applied to job %. No action taken.', p_individual_id, p_job_id;
    RETURN;
  END IF;

  -- Kullanıcının en güncel CV’sini seç (resume_id NOT NULL ihtiyacını çözer)
  SELECT r.resume_id
  INTO v_resume_id
  FROM resume r
  WHERE r.individual_id = p_individual_id
  ORDER BY r.resume_id DESC
  LIMIT 1;

  IF v_resume_id IS NULL THEN
    RAISE EXCEPTION 'User % has no resume. Create a resume first.', p_individual_id;
  END IF;

  -- Başvuruyu ekle (resume_id artık NULL olmayacak)
  INSERT INTO application(job_id, individual_id, resume_id, applied_at, status)
  VALUES (p_job_id, p_individual_id, v_resume_id, NOW(), 'APPLIED');

  RAISE NOTICE 'Application created: user %, job %, resume %', p_individual_id, p_job_id, v_resume_id;
END $$;

SET search_path TO social_pay;
SELECT setval(
  pg_get_serial_sequence('application', 'app_id'),
  (SELECT COALESCE(MAX(app_id),0) FROM application),
  true
);

DO $$
DECLARE
  v_ind BIGINT;
  v_job BIGINT;
BEGIN
  -- 1 kullanıcı seç
  SELECT iu.account_holder_id
  INTO v_ind
  FROM individual_user iu
  ORDER BY iu.account_holder_id
  LIMIT 1;

  -- O kullanıcının henüz başvurmadığı 1 ilan seç
  SELECT j.job_id
  INTO v_job
  FROM job_posting j
  WHERE NOT EXISTS (
    SELECT 1
    FROM application a
    WHERE a.individual_id = v_ind
      AND a.job_id = j.job_id
  )
  ORDER BY j.job_id
  LIMIT 1;

  IF v_job IS NULL THEN
    RAISE NOTICE 'No available job found that user % has not applied to.', v_ind;
    RETURN;
  END IF;

  CALL sp_apply_to_job_auto(v_ind, v_job);
END $$;

SELECT app_id,
       job_id,
       individual_id,
       resume_id,
       applied_at,
       status
FROM application
WHERE individual_id = 1 AND job_id = 2
ORDER BY app_id DESC;



--Stored Prodecures 2: ödeme oluşturma
SET search_path TO social_pay;


CREATE OR REPLACE PROCEDURE sp_make_payment(
  p_account_holder_id BIGINT,
  p_amount NUMERIC,
  p_currency VARCHAR,
  p_method_id BIGINT,
  p_status payment_status_enum
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO payment(account_holder_id, amount, currency, paid_at, status, method_id)
  VALUES (p_account_holder_id, p_amount, p_currency, NOW(), p_status, p_method_id);

  RAISE NOTICE 'Payment created: account_holder %, amount % % status %',
    p_account_holder_id, p_amount, p_currency, p_status;
END $$;

CALL sp_make_payment(1, 120.00, 'TRY', 1, 'SUCCESS'::payment_status_enum);
SELECT p.payment_id, p.account_holder_id, p.amount, p.status, i.invoice_no
FROM payment p
LEFT JOIN invoice i ON i.payment_id = p.payment_id
ORDER BY p.payment_id DESC
LIMIT 5;

--Stored prodectures 3: Abonelik oluşturma
SET search_path TO social_pay;

CREATE OR REPLACE PROCEDURE sp_activate_subscription_safe(
  p_account_holder_id BIGINT,
  p_plan_id BIGINT,
  p_months INT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_status subscription.status%TYPE;
BEGIN
  -- Enum'a güvenli atama (type adını hiç yazmadan)
  EXECUTE 'SELECT $1::' || pg_typeof(v_status)::text
  INTO v_status
  USING 'ACTIVE';

  INSERT INTO subscription(account_holder_id, plan_id, start_date, end_date, status)
  VALUES (
    p_account_holder_id,
    p_plan_id,
    CURRENT_DATE,
    (CURRENT_DATE + (p_months || ' months')::interval)::date,
    v_status
  );

  RAISE NOTICE 'Subscription created for account_holder %, plan %, months %',
    p_account_holder_id, p_plan_id, p_months;
END $$;

SELECT setval(
  pg_get_serial_sequence('subscription', 'sub_id'),
  (SELECT COALESCE(MAX(sub_id),0) FROM subscription),
  true
);


CALL sp_activate_subscription_safe(1, 1, 1);

SELECT sub_id, account_holder_id, plan_id, start_date, end_date, status
FROM subscription
ORDER BY sub_id DESC
LIMIT 5;

