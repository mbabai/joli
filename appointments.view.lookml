- view: appointments
  sql_table_name: transactions
  extends: transactions
  fields:
  
  - dimension: sale_amount
    description: This is the gross sales on this credit card swipe.
    type: number
    sql: ${gross_sales}
    value_format_name: usd

  - dimension_group: created
    description: This is the date of the appointment
    type: time
#     timeframes: [raw,time, date, week, month,quarter,year,day_of_week]
    sql: ${datetime_raw}
  
  - dimension: is_before_today_month
    label: Is Before Today (by Month)
    description: This just splits every month into days that occured before today or after. 
    type: yesno
    sql: ${created_day_of_month} < DAYOFMONTH(CURDATE())
    
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
        
  - dimension: is_first_appointment
    description: This is yes if this is the person's first visit
    type: yesno
    sql: ${appointment_sequence_number} = 1

  - measure: total_revenue
    description: This is sum of all the sales revenue.
    type: sum
    sql: ${sale_amount}
    value_format_name: usd
    drill_fields: detail*

  - measure: count
    description: This is the total number of transactions.
    type: count
    drill_fields: detail*
    
  - measure: count_repeat_appointments
    description: This is the total number appointments that are not first appointments. 
    type: count
    filters: 
      is_first_appointment: no
    drill_fields: detail*
  
  - measure: percent_repeat_appointments
    description: This is the percent ofappointments that are not first appointments. 
    type: number
    sql: 1.0 * ${count_repeat_appointments} / NULLIF(${count},0)
    value_format_name: percent_2



  sets:
    detail:
    - id
    - customer_facts.user_id
    - created_time
    - total_amount
    - description

