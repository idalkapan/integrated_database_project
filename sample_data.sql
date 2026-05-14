--kod1
SET search_path TO social_pay;

-- Platformlar
INSERT INTO platform(platform_id, name) VALUES
(1,'Facebook'),
(2,'KariyerAkademi');

-- Reaction tipleri
INSERT INTO reaction_type(reaction_type_id, name) VALUES
(1,'Like'),
(2,'Love'),
(3,'Haha'),
(4,'Wow'),
(5,'Sad'),
(6,'Angry'),
(7,'Support'),
(8,'Celebrate'),
(9,'Insightful'),
(10,'Funny');

-- Payment method
INSERT INTO payment_method(method_id, method_name) VALUES
(1,'credit_card'),
(2,'debit_card'),
(3,'transfer'),
(4,'digital_wallet'),
(5,'eft'),
(6,'cash'),
(7,'crypto'),
(8,'mobile_payment'),
(9,'gift_card'),
(10,'other');

-- Subscription plan (birey + şirket)
INSERT INTO subscription_plan(plan_id, plan_name, target_type, price, currency) VALUES
(1,'Basic','INDIVIDUAL',0,'TRY'),
(2,'Premium','INDIVIDUAL',199.90,'TRY'),
(3,'Pro','INDIVIDUAL',299.90,'TRY'),
(4,'Basic','ORG',499.90,'TRY'),
(5,'Premium','ORG',999.90,'TRY'),
(6,'Kurumsal','ORG',1999.90,'TRY'),
(7,'KurumsalPlus','ORG',2999.90,'TRY'),
(8,'Student','INDIVIDUAL',49.90,'TRY'),
(9,'Recruiter','ORG',1499.90,'TRY'),
(10,'CareerBoost','INDIVIDUAL',129.90,'TRY');

-- Installment plan
INSERT INTO installment_plan(installment_plan_id, name, installment_count, interest_rate) VALUES
(1,'Tek Çekim',1,0),
(2,'3 Taksit',3,0),
(3,'6 Taksit',6,2.5),
(4,'9 Taksit',9,4.0),
(5,'12 Taksit',12,6.0),
(6,'2 Taksit',2,0),
(7,'4 Taksit',4,1.0),
(8,'5 Taksit',5,1.5),
(9,'8 Taksit',8,3.0),
(10,'10 Taksit',10,5.0);

--kod2
SET search_path TO social_pay;

-- 10 birey (account_holder_id: 1-10)
INSERT INTO account_holder(account_holder_id, holder_type) VALUES
(1,'INDIVIDUAL'),(2,'INDIVIDUAL'),(3,'INDIVIDUAL'),(4,'INDIVIDUAL'),(5,'INDIVIDUAL'),
(6,'INDIVIDUAL'),(7,'INDIVIDUAL'),(8,'INDIVIDUAL'),(9,'INDIVIDUAL'),(10,'INDIVIDUAL');

INSERT INTO individual_user(account_holder_id, first_name, last_name, birth_date, gender) VALUES
(1,'İdal','Kapan','2002-05-18','F'),
(2,'Ahmet','Yıldız','2001-02-14','M'),
(3,'Elif','Demir','2000-11-03','F'),
(4,'Mert','Kaya','1999-07-21','M'),
(5,'Zeynep','Aydın','2003-09-09','F'),
(6,'Can','Koç','1998-12-30','M'),
(7,'Derya','Şahin','2002-01-10','F'),
(8,'Emre','Çelik','2001-04-06','M'),
(9,'Seda','Arslan','2000-06-25','F'),
(10,'Bora','Öztürk','1999-03-15','M');

-- 10 şirket (account_holder_id: 101-110)
INSERT INTO account_holder(account_holder_id, holder_type) VALUES
(101,'ORG'),(102,'ORG'),(103,'ORG'),(104,'ORG'),(105,'ORG'),
(106,'ORG'),(107,'ORG'),(108,'ORG'),(109,'ORG'),(110,'ORG');

