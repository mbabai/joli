- view: transactions_raw
  fields:

  - dimension: id
    primary_key: true
    type: string
    sql: ${TABLE}.`Transaction ID`

  - dimension: card__keyed
    hidden: true
    type: number
    sql: ${TABLE}.`Card - Keyed`

  - dimension: card__swiped
    hidden: true
    type: number
    sql: ${TABLE}.`Card - Swiped`

  - dimension: card_brand
    hidden: true
    type: string
    sql: ${TABLE}.`Card Brand`

  - dimension: cash
    hidden: true
    type: number
    sql: ${TABLE}.Cash

  - dimension_group: datetime
    hidden: true
    type: time
    timeframes: [raw,time, date, week, month,quarter,year,day_of_week]
    sql: ${TABLE}.Datetime

  - dimension: description
    hidden: true
    type: string
    sql: ${TABLE}.Description

  - dimension: details
    hidden: true
    type: string
    sql: ${TABLE}.Details

  - dimension: device_name
    hidden: true
    type: string
    sql: ${TABLE}.`Device Name`

  - dimension: dining_option
    hidden: true
    type: string
    sql: ${TABLE}.`Dining Option`

  - dimension: discounts
    hidden: true
    type: number
    sql: ${TABLE}.Discounts

  - dimension: event_type
    hidden: true
    type: string
    sql: ${TABLE}.`Event Type`

  - dimension: fees
    hidden: true
    type: number
    sql: ${TABLE}.Fees

  - dimension: gift_card_sales
    hidden: true
    type: number
    sql: ${TABLE}.`Gift Card Sales`

  - dimension: gross_sales
    hidden: true
    type: number
    sql: ${TABLE}.`Gross Sales`

  - dimension: location
    hidden: true
    type: string
    sql: ${TABLE}.Location

  - dimension: net_sales
    hidden: true
    type: number
    sql: ${TABLE}.`Net Sales`

  - dimension: net_total
    hidden: true
    type: number
    sql: ${TABLE}.`Net Total`

  - dimension: other_tender
    hidden: true
    type: number
    sql: ${TABLE}.`Other Tender`

  - dimension: other_tender_note
    hidden: true
    type: string
    sql: ${TABLE}.`Other Tender Note`

  - dimension: other_tender_type
    hidden: true
    type: string
    sql: ${TABLE}.`Other Tender Type`

  - dimension: pan_suffix
    hidden: true
    type: string
    sql: ${TABLE}.`PAN Suffix`

  - dimension: partial_refunds
    hidden: true
    type: number
    sql: ${TABLE}.`Partial Refunds`

  - dimension: payment_id
    hidden: true
    type: string
    sql: ${TABLE}.`Payment ID`

  - dimension: square_gift_card
    hidden: true
    type: number
    sql: ${TABLE}.`Square Gift Card`

  - dimension: staff_id
    hidden: true
    type: string
    sql: ${TABLE}.`Staff ID`

#   - dimension: staff_name
#     type: string
#     sql: ${TABLE}.`Staff Name`

  - dimension: tax
    hidden: true
    type: number
    hidden: true
    sql: ${TABLE}.Tax

  - dimension: time_zone
    type: string
    hidden: true
    sql: ${TABLE}.`Time Zone`

  - dimension: tip
    type: number
    hidden: true
    sql: ${TABLE}.Tip

  - dimension: total_collected
    type: number
    hidden: true
    sql: ${TABLE}.`Total Collected`

  - dimension: wallet
    type: number
    hidden: true
    sql: ${TABLE}.Wallet

