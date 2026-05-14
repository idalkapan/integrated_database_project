--view sorguları
--sorgu1:İşveren bazında kaç ilan açılmış, ilanlara toplam kaç başvuru gelmiş
SET search_path TO social_pay;

CREATE OR REPLACE VIEW vw_employer_job_application_summary AS
SELECT eo.account_holder_id AS org_id,
       eo.company_name,
       COUNT(DISTINCT j.job_id) AS job_count,
       COUNT(a.app_id) AS total_applications
FROM employer_org eo
LEFT JOIN job_posting j ON j.org_id = eo.account_holder_id
LEFT JOIN application a ON a.job_id = j.job_id
GROUP BY eo.account_holder_id, eo.company_name;

-- sorgu 2:Bireysel kullanıcıların CV’si ne kadar dolu
CREATE OR REPLACE VIEW vw_individual_profile_completeness AS
SELECT iu.account_holder_id AS individual_id,
       iu.first_name,
       iu.last_name,
       COUNT(DISTINCT r.resume_id) AS resume_count,
       COUNT(DISTINCT rs.skill_id) AS skill_count,
       COUNT(DISTINCT p.project_id) AS project_count,
       COUNT(DISTINCT ref.reference_id) AS reference_count
FROM individual_user iu
LEFT JOIN resume r ON r.individual_id = iu.account_holder_id
LEFT JOIN resume_skill rs ON rs.resume_id = r.resume_id
LEFT JOIN project p ON p.resume_id = r.resume_id
LEFT JOIN reference ref ON ref.resume_id = r.resume_id
GROUP BY iu.account_holder_id, iu.first_name, iu.last_name;

--sorgu3:SUCCESS ödemeleri ve varsa invoice’larını tek ekranda görmek
CREATE OR REPLACE VIEW vw_success_payments_with_invoice AS
SELECT p.payment_id,
       p.account_holder_id,
       p.amount,
       p.currency,
       p.paid_at,
       p.method_id,
       i.invoice_id,
       i.invoice_no,
       i.issue_date,
       i.total_amount AS invoice_amount
FROM payment p
LEFT JOIN invoice i ON i.payment_id = p.payment_id
WHERE p.status = 'SUCCESS';

--sorgu4:Kim Hangi planı kullanıyor

CREATE OR REPLACE VIEW vw_subscriptions_with_plan AS
SELECT s.sub_id,
       s.account_holder_id,
       s.status AS subscription_status,
       s.start_date,
       s.end_date,
       sp.plan_id,
       sp.plan_name,
       sp.target_type,
       sp.price,
       sp.currency
FROM subscription s
JOIN subscription_plan sp ON sp.plan_id = s.plan_id;