INSERT INTO employer_org(account_holder_id, company_name, tax_no, sector, size_class) VALUES
(101,'EgeSoft A.Ş.','TR-100000001','Software','SME'),
(102,'İzmir DataLab','TR-100000002','Analytics','SME'),
(103,'BakırTech','TR-100000003','Technology','SME'),
(104,'Kordon Finans','TR-100000004','Finance','Enterprise'),
(105,'Mavi Lojistik','TR-100000005','Logistics','SME'),
(106,'Anka Sağlık','TR-100000006','Healthcare','Enterprise'),
(107,'Zeytin Tarım','TR-100000007','Agriculture','SME'),
(108,'Smyrna E-Ticaret','TR-100000008','E-commerce','SME'),
(109,'Gediz Enerji','TR-100000009','Energy','Enterprise'),
(110,'Kültür Eğitim Ltd.','TR-100000010','Education','SME');

--kod3
SET search_path TO social_pay;

INSERT INTO platform_account(account_id, platform_id, account_holder_id, username, email, password_hash, status) VALUES
(1,1,1,'idal.fb','idal@fb.com','hash1','ACTIVE'),
(2,2,1,'idal.ka','idal@ka.com','hash2','ACTIVE'),

(3,1,2,'ahmet.fb','ahmet@fb.com','hash3','ACTIVE'),
(4,2,2,'ahmet.ka','ahmet@ka.com','hash4','ACTIVE'),

(5,1,3,'elif.fb','elif@fb.com','hash5','ACTIVE'),
(6,2,3,'elif.ka','elif@ka.com','hash6','ACTIVE'),

(7,2,4,'mert.ka','mert@ka.com','hash7','ACTIVE'),
(8,1,5,'zeynep.fb','zeynep@fb.com','hash8','ACTIVE'),

(9,2,6,'can.ka','can@ka.com','hash9','ACTIVE'),
(10,1,7,'derya.fb','derya@fb.com','hash10','ACTIVE'),

(11,2,8,'emre.ka','emre@ka.com','hash11','ACTIVE'),
(12,1,9,'seda.fb','seda@fb.com','hash12','ACTIVE'),
(13,2,10,'bora.ka','bora@ka.com','hash13','ACTIVE');

--kod4
SET search_path TO social_pay;

-- 10 CV (her bireye 1)
INSERT INTO resume(resume_id, individual_id, title, summary) VALUES
(1,1,'Computer Engineering CV','AI & DB projects, SmartStockX'),
(2,2,'Backend Developer CV','Java/Spring, PostgreSQL'),
(3,3,'Data Analyst CV','Python, SQL, PowerBI'),
(4,4,'Mobile Developer CV','Flutter, Firebase'),
(5,5,'UI/UX Designer CV','Figma, user research'),
(6,6,'DevOps Engineer CV','Docker, Kubernetes'),
(7,7,'QA Tester CV','Test automation, Selenium'),
(8,8,'ML Engineer CV','NLP, classification'),
(9,9,'Product Manager CV','Agile, roadmap'),
(10,10,'Full Stack CV','React, Node, DB');

-- 10 Education
INSERT INTO education(edu_id, resume_id, school, degree, start_date, end_date) VALUES
(1,1,'İzmir Bakırçay Üniversitesi','BSc Computer Engineering','2022-09-01',NULL),
(2,2,'Ege Üniversitesi','BSc Computer Engineering','2019-09-01','2023-06-30'),
(3,3,'Dokuz Eylül Üniversitesi','BSc Statistics','2018-09-01','2022-06-30'),
(4,4,'Yaşar Üniversitesi','BSc Software Engineering','2019-09-01','2023-06-30'),
(5,5,'İzmir Ekonomi Üniversitesi','BA Visual Design','2020-09-01',NULL),
(6,6,'İTÜ','BSc Computer Engineering','2016-09-01','2020-06-30'),
(7,7,'Katip Çelebi Üniversitesi','BSc Computer Engineering','2017-09-01','2021-06-30'),
(8,8,'Boğaziçi Üniversitesi','BSc Computer Engineering','2019-09-01','2023-06-30'),
(9,9,'ODTÜ','BA Business','2016-09-01','2020-06-30'),
(10,10,'DEÜ','BSc Computer Engineering','2018-09-01','2022-06-30');

