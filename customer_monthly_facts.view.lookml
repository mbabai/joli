- view: customer_last_month
  extends: customer_monthly_facts





- view: customer_monthly_facts
  derived_table:
    sql: |
      SELECT 
        DATE_FORMAT(appointments.Datetime,'%Y-%m') AS visit_month
        , DATE_FORMAT(appointments.Datetime - INTERVAL 1 MONTH,'%Y-%m') as last_month
        , md5(CONCAT((appointments.`Card Brand`) , (appointments.`PAN Suffix`))) AS user_id
        , COUNT(*) AS month_visits
        , COALESCE(SUM((appointments.`Gross Sales`)),0) AS month_value
      FROM transactions AS appointments
      
      GROUP BY 1,2,3
      ORDER BY 1,2

  fields:
  - dimension: user_id
    hidden: true
    type: string
    sql: ${TABLE}.user_id

  - dimension: visit_month
    type: string
    sql: ${TABLE}.visit_month
    
  - dimension: last_month
    hidden: true
    type: string
    sql: ${TABLE}.last_month
    
  - dimension: prim_key
    hidden: true
    primary_key: true
    sql: |
      CONCAT(${user_id},' <> ',${visit_month})

  - dimension: month_visits
    type: number
    sql: ${TABLE}.month_visits

  - dimension: month_value
    type: number
    sql: ${TABLE}.month_value
    value_format_name: usd
    
  - dimension: churn
    type: number
    sql: ${customer_last_month.month_value} - ${month_value}
    value_format_name: usd
    
  - measure: average_monthly_value
    type: average
    sql: ${month_value}
    value_format_name: usd

  - measure: average_month_visits
    type: average
    sql: ${month_visits}
    
  - measure: total_churn
    type: sum
    sql: ${churn}
    value_format_name: usd
    filters:
      customer_facts.returned: yes
      
  - measure: total_churn_percentage
    type: number
    sql: 1.0 * ${total_churn} / NULLIF(${customer_facts.total_repeat_customer_value},0)
    value_format_name: percent_2
    
  sets:
    detail:
      - name
      - visit_month
      - month_visits
      - month_value

