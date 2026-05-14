--update örnekleri
SET search_path TO social_pay;

--sorgu1
UPDATE application
SET status = 'UNDER_REVIEW'
WHERE app_id = 1;

-- sorgu 1in güncellenmiş halini görmek için
SELECT app_id, status
FROM application
WHERE app_id = 1;

--sorgu2
UPDATE individual_user
SET last_name = 'Kaplan'
WHERE account_holder_id = 1;

--sorgu2 nin güncellenmiş halini görmek için

SELECT account_holder_id, first_name, last_name
FROM individual_user
WHERE account_holder_id = 1;

--sorgu 3
UPDATE job_posting
SET is_active = FALSE
WHERE job_id = 10;

--sorgu 3 güncel halini görmek için

SELECT job_id, title, city, is_active
FROM job_posting
WHERE job_id = 10;

--sorgu 4
UPDATE payment_installment
SET paid = TRUE,
    paid_at = NOW()
WHERE installment_id = 2;

--sorgu4 güncellendi mi gör

SELECT installment_id,
       payment_id,
       installment_no,
       amount,
       paid,
       paid_at
FROM payment_installment
WHERE installment_id = 2;