-- 10 Experience
INSERT INTO experience(exp_id, resume_id, company, role, start_date, end_date) VALUES
(1,1,'SmartStockX','Intern Developer','2024-06-01','2024-09-01'),
(2,2,'EgeSoft A.Ş.','Backend Developer','2023-07-01',NULL),
(3,3,'İzmir DataLab','Data Analyst','2022-07-01',NULL),
(4,4,'Smyrna E-Ticaret','Mobile Developer','2023-01-01',NULL),
(5,5,'Kültür Eğitim Ltd.','UI/UX Designer','2022-10-01',NULL),
(6,6,'Gediz Enerji','DevOps Engineer','2021-01-01',NULL),
(7,7,'BakırTech','QA Tester','2022-02-01',NULL),
(8,8,'Anka Sağlık','ML Engineer','2023-03-01',NULL),
(9,9,'Kordon Finans','Product Manager','2021-09-01',NULL),
(10,10,'Mavi Lojistik','Full Stack Dev','2022-05-01',NULL);

--kod 5
SET search_path TO social_pay;

INSERT INTO skill(skill_id, skill_name) VALUES
(1,'SQL'),
(2,'PostgreSQL'),
(3,'Python'),
(4,'Java'),
(5,'C#'),
(6,'React'),
(7,'Docker'),
(8,'Kubernetes'),
(9,'Machine Learning'),
(10,'Figma');

-- Her CV’ye en az 1 skill veriyoruz (toplam 20 eşleme yaptım)
INSERT INTO resume_skill(resume_id, skill_id, level) VALUES
(1,1,'Advanced'),(1,3,'Advanced'),(1,9,'Intermediate'),
(2,1,'Advanced'),(2,4,'Advanced'),(2,2,'Advanced'),
(3,1,'Advanced'),(3,3,'Advanced'),
(4,6,'Intermediate'),(4,3,'Intermediate'),
(5,10,'Advanced'),(5,6,'Basic'),
(6,7,'Advanced'),(6,8,'Intermediate'),
(7,3,'Intermediate'),(7,1,'Intermediate'),
(8,9,'Advanced'),(8,3,'Advanced'),
(9,1,'Intermediate'),(10,6,'Advanced');

--kod 6
SET search_path TO social_pay;

-- 10 iş ilanı
INSERT INTO job_posting(job_id, org_id, title, description, city, is_active) VALUES
(1,101,'Backend Developer','Spring + PostgreSQL','İzmir',TRUE),
(2,102,'Data Analyst','SQL + BI','İzmir',TRUE),
(3,103,'QA Engineer','Automation testing','İzmir',TRUE),
(4,104,'Product Manager','Agile, roadmap','İstanbul',TRUE),
(5,105,'Full Stack Dev','React + Node','İzmir',TRUE),
(6,106,'ML Engineer','NLP models','Ankara',TRUE),
(7,107,'Mobile Developer','Flutter','İzmir',TRUE),
(8,108,'UI/UX Designer','Figma + Research','İzmir',TRUE),
(9,109,'DevOps Engineer','K8s, CI/CD','İstanbul',TRUE),
(10,110,'Software Intern','General SWE','İzmir',TRUE);

-- 10 başvuru (farklı kullanıcılar)
INSERT INTO application(app_id, job_id, individual_id, resume_id, status) VALUES
(1,1,1,1,'APPLIED'),
(2,2,3,3,'UNDER_REVIEW'),
(3,3,7,7,'APPLIED'),
(4,4,9,9,'APPLIED'),
(5,5,10,10,'UNDER_REVIEW'),
(6,6,8,8,'APPLIED'),
(7,7,4,4,'APPLIED'),
(8,8,5,5,'APPLIED'),
(9,9,6,6,'UNDER_REVIEW'),
(10,10,2,2,'APPLIED');

