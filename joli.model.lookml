- connection: marcell_ql
#78bbea #this is the Joli Blue
- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: transactions
  label: Joli Client & Transaction Information
  persist_for: 0 minutes
  joins:
    - join: customer_facts
      view_label: Customer
      relationship: many_to_one
      sql_on: ${transactions.user_id} = ${customer_facts.user_id}
      
    - join: customer_monthly_facts
      view_label: Customer Facts By Month
      relationship: many_to_one
      sql_on: |
        ${transactions.created_month} = ${customer_monthly_facts.visit_month} 
        AND ${transactions.user_id} = ${customer_monthly_facts.user_id}

    - join: customer_last_month
      from: customer_monthly_facts
      fields: []
      relationship: many_to_one
      sql_on: |
        ${customer_monthly_facts.last_month} =  ${customer_last_month.visit_month} 
        AND ${customer_monthly_facts.user_id} = ${customer_last_month.user_id}