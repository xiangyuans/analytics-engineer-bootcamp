Subject: Requesting Your Input to Improve Data Quality & Insights

Hi team!
I’m Xiangyuan, a new member of the Data Team. As part of my onboarding, I’ve been reviewing our **users, brands, and receipts** data to to better understand how we track business performance and identify opportunities to strengthen data quality. During this process, I identified a few areas where we can improve data quality and reliability, such as duplicates, missing values, and inconsistencies.

**My goal:** Ensure our data aligns with business needs and supports accurate reporting. To achieve this, I’d love your input and expertise on how we record data and use this data operationally. Below are key questions to help prioritize fixes and improve our data pipelines:

### Key Questions
1. **Brand Data**
  - Brand Code: How are brand codes assigned? Context: I saw a lot NULL brand code, while the brand name is not null.

  - Top Brands: How do we define a “top brand”? Is it based on sales, manual updates, or another factor?

2. Receipts Process
  - Completion Rules: What details are required to mark a receipt as <FINISHED> or accepted (e.g., must it include item count, total spend)?

  - Brand Tracking: How do we link receipts to brands? Many receipts lack item barcodes/brand codes, making it hard to track sales accurately.

  - Point Eligibility: Are there rules for awarding points on receipt items under certain circumstance? (e.g., Do all items qualify, or only certain ones?)

3. Users Roles
  - Do we track other roles beyond “consumer" (e.g., “fetch-staff” for employees)?

4. Data Usage & Improvements
  - Are there business questions you can’t answer today due to data limitations?
  - How often do you use this data (daily/weekly/monthly)?

### Current data quality issues
To Ensure reliable reporting, I am addressing:
 - **Duplicates** Repeated user records
 - **Missing values** in key fields
    - users table: last login date
    - brands table: brand code and topBrand
    - receipts table:receipt details, including purchased item quantity, price, barcode, and brandcode 
 - **Inconsistent role** in user table.'fetch-staff' in stead of 'consumer'under role 

As our datasets grow (especially receipts), optimizing how we manage this data will improve efficiency and reduce costs. Your insights will ensure these updates align with operational needs.

### Next Steps
Please share your thoughts or suggest a time to discuss further!

Thank you,
Xiangyuan