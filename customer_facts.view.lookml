
- view: customer_facts
  derived_table:
    sql: |
      SELECT 
        md5(CONCAT((appointments.`Card Brand`) , (appointments.`PAN Suffix`))) AS user_id
        , COUNT(*) AS lifetime_visits
        , COALESCE(SUM((appointments.`Gross Sales`)),0) AS lifetime_value
        , MIN(appointments.Datetime) AS first_visit
        , MAX(appointments.Datetime) AS last_visit
      
      FROM transactions AS appointments
      GROUP BY 1
      

  fields:
  - dimension: user_id
    primary_key: true
    type: string
    sql: ${TABLE}.user_id

  - dimension: lifetime_visits
    type: number
    sql: ${TABLE}.lifetime_visits

  - dimension: lifetime_value
    type: number
    sql: ${TABLE}.lifetime_value
    value_format_name: usd

  - dimension_group: first_visit
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.first_visit

  - dimension_group: last_visit
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.last_visit
    
  - dimension: days_as_customer
    type: number
    sql: datediff(${last_visit_raw}, ${first_visit_raw})
  
  - dimension: is_active
    type: yesno
    sql:  datediff(CURDATE(), ${last_visit_raw}) < 30
    
  - dimension: returned
    type: yesno
    sql: ${lifetime_visits} > 1
    
  - measure: count
    type: count
    drill_fields: detail*
    
  - measure: count_active_customers
    type: count
    filters:
      is_active: yes
    drill_fields: detail*
      
  - measure: average_lifetime_value
    type: average
    sql: ${lifetime_value}
    drill_fields: detail*
    value_format_name: usd
    
  - measure: average_lifetime_visits
    type: average
    sql: ${lifetime_visits}
    drill_fields: detail*
    value_format_name: decimal_2
    
  - measure: count_repeat_customers
    type: count
    filters:
      returned: yes
      
  - measure: total_repeat_customer_value
    type: sum
    sql: ${lifetime_value}
    value_format_name: usd
    filters:
      returned: yes
    
  - measure: average_repeat_customer_value
    type: average
    sql: ${lifetime_value}
    value_format_name: usd
    filters:
      returned: yes  

  sets:
    detail:
      - name
      - lifetime_visits
      - lifetime_value
      - first_visit_time
      - last_visit_time

