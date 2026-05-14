--select örnekleri
SET search_path TO social_pay;

--sorgu1
SELECT first_name, last_name
FROM individual_user;

--sorgu2
SELECT title, city
FROM job_posting
WHERE city = 'İzmir';

--sorgu3
SELECT app_id, job_id, individual_id, status
FROM application
WHERE status = 'UNDER_REVIEW';

--sorgu4
SELECT r.title AS resume_title,
       p.project_name,
       p.start_date,
       p.end_date
FROM project p
JOIN resume r ON r.resume_id = p.resume_id
ORDER BY r.resume_id;


