--Triggers

--1) SUCCES ödeme gelince otomatik fatura oluştur
SET search_path TO social_pay;

CREATE OR REPLACE FUNCTION trg_create_invoice_after_success_payment()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  -- Sadece başarılı ödeme için fatura üret
  IF NEW.status = 'SUCCESS' THEN
    -- Aynı ödeme için daha önce fatura kesilmediyse oluştur
    INSERT INTO invoice (payment_id, invoice_no, issue_date, total_amount, currency)
    SELECT
      NEW.payment_id,
      'INV-' || TO_CHAR(CURRENT_DATE, 'YYYY') || '-' || LPAD(NEW.payment_id::text, 6, '0'),
      CURRENT_DATE,
      NEW.amount,
      NEW.currency
    WHERE NOT EXISTS (
      SELECT 1 FROM invoice i WHERE i.payment_id = NEW.payment_id
    );
  END IF;

  RETURN NEW;
END $$;
SET search_path TO social_pay;

DROP TRIGGER IF EXISTS create_invoice_after_success_payment ON payment;

CREATE TRIGGER create_invoice_after_success_payment
AFTER INSERT ON payment
FOR EACH ROW
EXECUTE FUNCTION trg_create_invoice_after_success_payment();
--Trigger 2: payment kupon eklenmeden önce kuponu doğrula


CREATE OR REPLACE FUNCTION trg_validate_coupon_before_payment_coupon()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_active BOOLEAN;
  v_from   DATE;
  v_to     DATE;
BEGIN
  SELECT c.is_active, c.valid_from, c.valid_to
    INTO v_active, v_from, v_to
  FROM coupon c
  WHERE c.coupon_id = NEW.coupon_id;

  IF v_active IS DISTINCT FROM TRUE THEN
    RAISE EXCEPTION 'Coupon is not active (coupon_id=%)', NEW.coupon_id;
  END IF;

  IF v_from IS NOT NULL AND CURRENT_DATE < v_from THEN
    RAISE EXCEPTION 'Coupon not started yet (coupon_id=%)', NEW.coupon_id;
  END IF;

  IF v_to IS NOT NULL AND CURRENT_DATE > v_to THEN
    RAISE EXCEPTION 'Coupon expired (coupon_id=%)', NEW.coupon_id;
  END IF;

  IF EXISTS (SELECT 1 FROM payment_coupon pc WHERE pc.payment_id = NEW.payment_id) THEN
    RAISE EXCEPTION 'This payment already has a coupon (payment_id=%)', NEW.payment_id;
  END IF;

  RETURN NEW;
END $$;



DROP TRIGGER IF EXISTS validate_coupon_before_payment_coupon ON payment_coupon;

CREATE TRIGGER validate_coupon_before_payment_coupon
BEFORE INSERT ON payment_coupon
FOR EACH ROW
EXECUTE FUNCTION trg_validate_coupon_before_payment_coupon();

-- Trigger 3:taksitlerin hepsi paid=true olunca payment SUCCENT yap


CREATE OR REPLACE FUNCTION trg_payment_success_when_all_installments_paid()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_total INT;
  v_paid  INT;
BEGIN
  IF TG_OP = 'UPDATE' AND (OLD.paid IS DISTINCT FROM TRUE) AND NEW.paid = TRUE THEN

    SELECT COUNT(*) INTO v_total
    FROM payment_installment
    WHERE payment_id = NEW.payment_id;

    SELECT COUNT(*) INTO v_paid
    FROM payment_installment
    WHERE payment_id = NEW.payment_id
      AND paid = TRUE;

    IF v_total > 0 AND v_total = v_paid THEN
      UPDATE payment
      SET status = 'SUCCESS',
          paid_at = COALESCE(paid_at, NOW())
      WHERE payment_id = NEW.payment_id;
    END IF;

  END IF;

  RETURN NEW;
END $$;


DROP TRIGGER IF EXISTS payment_success_when_all_installments_paid ON payment_installment;

CREATE TRIGGER payment_success_when_all_installments_paid
AFTER UPDATE OF paid ON payment_installment
FOR EACH ROW
EXECUTE FUNCTION trg_payment_success_when_all_installments_paid();



--triggers test etme
--triggers test 1:
SET search_path TO social_pay;
SELECT setval(
  pg_get_serial_sequence('payment', 'payment_id'),
  (SELECT COALESCE(MAX(payment_id),0) FROM payment),
  true
);
SELECT setval(
  pg_get_serial_sequence('invoice', 'invoice_id'),
  (SELECT COALESCE(MAX(invoice_id),0) FROM invoice),
  true
);

INSERT INTO payment(account_holder_id, amount, currency, paid_at, status, method_id)
VALUES (1, 350.00, 'TRY', NOW(), 'SUCCESS', 1)
RETURNING payment_id;

SELECT invoice_id, payment_id, invoice_no, issue_date, total_amount, currency
FROM invoice
ORDER BY invoice_id DESC
LIMIT 1;

--triggers 2 test


SELECT setval(
  pg_get_serial_sequence('payment', 'payment_id'),
  (SELECT COALESCE(MAX(payment_id),0) FROM payment),
  true
);
INSERT INTO payment(account_holder_id, amount, currency, paid_at, status, method_id)
VALUES (1, 200.00, 'TRY', NOW(), 'PENDING', 1)
RETURNING payment_id;



SELECT coupon_id, code, is_active, valid_from, valid_to
FROM coupon
WHERE coupon_id = 1;



--Triggers  3 test


SELECT installment_id, payment_id, installment_no, paid
FROM payment_installment
WHERE payment_id = 1
ORDER BY installment_no;


UPDATE payment_installment
SET paid = TRUE,
    paid_at = NOW()
WHERE payment_id = 1;


SELECT payment_id, status, paid_at
FROM payment
WHERE payment_id = 1;


