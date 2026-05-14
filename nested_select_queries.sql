--İç İçe select sorguları
SET search_path TO social_pay;

--sorgu 1: premium pro planına abone olan bireyler
SELECT iu.first_name, iu.last_name
FROM individual_user iu
WHERE iu.account_holder_id IN (
  SELECT s.account_holder_id
  FROM subscription s
  WHERE s.plan_id IN (
    SELECT plan_id
    FROM subscription_plan
    WHERE target_type = 'INDIVIDUAL'
      AND plan_name IN ('Premium','Pro')
  )
);

--sorgu 2: Kupon kullanılmış ödemeler
SELECT p.payment_id, p.amount, p.status,
       (SELECT c.code
        FROM coupon c
        JOIN payment_coupon pc ON pc.coupon_id = c.coupon_id
        WHERE pc.payment_id = p.payment_id
        LIMIT 1) AS coupon_code
FROM payment p
ORDER BY p.payment_id;

--sorgu 3: en pahalı abonelik
SELECT plan_id, plan_name, target_type, price, currency
FROM subscription_plan
WHERE price = (
  SELECT MAX(price)
  FROM subscription_plan
);
--sorgu 4: Faturası olmayan başarılı ödemeler
SELECT p.payment_id, p.account_holder_id, p.amount, p.paid_at
FROM payment p
WHERE p.status = 'SUCCESS'
  AND NOT EXISTS (
    SELECT 1
    FROM invoice i
    WHERE i.payment_id = p.payment_id
  );

--sorgu 5: en az 1 referansı olan kullanıcılar
SELECT iu.account_holder_id, iu.first_name, iu.last_name
FROM individual_user iu
WHERE EXISTS (
  SELECT 1
  FROM resume r
  JOIN reference ref ON ref.resume_id = r.resume_id
  WHERE r.individual_id = iu.account_holder_id
);


--sorgu 6: kupon indirimi PERCENT olan ödemeler

SELECT p.payment_id, p.amount
FROM payment p
WHERE p.payment_id IN (
  SELECT pc.payment_id
  FROM payment_coupon pc
  JOIN coupon c ON c.coupon_id = pc.coupon_id
  WHERE c.discount_type = 'PERCENT'
);


