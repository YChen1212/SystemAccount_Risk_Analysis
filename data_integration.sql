-- ===========================================
-- 建立資料庫
-- ===========================================
CREATE DATABASE IF NOT EXISTS user_erp_dt;
USE user_erp_dt;

-- ===========================================
-- 1. 建立「人事清單」
-- ===========================================
CREATE TABLE `人事清單` (
  `user_id` VARCHAR(5) PRIMARY KEY,    -- 員工代號，主鍵
  `user_name` VARCHAR(8),              -- 員工姓名
  `department` VARCHAR(5),             -- 部門代碼
  `job_title` VARCHAR(4),              -- 職稱
  `status` VARCHAR(2),                 -- 員工狀態
  `hire_date` DATE,                    -- 到職日期
  `terminate_date` DATE                -- 離職日期
);

-- ===========================================
-- 2. 建立「ERP帳號清單」
-- ===========================================
CREATE TABLE `erp帳號清單` (
  `user_id` VARCHAR(5) PRIMARY KEY,    -- 員工代號，主鍵，且為外鍵參考人事清單
  `user_name` VARCHAR(8),              -- 使用者名稱
  `user_account` VARCHAR(7) UNIQUE,    -- ERP帳號，唯一，供權限表外鍵參考
  `is_active` VARCHAR(5),              -- 帳號是否啟用（字串：TRUE/FALSE）
  `last_logon_date` DATE,              -- 最後登入日期
  `account_estd` DATE,                 -- 帳號建立日期
  FOREIGN KEY (`user_id`) REFERENCES `人事清單`(`user_id`) ON DELETE CASCADE
    -- 若人事清單刪除該員工，則同步刪除帳號清單資料
);

-- ===========================================
-- 3. 建立「ERP權限清單」
-- ===========================================
CREATE TABLE `erp權限清單` (
  `user_account` VARCHAR(7) PRIMARY KEY,  -- ERP帳號，主鍵且為外鍵
  `permissions` VARCHAR(50),              -- 權限描述
  FOREIGN KEY (`user_account`) REFERENCES `erp帳號清單`(`user_account`)
    -- 權限清單的帳號必須存在於帳號清單中
);

-- ===========================================
-- 4. 建立整合查詢表 ALL，將三張表資料整合在一起，方便分析使用
-- ===========================================

CREATE TABLE `ALL` AS
SELECT 
  a.user_id,                -- erp帳號清單：員工代號
  a.user_name,              -- erp帳號清單：使用者名稱
  a.user_account,           -- erp帳號清單：ERP帳號
  a.is_active,              -- erp帳號清單：帳號啟用狀態 (str)
  a.last_logon_date,        -- erp帳號清單：最後登入日期
  a.account_estd,           -- erp帳號清單：帳號建立日期
  p.permissions,            -- erp權限清單：權限名稱
  h.department,             -- 人事清單：部門
  h.job_title,              -- 人事清單：職稱
  h.status,                 -- 人事清單：員工狀態
  h.hire_date,              -- 人事清單：到職日期
  h.terminate_date          -- 人事清單：離職日期
FROM erp帳號清單 a
JOIN erp權限清單 p ON a.user_account = p.user_account   -- 依帳號 join erp權限清單
JOIN 人事清單 h ON a.user_id = h.user_id                -- 依員工代號 join 人事清單
;