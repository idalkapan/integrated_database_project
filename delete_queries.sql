-- delete komutları
SET search_path TO social_pay;
--sorgu 1
--satır kontrolü
SELECT comment_id, post_id, individual_id, content
FROM comment
WHERE comment_id = 10;
--sil
DELETE FROM comment
WHERE comment_id = 10;

--silindi mi kontrol
SELECT comment_id, post_id, individual_id, content
FROM comment
WHERE comment_id = 10;

--sorgu 2
--satır kontrolü
SELECT installment_id, payment_id, installment_no, amount, paid
FROM payment_installment
WHERE payment_id = 1 AND paid = FALSE
ORDER BY installment_no;
--sil
DELETE FROM payment_installment
WHERE payment_id = 1 AND paid = FALSE;

--kontrol
SELECT installment_id, payment_id, installment_no, amount, paid
FROM payment_installment
WHERE payment_id = 1 AND paid = FALSE;







