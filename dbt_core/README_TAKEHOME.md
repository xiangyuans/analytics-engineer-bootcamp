### Key Assumptions

1. **One-to-One User-Firm Relationship**  
   - Each `user_id` corresponds to exactly one `firm_id`  
   - Observed one-to-many relationships are treated as data quality issues

2. **Event Type ≡ Query Type**  
   - The `event_type` field in events table directly maps to query types  
   - This mapping satisfies requirements for usage engagement analysis

3. **Engagement Level Definition**  
   - Defined as monthly submission frequency per query type  
   - Measured by:  
     `(# queries) / (query type) / month`  
   - Used in absence of formal engagement criteria

4. **Static Firm Attributes**  
   - `firm_size` and `arr` values remain unchanged  
   - Retain initial values from firm profile creation at Harvey

## Metrics Interpretation

### User Retention

- **`daily_active_state`**:  
  Tracks daily user activity status with 5 possible states:  
  - `NEW` - First-time active  
  - `Retained` - Consistently active (at least yesterday and today)
  - `Resurrected` - Returned after inactivity  (active today)
  - `Churned` - Stopped activity (not active today)
  - `Stale` - Long-term inactive  (neither yesterday nor today)

- **`weekly_active_state`**:  
  Measures weekly user return patterns with identical 5-state classification:  
  `NEW`, `Retained`, `Resurrected`, `Churned`, `Stale`

---

### Monthly User Engagement

- **`engagement_level`**:  
  Quantifies query submission frequency through Harvey events using 5 tiers:  
  1. `No Engagement`  
  2. `Low Engagement`  
  3. `Average Engagement`  
  4. `Good Engagement`  
  5. `High Engagement`  

---

### Monthly Firm Usage Summary

- **`active_users`**:  
  Count of users with ≥1 query submission during the month
  
- **`total_queries`**:  
  Aggregate query volume submitted by all firm users
  
- **`queries_per_user`**:  
  Average queries per user: `total_queries / firm_size`
  
- **`adoption_rate`**:  
  Percentage of active users: `(active_users / firm_size) × 100%`