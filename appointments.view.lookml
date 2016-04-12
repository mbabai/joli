- view: appointments
  sql_table_name: transactions
  extends: transactions
  fields:
  
  - dimension: amount
    type: number
    sql: ${gross_sales}

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month,quarter,year,day_of_week]
    sql: ${datetime_raw}
    
  - dimension: user_id
    hidden: true
    sql: md5(CONCAT(${card_brand} , ${pan_suffix}))
    
  - dimension: staff_name
    type: string
    sql: ${TABLE}.`Staff Name`    
    
  - measure: total_amount
    type: sum
    sql: ${amount}
    value_format_name: usd

  - measure: count
    type: count
    drill_fields: detail*
    
    

  sets:
    detail:
    - id
    - created_time
    - total_amount

