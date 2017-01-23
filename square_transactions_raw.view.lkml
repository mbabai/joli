view: square_transactions_raw {
  sql_table_name: joli.square_transactions_raw ;;

  dimension: card {
    type: number
    sql: ${TABLE}.card ;;
  }

  dimension: card_brand {
    type: string
    sql: ${TABLE}.card_brand ;;
  }

  dimension: card_entry_methods {
    type: string
    sql: ${TABLE}.card_entry_methods ;;
  }

  dimension: cash {
    type: number
    sql: ${TABLE}.cash ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}.customer_name ;;
  }

  dimension: customer_reference_id {
    type: string
    sql: ${TABLE}.customer_reference_id ;;
  }

  dimension_group: datetime {
    type: time
    timeframes: [raw,time, date, week, month]
    sql: ${TABLE}.datetime ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: details {
    type: string
    sql: ${TABLE}.details ;;
  }

  dimension: device_name {
    type: string
    sql: ${TABLE}.device_name ;;
  }

  dimension: device_nickname {
    type: string
    sql: ${TABLE}.device_nickname ;;
  }

  dimension: dining_option {
    type: string
    sql: ${TABLE}.dining_option ;;
  }

  dimension: discounts {
    type: number
    sql: ${TABLE}.discounts ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: fees {
    type: number
    sql: ${TABLE}.fees ;;
  }

  dimension: gift_card_sales {
    type: number
    sql: ${TABLE}.gift_card_sales ;;
  }

  dimension: gross_sales {
    type: number
    sql: ${TABLE}.gross_sales ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: net_sales {
    type: number
    sql: ${TABLE}.net_sales ;;
  }

  dimension: net_total {
    type: number
    sql: ${TABLE}.net_total ;;
  }

  dimension: other_tender {
    type: number
    sql: ${TABLE}.other_tender ;;
  }

  dimension: other_tender_note {
    type: string
    sql: ${TABLE}.other_tender_note ;;
  }

  dimension: other_tender_type {
    type: string
    sql: ${TABLE}.other_tender_type ;;
  }

  dimension: pan_suffix {
    type: number
    sql: ${TABLE}.pan_suffix ;;
  }

  dimension: partial_refunds {
    type: number
    sql: ${TABLE}.partial_refunds ;;
  }

  dimension: payment_id {
    type: string
    sql: ${TABLE}.payment_id ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: square_gift_card {
    type: number
    sql: ${TABLE}.square_gift_card ;;
  }

  dimension: staff_id {
    type: string
    sql: ${TABLE}.staff_id ;;
  }

  dimension: staff_name {
    type: string
    sql: ${TABLE}.staff_name ;;
  }

  dimension: tax {
    type: number
    sql: ${TABLE}.tax ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: tip {
    type: number
    sql: ${TABLE}.tip ;;
  }

  dimension: total_collected {
    type: number
    sql: ${TABLE}.total_collected ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  measure: count {
    type: count
    drill_fields: [staff_name, device_nickname, device_name, customer_name]
  }
}