-- 10 favori listesi (10 şirket)
INSERT INTO employer_favorite_list(list_id, org_id, name) VALUES
(1,101,'Backend Shortlist'),
(2,102,'Data Shortlist'),
(3,103,'QA Shortlist'),
(4,104,'PM Shortlist'),
(5,105,'FullStack Shortlist'),
(6,106,'ML Shortlist'),
(7,107,'Mobile Shortlist'),
(8,108,'Design Shortlist'),
(9,109,'DevOps Shortlist'),
(10,110,'Intern Shortlist');

-- 10 favori aday ekleme
INSERT INTO employer_favorite_candidate(list_id, individual_id) VALUES
(1,2),(2,3),(3,7),(4,9),(5,10),
(6,8),(7,4),(8,5),(9,6),(10,1);

--kod7
SET search_path TO social_pay;

-- 10 post
INSERT INTO post(post_id, individual_id, content, privacy) VALUES
(1,1,'Bugün SQL çalıştım!','PUBLIC'),
(2,2,'Backend projeme başladım.','PUBLIC'),
(3,3,'Veri analizi notları.','PUBLIC'),
(4,4,'Flutter ile yeni app.','PUBLIC'),
(5,5,'Figma tasarımı paylaştım.','PUBLIC'),
(6,6,'K8s deployment tamam.','PUBLIC'),
(7,7,'Test case yazıyorum.','PUBLIC'),
(8,8,'NLP modeli eğitiyorum.','PUBLIC'),
(9,9,'Sprint planning.','PUBLIC'),
(10,10,'Full stack roadmap.','PUBLIC');

-- 10 comment
INSERT INTO comment(comment_id, post_id, individual_id, content) VALUES
(1,1,2,'Helal!'),
(2,2,1,'Kolay gelsin!'),
(3,3,8,'Güzel analiz!'),
(4,4,5,'UI kısmına bakarım.'),
(5,5,3,'Çok iyi duruyor.'),
(6,6,10,'CI/CD nasıl?'),
(7,7,6,'Selenium mı?'),
(8,8,9,'Harika!'),
(9,9,4,'Toplantıda görüşürüz.'),
(10,10,7,'React kısmı güçlü.');

-- 10 reaction (1 kişi 1 posta 1 reaction)
INSERT INTO reaction(post_id, individual_id, reaction_type_id) VALUES
(1,3,1),
(2,4,2),
(3,5,3),
(4,6,4),
(5,7,1),
(6,8,2),
(7,9,3),
(8,10,4),
(9,1,1),
(10,2,2);

-- 10 friendship (trigger user1<user2 düzeltecek)
INSERT INTO friendship(user1_id, user2_id, status) VALUES
(1,2,'ACCEPTED'),
(1,3,'ACCEPTED'),
(2,4,'PENDING'),
(3,5,'ACCEPTED'),
(4,6,'ACCEPTED'),
(5,7,'PENDING'),
(6,8,'ACCEPTED'),
(7,9,'ACCEPTED'),
(8,10,'PENDING'),
(2,9,'ACCEPTED');

-- 10 follow
INSERT INTO follow(follower_id, followed_id) VALUES
(1,4),
(2,1),
(3,2),
(4,3),
(5,8),
(6,5),
(7,6),
(8,7),
(9,10),
(10,9);

-- 10 message
INSERT INTO message(msg_id, sender_id, receiver_id, body) VALUES
(1,1,2,'KariyerAkademi başvurun nasıl?'),
(2,2,1,'İyi gidiyor, senin?'),
(3,3,8,'NLP için dataset önerin var mı?'),
(4,8,3,'SMS Spam dataset iyi.'),
(5,4,5,'UI için fikir atar mısın?'),
(6,5,4,'Tablı layout kullan.'),
(7,6,10,'Deploy sırasında hata var mı?'),
(8,10,6,'Yok, stabil.'),
(9,7,9,'Test raporunu gönderdim.'),
(10,9,7,'Tamam, teşekkürler.');

