# SystemAccount_Risk_Analysis

**專案：系統帳號風險分析**
在企業資訊系統中，帳號與權限管理若缺乏嚴謹控管，可能導致資訊安全漏洞與內控缺失。  
本專案以模擬資料為基礎，透過 **Python、SQL、Power BI** 建立一個完整的帳號風險分析流程，模擬 IT 稽核常見場景，並提出改善建議。  

---

### **使用工具**  
  -Python (pandas, Faker)：資料生成與清洗  
  -Excel：人工調整與模擬實務風險情境  
  -MySQL (SQL)：三表合併、條件比對與異常檢測  
  -Power BI：互動式視覺化儀表板  
  -GitHub：版本控管與作品集展示  

---

### **執行步驟**  
1. 資料生成 (Python)  
  ● 使用 Faker 生成 50 筆模擬帳號資料（部門、職稱、權限、狀態、到職/離職日等）。  
  ● 預設資料無風險，後續將透過Excel手動調整欄位，模擬真實異常案例。  

2. 資料調整 (Excel)  
  ● 修改欄位以製造風險情境，例如：離職帳號仍啟用 (狀態 = '離職' & is_active = True)、權限授予超過職務需求等。  
  ● 為模擬稽核常見之實際流程(資訊單位提供系統帳號/權限清單，人資提供人事清單)，故分拆為三張清單：  
     -系統帳號清單(erp帳號清單.xlsx)  
     -帳號權限清單(erp權限清單.xlsx)  
     -人事清單(人事清單.xlsx)  
  
3. 資料整合 (SQL)  
● 匯入 MySQL，建立三張表，並設定外鍵關聯：  
  -- 整合三張表，SQL合併語法如下  
  ```sql  
  create table ALL as  
  select   
    a.user_id,  
    a.user_name,  
    a.user_account,  
    a.is_active,  
    a.last_logon_date,  
    a.account_estd,  
    p.permissions,  
    h.department,  
    h.job_title,  
    h.status,  
    h.hire_date,  
    h.terminate_date  
  from erp帳號清單 a  
  join erp權限清單 p on a.user_account = p.user_account  
  join 人事清單 h on a.user_id = h.user_id;  
  ```  

● 完整語法請見 data_integration.sql。  
  
4. 資料清洗 (Python)  
  ● 權限欄位展開（多權限 → 單列）。  
  ● 預先建立衍生欄位（例：df['offboard_but_active'] = ( df['terminate_date'].notna() & (df['is_active'] == True))  
  ● 匯出清洗後資料集供 Power BI 使用。  
  
5. 視覺化分析 (Power BI)  
  ● 建立互動式報表，呈現四大風險情境：  
    -權限授予不適當：超出職務需求的權限配置  
    -帳號啟用早於到職日：流程控管不足  
    -帳號許久未登入：閒置帳號增加被盜用風險  
    -離職帳號未停用：流程缺口，帳號殘留風險高  
  ● 報表設計：  
    -KPI 卡片：總帳號數、風險帳號數、風險比率  
    -圖表：各風險類型分布、登入天數分析、啟用日 vs 到職日差異  
    -總結頁：風險分級 (高/中)、改善方向  
  
