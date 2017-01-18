view: transactions_raw {
  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.`Transaction ID` ;;
  }

  dimension: card__keyed {
    hidden: yes
    type: number
    sql: ${TABLE}.`Card - Keyed` ;;
  }

  dimension: card__swiped {
    hidden: yes
    type: number
    sql: ${TABLE}.`Card - Swiped` ;;
  }

  dimension: card_brand {
    hidden: yes
    type: string
    sql: ${TABLE}.`Card Brand` ;;
  }

  dimension: cash {
    hidden: yes
    type: number
    sql: ${TABLE}.Cash ;;
  }

  dimension_group: datetime {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    sql: ${TABLE}.Datetime ;;
  }

  dimension: description {
    hidden: yes
    type: string
    sql: ${TABLE}.Description ;;
  }

  dimension: details {
    hidden: yes
    type: string
    sql: ${TABLE}.Details ;;
  }

  dimension: device_name {
    hidden: yes
    type: string
    sql: ${TABLE}.`Device Name` ;;
  }

  dimension: dining_option {
    hidden: yes
    type: string
    sql: ${TABLE}.`Dining Option` ;;
  }

  dimension: discounts {
    hidden: yes
    type: number
    sql: ${TABLE}.Discounts ;;
  }

  dimension: event_type {
    hidden: yes
    type: string
    sql: ${TABLE}.`Event Type` ;;
  }

  dimension: fees {
    hidden: yes
    type: number
    sql: ${TABLE}.Fees ;;
  }

  dimension: gift_card_sales {
    hidden: yes
    type: number
    sql: ${TABLE}.`Gift Card Sales` ;;
  }

  dimension: gross_sales {
    hidden: yes
    type: number
    sql: ${TABLE}.`Gross Sales` ;;
  }

  dimension: location {
    hidden: yes
    type: string
    sql: ${TABLE}.Location ;;
  }

  dimension: net_sales {
    hidden: yes
    type: number
    sql: ${TABLE}.`Net Sales` ;;
  }

  dimension: net_total {
    hidden: yes
    type: number
    sql: ${TABLE}.`Net Total` ;;
  }

  dimension: other_tender {
    hidden: yes
    type: number
    sql: ${TABLE}.`Other Tender` ;;
  }

  dimension: other_tender_note {
    hidden: yes
    type: string
    sql: ${TABLE}.`Other Tender Note` ;;
  }

  dimension: other_tender_type {
    hidden: yes
    type: string
    sql: ${TABLE}.`Other Tender Type` ;;
  }

  dimension: pan_suffix {
    hidden: yes
    type: string
    sql: ${TABLE}.`PAN Suffix` ;;
  }

  dimension: partial_refunds {
    hidden: yes
    type: number
    sql: ${TABLE}.`Partial Refunds` ;;
  }

  dimension: payment_id {
    hidden: yes
    type: string
    sql: ${TABLE}.`Payment ID` ;;
  }

  dimension: square_gift_card {
    hidden: yes
    type: number
    sql: ${TABLE}.`Square Gift Card` ;;
  }

  dimension: staff_id {
    hidden: yes
    type: string
    sql: ${TABLE}.`Staff ID` ;;
  }

  #   - dimension: staff_name
  #     type: string
  #     sql: ${TABLE}.`Staff Name`

  dimension: tax {
    hidden: yes
    type: number
    sql: ${TABLE}.Tax ;;
  }

  dimension: time_zone {
    type: string
    hidden: yes
    sql: ${TABLE}.`Time Zone` ;;
  }

  dimension: tip {
    type: number
    hidden: yes
    sql: ${TABLE}.Tip ;;
  }

  dimension: total_collected {
    type: number
    hidden: yes
    sql: ${TABLE}.`Total Collected` ;;
  }

  dimension: wallet {
    type: number
    hidden: yes
    sql: ${TABLE}.Wallet ;;
  }
}