--kod 8
SET search_path TO social_pay;

-- 10 coupon
INSERT INTO coupon(coupon_id, code, discount_type, discount_value, valid_from, valid_to, is_active) VALUES
(1,'WELCOME10','PERCENT',10,'2025-01-01','2026-12-31',TRUE),
(2,'STUDENT50','FIXED',50,'2025-01-01','2026-12-31',TRUE),
(3,'NEWYEAR25','PERCENT',25,'2026-01-01','2026-02-01',TRUE),
(4,'HR100','FIXED',100,'2025-06-01','2026-12-31',TRUE),
(5,'PREM20','PERCENT',20,'2025-01-01','2026-12-31',TRUE),
(6,'SAVE30','PERCENT',30,'2025-01-01','2026-12-31',TRUE),
(7,'TRY75','FIXED',75,'2025-01-01','2026-12-31',TRUE),
(8,'ORG150','FIXED',150,'2025-01-01','2026-12-31',TRUE),
(9,'BOOST15','PERCENT',15,'2025-01-01','2026-12-31',TRUE),
(10,'INTERN25','PERCENT',25,'2025-01-01','2026-12-31',TRUE);

-- 10 subscription (5 birey + 5 şirket)
INSERT INTO subscription(sub_id, account_holder_id, plan_id, start_date, end_date, status) VALUES
(1,1,2,'2026-01-01','2026-02-01','ACTIVE'),
(2,2,1,'2026-01-01','2026-02-01','ACTIVE'),
(3,3,3,'2026-01-01','2026-02-01','ACTIVE'),
(4,4,8,'2026-01-01','2026-02-01','ACTIVE'),
(5,5,10,'2026-01-01','2026-02-01','ACTIVE'),
(6,101,4,'2026-01-01','2026-02-01','ACTIVE'),
(7,102,5,'2026-01-01','2026-02-01','ACTIVE'),
(8,103,6,'2026-01-01','2026-02-01','ACTIVE'),
(9,104,9,'2026-01-01','2026-02-01','ACTIVE'),
(10,105,7,'2026-01-01','2026-02-01','ACTIVE');

-- 10 payment (SUCCESS olsun ki fatura üretsin)
INSERT INTO payment(payment_id, account_holder_id, sub_id, amount, currency, paid_at, status, method_id, provider_ref) VALUES
(1,1,1,199.90,'TRY','2026-01-02 10:00','SUCCESS',1,'PRV-001'),
(2,2,2,0.00,'TRY','2026-01-02 10:05','SUCCESS',4,'PRV-002'),
(3,3,3,299.90,'TRY','2026-01-02 10:10','SUCCESS',1,'PRV-003'),
(4,4,4,49.90,'TRY','2026-01-02 10:15','SUCCESS',2,'PRV-004'),
(5,5,5,129.90,'TRY','2026-01-02 10:20','SUCCESS',1,'PRV-005'),
(6,101,6,499.90,'TRY','2026-01-02 10:25','SUCCESS',3,'PRV-006'),
(7,102,7,999.90,'TRY','2026-01-02 10:30','SUCCESS',1,'PRV-007'),
(8,103,8,1999.90,'TRY','2026-01-02 10:35','SUCCESS',1,'PRV-008'),
(9,104,9,1499.90,'TRY','2026-01-02 10:40','SUCCESS',4,'PRV-009'),
(10,105,10,2999.90,'TRY','2026-01-02 10:45','SUCCESS',1,'PRV-010');

-- 10 payment_coupon (her ödemeye bir kupon bağlayalım)
INSERT INTO payment_coupon(payment_id, coupon_id) VALUES
(1,1),(2,2),(3,5),(4,2),(5,9),
(6,8),(7,4),(8,6),(9,4),(10,8);

