- view: appointments
  sql_table_name: transactions
  extends: transactions
  fields:
  
  - dimension: sale_amount
    description: This is the gross sales on this credit card swipe.
    type: number
    sql: ${gross_sales}

  - dimension_group: created
    description: This is the date of teh appointment
    type: time
    timeframes: [raw,time, date, week, month,quarter,year,day_of_week]
    sql: ${datetime_raw}
    
  - dimension: user_id
    hidden: true
    sql: md5(CONCAT(${card_brand} , ${pan_suffix}))
    
  - dimension: staff_name
    description: Who gave the service.
    type: string
    sql: ${TABLE}.`Staff Name`   
    
  - dimension: appointment_sequence_number
    description: This is what number appointment this was for this customer.
    type: number
    sql: |
       (
        SELECT COUNT(*)
        FROM transactions t
        WHERE t.Datetime <= ${created_raw}
          AND md5(CONCAT(t.`Card Brand`, t.`PAN Suffix`)) = ${user_id}
        )
    
  - measure: total_revenue
    description: This is sum of all the sales revenue.
    type: sum
    sql: ${sale_amount}
    value_format_name: usd

  - measure: count
    description: This is the total number of transactions.
    type: count
    drill_fields: detail*
    
    

  sets:
    detail:
    - id
    - created_time
    - total_amount

