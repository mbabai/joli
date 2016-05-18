- view: transactions
  sql_table_name: transactions
  extends: transactions_raw
  fields:
  
  - dimension: sale_amount
    description: This is the gross sales on this credit card swipe.
    type: number
    sql: ${gross_sales}
    value_format_name: usd

  - dimension: service
    label: Service (details)
    description: Description of the service paid for.
    sql: ${description}
    
  - dimension: service_category
    label: Service (category)
    description: Category of the service paid for.
    drill_fields: [service]
    type: string
    sql_case:
      'Approachable Perfection': ${service} like '%Approachable Perfection%'
      'Blowout': ${service} like '%Blowout%'
      'The Perfect Set': ${service} like '%The Perfect Set%'
      'Classic Coif': ${service} like '%Classic Coif%'
      'Bridal Trial': ${service} like '%Bridal Trial%'
      'Halloween Makeup': ${service} like '%Halloween%'
      'Four Blowouts Package': ${service} like '%Four Blowouts%'
      'Updo/Braid': ${service} like '%Braid%' or ${service} like '%Updo%'
      'Only Have Eyes For You': ${service} like '%Only Have Eyes For You%'
      'Lashes': ${service} like '%Lash%'
      'Custom Amount': ${service} like '%Custom Amount%'
      'Keratin': ${service} like '%Keratin%'
      'Brows': ${service} like '%Brow%'
      'Touchup': ${service} like '%Touchup%'
      'Hair cut': ${service} like '%Cut%'
      'The Zsuzs': ${service} like '%Zsuzs%' or ${service} like '%Zshoosh%'
      else: 'Product'

  - dimension: tip_amount
    description: How much tip was given (on the card) for this service.
    type: number
    sql: ${tip}
    value_format_name: usd

  - dimension_group: created
    description: This is the date of the appointment
    type: time
#     timeframes: [raw,time, date, week, month,quarter,year,day_of_week]
    sql: ${datetime_raw}
  
  - dimension: is_weekend
    description: Was this appointment on a weekend (Saturday, Sunday).
    type: yesno
    sql: ${created_day_of_week}  IN ('Saturday', 'Sunday')
  
  - dimension: is_before_today_month
    label: Is Before Today (by Month)
    description: This just splits every month into days that occured before today or after. 
    type: yesno
    sql: ${created_day_of_month} <= DAYOFMONTH(CURDATE())
    
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

  - measure: total_tips
    description: The total tip on the services.
    type: sum
    sql: ${tip_amount}
    value_format_name: usd
    drill_fields: detail*

  - measure: average_tips
    description: The average tip on the services.
    type: average
    sql: ${tip_amount}
    value_format_name: usd
    drill_fields: detail*
    
  - measure: tip_percentage
    description: The percent tip on the services.
    type: number
    sql: 1.0 * ${total_tips} / NULLIF(${total_revenue},0)
    value_format_name: percent_2
    
  - measure: average_revenue
    type: average
    description: Average revenue per transaction.
    sql: ${sale_amount}
    value_format_name: usd

  sets:
    detail:
    - id
    - staff_name
    - customer_facts.user_id
    - created_time
    - description
    - total_revenue
    - total_tips
    - tip_percentage

