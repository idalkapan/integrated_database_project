--JOIN ve Aggregate Function içeren SELECT sorguları 
SET search_path TO social_pay;

--sorgu1: Hangi şirket kaç ilan açmış?
SELECT eo.company_name,
       COUNT(j.job_id) AS job_count
FROM employer_org eo
LEFT JOIN job_posting j
  ON j.org_id = eo.account_holder_id
GROUP BY eo.company_name
ORDER BY job_count DESC;

--sorgu 2: ilan bazında başvuru sayısı
SELECT j.job_id, j.title, j.city,
       COUNT(a.app_id) AS application_count
FROM job_posting j
LEFT JOIN application a
  ON a.job_id = j.job_id
GROUP BY j.job_id, j.title, j.city
ORDER BY application_count DESC;

--sorgu 3: kullanıcı bazında post yorum sayısı
SELECT iu.account_holder_id,
       iu.first_name, iu.last_name,
       COUNT(DISTINCT p.post_id) AS post_count,
       COUNT(DISTINCT c.comment_id) AS comment_count
FROM individual_user iu
LEFT JOIN post p
  ON p.individual_id = iu.account_holder_id
LEFT JOIN comment c
  ON c.individual_id = iu.account_holder_id
GROUP BY iu.account_holder_id, iu.first_name, iu.last_name
ORDER BY post_count DESC, comment_count DESC;

--sorgu 4: ödeme yöntemine göre toplam gelir
SELECT pm.method_name,
       COUNT(p.payment_id) AS payment_count,
       SUM(p.amount) AS total_amount
FROM payment p
JOIN payment_method pm
  ON pm.method_id = p.method_id
WHERE p.status = 'SUCCESS'
GROUP BY pm.method_name
ORDER BY total_amount DESC;

--sorgu 5: abonelik planına göre abone sayısı
SELECT sp.plan_name, sp.target_type,
       COUNT(s.sub_id) AS subscription_count
FROM subscription_plan sp
LEFT JOIN subscription s
  ON s.plan_id = sp.plan_id
GROUP BY sp.plan_name, sp.target_type
ORDER BY subscription_count DESC, sp.target_type;

--sorgu 6: hangi şehirde kaç iş ilanı var
SELECT j.city,
       COUNT(j.job_id) AS job_count
FROM job_posting j
GROUP BY j.city
ORDER BY job_count DESC;

--sorgu 7:her iş ilanı için ortalama başvuru sayısı
SELECT eo.company_name,
       AVG(app_counts.application_count) AS avg_applications
FROM employer_org eo
JOIN job_posting j
  ON j.org_id = eo.account_holder_id
JOIN (
  SELECT job_id, COUNT(*) AS application_count
  FROM application
  GROUP BY job_id
) app_counts
  ON app_counts.job_id = j.job_id
GROUP BY eo.company_name;
--sorgu 8:kullanıcıların sahip olduğu beceri sayısı
SELECT iu.first_name, iu.last_name,
       COUNT(rs.skill_id) AS skill_count
FROM individual_user iu
LEFT JOIN resume r
  ON r.individual_id = iu.account_holder_id
LEFT JOIN resume_skill rs
  ON rs.resume_id = r.resume_id
GROUP BY iu.first_name, iu.last_name
ORDER BY skill_count DESC;

--sorgu9:abonelik planına göre toplam gelir
SELECT sp.plan_name,
       SUM(p.amount) AS total_revenue
FROM subscription_plan sp
JOIN subscription s
  ON s.plan_id = sp.plan_id
JOIN payment p
  ON p.account_holder_id = s.account_holder_id
WHERE p.status = 'SUCCESS'
GROUP BY sp.plan_name
ORDER BY total_revenue DESC;








