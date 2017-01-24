view: transactions {
  derived_table: {
    persist_for: "5 hours"
    sql: SELECT *
        , RANK() OVER (PARTITION BY user_id ORDER BY created_at) AS transaction_sequence_number
       FROM (
            SELECT
              transaction_id as id
              , CAST(FARM_FINGERPRINT(CONCAT(t.card_brand , CAST(t.pan_suffix as STRING))) as STRING) AS user_id
              , TIMESTAMP(CAST(t.datetime as STRING)) as created_at
              , description as service
              , details
              , discounts
              , gross_sales as item_price
              , net_total as sale_amount
              , tip as tip_amount
              , location
              , tax
              , fees
              , timezone
              , staff_name
            FROM `melodic-bearing-149516.joli.square_transactions_raw` AS t
            ) a
       ;;
  }
#DIMENSIONS
  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    view_label: "Customer"
    description: "This is a random number based on the credit card used to identify a person."
    sql: ${TABLE}.user_id ;;
    type: string
    html: Customer Lookup;;
    link: {
      label: "Customer Lookup Dashboard"
      url: "/dashboards/2?User ID={{ value }}"
    }
  }

  dimension_group: created {
    description: "This is the date of the transaction"
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: is_weekend {
    description: "Did this transaction occur on a weekend (Saturday, Sunday)."
    group_label: "Transaction Details"
    type: yesno
    sql: ${created_day_of_week}  IN ('Saturday', 'Sunday') ;;
  }

  dimension: is_first_transaction {
    description: "This is yes if this is the person's first visit"
    group_label: "Transaction Details"
    type: yesno
    sql: ${transaction_sequence_number} = 1 ;;
  }

  dimension: service {
    label: "Service (details)"
    description: "Description of the service paid for."
    sql: ${TABLE}.service ;;
  }
  dimension: service_category {
    label: "Service (category)"
    description: "Category of the service paid for."
    drill_fields: [service]
    type: string
    case: {
      when: {
        sql: ${service} like '%Approachable Perfection%' ;;
        label: "Approachable Perfection"
      }
      when: {
        sql: ${service}  like '%Unlimited%' OR ${service} like '%Month%' ;;
        label: "Package"
      }
      when: {
        sql: ${service} like '%Blowout%' ;;
        label: "Blowout"
      }
      when: {
        sql: ${service} like '%The Perfect Set%' ;;
        label: "The Perfect Set"
      }
      when: {
        sql: ${service} like '%Classic Coif%' ;;
        label: "Classic Coif"
      }
      when: {
        sql: ${service} like '%Bridal Trial%' ;;
        label: "Bridal Trial"
      }
      when: {
        sql: ${service} like '%Halloween%' ;;
        label: "Halloween Makeup"
      }
      when: {
        sql: ${service} like '%Braid%' or ${service} like '%Updo%' ;;
        label: "Updo/Braid"
      }
      when: {
        sql: ${service} like '%Only Have Eyes For You%' ;;
        label: "Only Have Eyes For You"
      }
      when: {
        sql: ${service} like '%Lash%' ;;
        label: "Lashes"
      }
      when: {
        sql: ${service} like '%Keratin%' ;;
        label: "Keratin"
      }
      when: {
        sql: ${service} like '%Brow%' ;;
        label: "Brows"
      }
      when: {
        sql: ${service} like '%Touchup%' ;;
        label: "Touchup"
      }
      when: {
        sql: ${service} like '%Cut%' ;;
        label: "Hair cut"
      }
      when: {
        sql: ${service} like '%Zsuzs%' or ${service} like '%Zshoosh%' ;;
        label: "The Zsuzs"
      }
      when: {
        sql: ${service} like '%Custom Amount%' ;;
        label: "Custom Amount"
      }

      else: "Product"
    }
  }

  dimension: details {
    type: string
    sql: ${TABLE}.details ;;
  }

  dimension: discounts {
    group_label: "Transaction Revenue"
    type: number
    description: "Discounts that were applied to the transaction."
    value_format_name: usd
    sql: ${TABLE}.discounts ;;
  }

  dimension: item_price {
    group_label: "Transaction Revenue"
    description: "This is the price of the item before any discounts."
    value_format_name: usd
    type: number
    sql: ${TABLE}.item_price ;;
  }

  dimension: fees {
    group_label: "Transaction Revenue"
    description: "Additional fees taken off of item price."
    value_format_name: usd
    type: number
    sql: ${TABLE}.fees ;;
  }

  dimension: sale_amount {
    group_label: "Transaction Revenue"
    description: "This is the gross sales on this credit card swipe."
    value_format_name: usd
    type: number
    sql: ${TABLE}.sale_amount ;;
  }

  dimension: tip_amount {
    group_label: "Transaction Revenue"
    description: "How much tip was given (on the card) for this service."
    value_format_name: usd
    type: number
    sql: ${TABLE}.tip_amount ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: tax {
    group_label: "Transaction Revenue"
    value_format_name: usd
    description: "This was the tax on the purchase."
    type: number
    sql: ${TABLE}.tax ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: staff_name {
    type: string
    sql: ${TABLE}.staff_name ;;
  }

  dimension: transaction_sequence_number {
    description: "This is what number transaction this was for this customer."
    group_label: "Transaction Details"
    type: number
    sql: ${TABLE}.transaction_sequence_number ;;
  }
  dimension: is_before_today_month {
    group_label: "Transaction Details"
    label: "Is Before Today (by Month)"
    description: "This just splits every month into days that occured before today or after."
    type: yesno
    sql: ${created_day_of_month} <= EXTRACT(DAY FROM CURRENT_DATE()) ;;
  }

#MEASURES
  measure: count {
    description: "This is the total number of transactions."
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    description: "This is sum of all the sales revenue."
    type: sum
    sql: ${sale_amount} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: count_repeat_transactions {
    description: "This is the total number transactions that are not first appointments."
    type: count
    filters: {
      field: is_first_transaction
      value: "no"
    }
    drill_fields: [detail*]
  }
  measure: percent_repeat_transactions {
    description: "This is the percent ofappointments that are not first appointments."
    type: number
    sql: 1.0 * ${count_repeat_transactions} / NULLIF(${count},0) ;;
    value_format_name: percent_2
  }
  measure: total_tips {
    description: "The total tip on the services."
    type: sum
    sql: ${tip_amount} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }
  measure: average_tips {
    description: "The average tip on the services."
    type: average
    sql: ${tip_amount} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }
  measure: tip_percentage {
    description: "The percent tip on the services."
    type: number
    sql: 1.0 * ${total_tips} / NULLIF(${total_revenue},0) ;;
    value_format_name: percent_2
  }
  measure: average_revenue {
    type: average
    description: "Average revenue per transaction."
    sql: ${sale_amount} ;;
    value_format_name: usd
  }
  set: detail {
    fields: [
      id,
      staff_name,
      user_id,
      created_time,
      service,
      total_revenue,
      total_tips,
      tip_percentage
    ]
  }
}