-- 10 invoice (başarılı ödeme için)
INSERT INTO invoice(invoice_id, payment_id, invoice_no, issue_date, total_amount, currency) VALUES
(1,1,'INV-2026-0001','2026-01-02',199.90,'TRY'),
(2,2,'INV-2026-0002','2026-01-02',0.00,'TRY'),
(3,3,'INV-2026-0003','2026-01-02',299.90,'TRY'),
(4,4,'INV-2026-0004','2026-01-02',49.90,'TRY'),
(5,5,'INV-2026-0005','2026-01-02',129.90,'TRY'),
(6,6,'INV-2026-0006','2026-01-02',499.90,'TRY'),
(7,7,'INV-2026-0007','2026-01-02',999.90,'TRY'),
(8,8,'INV-2026-0008','2026-01-02',1999.90,'TRY'),
(9,9,'INV-2026-0009','2026-01-02',1499.90,'TRY'),
(10,10,'INV-2026-0010','2026-01-02',2999.90,'TRY');

-- 10 payment_installment (örnek: bazı ödemeler taksitli)
-- payment 1 -> 3 taksit, payment 6 -> 2 taksit, payment 8 -> 6 taksit gibi
INSERT INTO payment_installment(installment_id, payment_id, installment_plan_id, installment_no, due_date, amount, paid, paid_at) VALUES
(1,1,2,1,'2026-01-02',66.63,TRUE,'2026-01-02 10:00'),
(2,1,2,2,'2026-02-02',66.63,FALSE,NULL),
(3,1,2,3,'2026-03-02',66.64,FALSE,NULL),

(4,6,6,1,'2026-01-02',249.95,TRUE,'2026-01-02 10:25'),
(5,6,6,2,'2026-02-02',249.95,FALSE,NULL),

(6,8,3,1,'2026-01-02',333.32,TRUE,'2026-01-02 10:35'),
(7,8,3,2,'2026-02-02',333.32,FALSE,NULL),
(8,8,3,3,'2026-03-02',333.32,FALSE,NULL),
(9,8,3,4,'2026-04-02',333.32,FALSE,NULL),
(10,8,3,5,'2026-05-02',333.31,FALSE,NULL);

--kod 9
SET search_path TO social_pay;

INSERT INTO project
(project_id, resume_id, project_name, description, project_url, start_date, end_date)
VALUES
(1,1,'SmartStockX','AI tabanlı stok yönetimi sistemi','https://github.com/idal/smartstockx','2024-02-01',NULL),
(2,2,'Job Portal API','Spring Boot ile iş ilanı servisi','https://github.com/ahmet/job-api','2023-05-01','2023-12-01'),
(3,3,'Sales Dashboard','PowerBI satış analizleri','https://github.com/elif/sales-dashboard','2023-03-01','2023-09-01'),
(4,4,'Flutter Shop App','Mobil e-ticaret uygulaması','https://github.com/mert/flutter-shop','2023-01-01',NULL),
(5,5,'UX Redesign','Kariyer sitesi UX yenileme','https://figma.com/ux-project','2023-06-01','2023-10-01'),
(6,6,'CI/CD Pipeline','Docker + GitHub Actions','https://github.com/can/cicd','2022-11-01',NULL),
(7,7,'Test Automation','Selenium test framework','https://github.com/derya/selenium','2023-02-01',NULL),
(8,8,'Spam Classifier','ML ile spam mail sınıflandırma','https://github.com/emre/spam-ml','2023-04-01',NULL),
(9,9,'Product Roadmap','Agile ürün planlama','https://github.com/seda/roadmap','2022-09-01','2023-06-01'),
(10,10,'Full Stack Blog','React + Node.js blog','https://github.com/bora/blog','2023-01-01',NULL);

--kod 10
SET search_path TO social_pay;

