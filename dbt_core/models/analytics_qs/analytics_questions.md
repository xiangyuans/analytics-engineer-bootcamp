### Power User Definition

A **power user** is any user meeting **at least one** of these engagement criteria:

- **Uses all three query types**  
  Submits requests across WORKFLOW, ASSISTANT, and VAULT categories within a calendar month
- **Maintains high query volume**  
  Submits ≥13 total queries (combined across types) monthly (~3/week average)

---

#### Validation Insights
| Metric                          | Analysis                     | Result          |
|---------------------------------|------------------------------|-----------------|
| **Multi-type adoption**         | `user_types_distribution`    | 21-25% of users |
| **Sustained monthly activity**  | `user_queries_distribution`  | 20% of users    |

> Note: While consistent multi-type usage is less common, the 20% achieving ≥13 monthly queries demonstrates significant engagement.

Users meeting either criterion exhibit substantially higher platform interaction and are classified as power users. For implementation details, see supporting documentation.

### Potential Issues and Data Quality Concerns

#### 1. **Users Table**
- **Missing `firm_id` Attribute**  
  - `firm_id` (primary key in `firms` table) is a core user attribute but absent from users table
  - Forces indirect retrieval from `events` table instead of direct association
  - **Recommendation**: Add `firm_id` column to maintain logical data relationships

#### 2. **Events Table**
- **Non-Intuitive User-Firm Relationship**  
  - Shows one-to-many mapping between `user_id` and `firm_id` (single user linked to multiple firms)
  - Example: `user_id: 633c06694d118c8578aac99bfd96d5a7` appears with multiple `firm_id` values
  - **Concern**: Violates expectation that users belong to a single firm (expected 1:1 relationship)
