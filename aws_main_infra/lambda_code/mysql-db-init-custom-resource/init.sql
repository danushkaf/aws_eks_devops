CREATE TABLE IF NOT EXISTS `hibernate_sequence` (
  `next_val` bigint(20) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `t_channel_master` (
  `id` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  `channel_code` int(11) NOT NULL,
  `channel_type` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `t_template_master` (
  `id` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  `content` longtext,
  `version` varchar(10) DEFAULT NULL,
  `locale` varchar(20) DEFAULT NULL,
  `parameters` longtext,
  `template_code` varchar(10) NOT NULL,
  `template_name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_egkp7jkpnd2n1yyad77rof63o` (`template_code`)
);

CREATE TABLE IF NOT EXISTS `t_notification_master` (
  `id` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  `notification_code` varchar(20) NOT NULL,
  `notification_desc` varchar(50) DEFAULT NULL,
  `notification_name` varchar(20) NOT NULL,
  `sender_email` varchar(30) DEFAULT NULL,
  `subject` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_8wu89ydpt5vxh4eohoxghelth` (`notification_code`)
);

CREATE TABLE IF NOT EXISTS `t_notification_config_master` (
  `id` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  `attachment_applicable` bit(1) DEFAULT NULL,
  `locale` varchar(20) DEFAULT NULL,
  `channel_id` bigint(20) DEFAULT NULL,
  `notification_id` bigint(20) DEFAULT NULL,
  `template_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKktubsbxauiughubmj9mofgbpl` (`channel_id`),
  KEY `FKacs1q5c3cphlqv4fw78ihco5u` (`notification_id`),
  KEY `FK95vdma3lvvhjlrdsaaqtrvqps` (`template_id`),
  CONSTRAINT `FK95vdma3lvvhjlrdsaaqtrvqps` FOREIGN KEY (`template_id`) REFERENCES `t_template_master` (`id`),
  CONSTRAINT `FKacs1q5c3cphlqv4fw78ihco5u` FOREIGN KEY (`notification_id`) REFERENCES `t_notification_master` (`id`),
  CONSTRAINT `FKktubsbxauiughubmj9mofgbpl` FOREIGN KEY (`channel_id`) REFERENCES `t_channel_master` (`id`)
);

CREATE TABLE IF NOT EXISTS `t_notification_history` (
  `id` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `channel_type` varchar(255) DEFAULT NULL,
  `client_id` varchar(30) DEFAULT NULL,
  `event_params` longtext,
  `notification_code` varchar(20) DEFAULT NULL,
  `template_name` varchar(255) DEFAULT NULL,
  `message_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `t_bounce_back` (
  `id` bigint(20) NOT NULL,
  `creation_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  `client_id` varchar(60) DEFAULT NULL,
  `event_params` longtext,
  `message_id` varchar(60) DEFAULT NULL,
  `notification_code` varchar(20) DEFAULT NULL,
  `notification_type` varchar(20) DEFAULT NULL,
  `reason` longtext,
  `source` varchar(30) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO hibernate_sequence(next_val)
  SELECT 0 FROM dual
  WHERE NOT EXISTS (SELECT next_val FROM hibernate_sequence);

INSERT INTO `t_channel_master`
(`id`, `creation_time`, `updated_time`, `channel_code`, `channel_type`)
VALUES
(1,'2021-01-05 10:10:10','2021-01-05 10:10:10',1,'EMAIL'),
(2,'2021-01-05 10:10:10','2021-01-05 10:10:10',2,'SMS')
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

INSERT INTO `t_template_master`
(`id`, `creation_time`, `updated_time`, `content`,`version`, `locale`, `parameters`, `template_code`, `template_name`)
VALUES
(1001,'2021-01-05 10:10:10','2021-01-05 10:10:10','<!DOCTYPE html>
<html>
<body>
Your code to verify you email address is <span th:text=\"${otp_code}\"></span>.
<br/>
Thank you for choosing GB Bank.
</body>
</html>', 'FINAL', 'en_IN','otp_code','NF-T-01','OTP Verification'),
(1002,'2021-01-05 10:10:10','2021-01-05 10:10:10','<!DOCTYPE html>
<html>
<body>
Your security code is <span th:text=\"${security_code}\"></span>.Please enter the code as instructed on the GB Bank Website.
<br/>
Thank you for choosing GB Bank.
</body>
</html>', 'FINAL', 'en_IN','security_code','NF-T-02','Security Verification'),
(2001,'2021-01-05 10:10:10','2021-01-05 10:10:10','GB Bank: Your code to verify your mobile telephone number is ${otp_code}. Thank you for choosing GB Bank.', 'FINAL', 'en_IN','otp_code','NF-T-03','OTP Verification'),
(2002,'2021-01-05 10:10:10','2021-01-05 10:10:10','GB Bank: Your password has been successfully changed. If you did not request this, please contact us immediately. Thank you for choosing GB Bank.', 'FINAL', 'en_IN','','NF-T-04','Password Change'),
(2003,'2021-01-05 10:10:10','2021-01-05 10:10:10','GB Bank: Your User ID has been changed. If you did not request this change, please contact us immediately. Thank you for choosing GB Bank.', 'FINAL', 'en_IN','','NF-T-05','User ID Change'),
(2004,'2021-01-05 10:10:10','2021-01-05 10:10:10','GB Bank: Your security code is ${security_code}. Please enter the code as instructed on the GB Bank Website. Thank you for choosing GB Bank.', 'FINAL', 'en_IN','security_code','NF-T-06','Security Verification')
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

INSERT INTO `t_notification_master`
(`id`, `creation_time`, `updated_time`, `notification_code`, `notification_desc`, `notification_name`, `sender_email`, `subject`)
VALUES
(1001,'2021-01-05 10:10:10','2021-01-05 10:10:10','DEP-DO-E-1','Email OTP Verification','OTP Verification','jitendra_yadav2@persistent.com','Please verify your email address'),
(1002,'2021-01-05 10:10:10','2021-01-05 10:10:10','DEP-CS-E-1','Security Code Verification','OTP Verification','jitendra_yadav2@persistent.com','GB Bank Security Code'),
(2001,'2021-01-05 10:10:10','2021-01-05 10:10:10','DEP-DO-S-1','Mobile OTP Verification','OTP Verification','','OTP Verification'),
(2002,'2021-01-05 10:10:10','2021-01-05 10:10:10','DEP-CS-S-1', 'Password Change','Password Change','','Password Change'),
(2003,'2021-01-05 10:10:10','2021-01-05 10:10:10','DEP-CS-S-2','User ID Change','User ID Change','','User ID Change'),
(2004,'2021-01-05 10:10:10','2021-01-05 10:10:10','DEP-CS-S-3','Personal Data','Personal Data','','Personal Data')
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

INSERT INTO `t_notification_config_master`
(`id`, `creation_time`, `updated_time`, `attachment_applicable`, `locale`, `channel_id`, `notification_id`, `template_id`)
VALUES
(1001,'2021-01-05 10:10:10','2021-01-05 10:10:10',_binary '\0','en_IN',1,1001,1001),
(1002,'2021-01-05 10:10:10','2021-01-05 10:10:10',_binary '\0','en_IN',1,1002,1002),
(2001,'2021-01-05 10:10:10','2021-01-05 10:10:10',_binary '\0','en_IN',2,2001,2001),
(2002,'2021-01-05 10:10:10','2021-01-05 10:10:10',_binary '\0','en_IN',2,2002,2002),
(2003,'2021-01-05 10:10:10','2021-01-05 10:10:10',_binary '\0','en_IN',2,2003,2003),
(2004,'2021-01-05 10:10:10','2021-01-05 10:10:10',_binary '\0','en_IN',2,2004,2004)
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

INSERT INTO `t_template_master`
(`id`, `creation_time`, `updated_time`, `content`,`version`, `locale`, `parameters`, `template_code`, `template_name`)
VALUES
(1003,'2021-03-10 10:10:10','2021-03-10 10:10:10','<!DOCTYPE html>
<html>
<body>
Payment exception is identified. Kindly refer below details for your action on this exception.
<br/>
<ol>
<li>Transaction ID - <span th:text="${transactionId}"></span></li>
<li>Failure reason � <span th:text="${failureReason}"></span></li>
<li>Debtor bank details
<ul>
<li>Sort Code - <span th:text="${debtorSortCode}"></span></li>
<li>Account Number - <span th:text="${debtorAccountNumber}"></span></li>
</ul>
</li>
<li>Creditor bank details
<ul>
<li>Sort Code - <span th:text="${creditorSortCode}"></span>
<li>Account Number - <span th:text="${creditorAccountNumber}"></span>
</ul>
</li>
<li>Amount - <span th:text="${amount}"></span></li>
<li>Mambu account ID - <span th:text="${cbsAccountId}"></span></li>
</body>
</html>', 'FINAL', 'en_IN','','NF-T-07','Payment Exception Identified')
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

INSERT INTO `t_notification_master`
(`id`, `creation_time`, `updated_time`, `notification_code`, `notification_desc`, `notification_name`, `sender_email`, `subject`)
VALUES
(1003,'2021-03-10 10:10:10','2021-03-10 10:10:10','DEP-PS-E-1','Payment Exception Identified','transactionId,failureReason,debtorSortCode,debtorAccountNumber,creditorSortCode,creditorAccountNumber, amount, cbsAccountId','jitendra_yadav2@persistent.com','Payment Exception Identified')
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

INSERT INTO `t_notification_config_master`
(`id`, `creation_time`, `updated_time`, `attachment_applicable`, `locale`, `channel_id`, `notification_id`, `template_id`)
VALUES
(1003,'2021-03-10 10:10:10','2021-03-10 10:10:10',_binary '\0','en_IN',1,1003,1003)
ON DUPLICATE KEY
        UPDATE id=VALUES(id);

CREATE OR REPLACE VIEW vw_account_details AS SELECT id,
account_number,
client_id,
mambu_account_id,
account_number_display,
sort_code,
virtual_account_id,
creation_time,
updated_time,
remark,
account_type
FROM t_account_details;

CREATE OR REPLACE VIEW vw_notification_history AS SELECT t_notification_history.id,
t_notification_history.creation_time,
t_notification_history.updated_time,
t_notification_history.account_number,
t_notification_history.channel_type,
t_notification_history.client_id,
t_notification_history.event_params,
t_notification_history.notification_code,
t_template_master.template_code,
t_notification_history.template_name
FROM t_notification_history
LEFT JOIN t_template_master ON (template_code=t_template_master.id)
LEFT JOIN t_notification_master ON  (t_notification_history.notification_code=t_notification_master.id);