INSERT INTO reference
(reference_id, resume_id, reference_name, reference_title, company, contact_email, contact_phone)
VALUES
(1,1,'Dr. Ali Yılmaz','Akademik Danışman','İzmir Bakırçay Üniversitesi','ali.yilmaz@bakircay.edu.tr','05320000001'),
(2,2,'Mehmet Kara','Backend Lead','EgeSoft A.Ş.','mehmet.kara@egesoft.com','05320000002'),
(3,3,'Ayşe Demir','Data Scientist','İzmir DataLab','ayse.demir@datalab.com','05320000003'),
(4,4,'Onur Şen','Mobile Team Lead','Smyrna E-Ticaret','onur.sen@smyrna.com','05320000004'),
(5,5,'Zeynep Aksoy','UX Manager','Kültür Eğitim Ltd.','z.aksoy@kulturegitim.com','05320000005'),
(6,6,'Hakan Öztürk','DevOps Manager','Gediz Enerji','hakan.ozturk@gediz.com','05320000006'),
(7,7,'Selin Arı','QA Lead','BakırTech','selin.ari@bakirtech.com','05320000007'),
(8,8,'Prof. Cem Aydın','Akademisyen','Boğaziçi Üniversitesi','cem.aydin@boun.edu.tr','05320000008'),
(9,9,'Burcu Kaya','Product Director','Kordon Finans','burcu.kaya@kordon.com','05320000009'),
(10,10,'Serkan Polat','CTO','Mavi Lojistik','serkan.polat@mavilojistik.com','05320000010');

--kontrol kod 11
SET search_path TO social_pay;

SELECT 'platform' AS table_name, COUNT(*) FROM platform
UNION ALL SELECT 'platform_account', COUNT(*) FROM platform_account
UNION ALL SELECT 'account_holder', COUNT(*) FROM account_holder
UNION ALL SELECT 'individual_user', COUNT(*) FROM individual_user
UNION ALL SELECT 'employer_org', COUNT(*) FROM employer_org
UNION ALL SELECT 'resume', COUNT(*) FROM resume
UNION ALL SELECT 'education', COUNT(*) FROM education
UNION ALL SELECT 'experience', COUNT(*) FROM experience
UNION ALL SELECT 'skill', COUNT(*) FROM skill
UNION ALL SELECT 'resume_skill', COUNT(*) FROM resume_skill


UNION ALL SELECT 'project', COUNT(*) FROM project
UNION ALL SELECT 'reference', COUNT(*) FROM reference

UNION ALL SELECT 'job_posting', COUNT(*) FROM job_posting
UNION ALL SELECT 'application', COUNT(*) FROM application
UNION ALL SELECT 'employer_favorite_list', COUNT(*) FROM employer_favorite_list
UNION ALL SELECT 'employer_favorite_candidate', COUNT(*) FROM employer_favorite_candidate
UNION ALL SELECT 'post', COUNT(*) FROM post
UNION ALL SELECT 'comment', COUNT(*) FROM comment
UNION ALL SELECT 'reaction_type', COUNT(*) FROM reaction_type
UNION ALL SELECT 'reaction', COUNT(*) FROM reaction
UNION ALL SELECT 'friendship', COUNT(*) FROM friendship
UNION ALL SELECT 'follow', COUNT(*) FROM follow
UNION ALL SELECT 'message', COUNT(*) FROM message
UNION ALL SELECT 'subscription_plan', COUNT(*) FROM subscription_plan
UNION ALL SELECT 'subscription', COUNT(*) FROM subscription
UNION ALL SELECT 'payment_method', COUNT(*) FROM payment_method
UNION ALL SELECT 'payment', COUNT(*) FROM payment
UNION ALL SELECT 'coupon', COUNT(*) FROM coupon
UNION ALL SELECT 'payment_coupon', COUNT(*) FROM payment_coupon
UNION ALL SELECT 'invoice', COUNT(*) FROM invoice
UNION ALL SELECT 'installment_plan', COUNT(*) FROM installment_plan
UNION ALL SELECT 'payment_installment', COUNT(*) FROM payment_installment
ORDER BY table_name;
