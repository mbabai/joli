view: customer_facts {
  derived_table: {
    sql: SELECT *
      , @curRank := @curRank + 1 AS rank
      FROM
        (SELECT
          md5(CONCAT((a.`Card Brand`) , (a.`PAN Suffix`))) AS user_id
          , COUNT(*) AS lifetime_visits
          , COALESCE(SUM((a.`Gross Sales`)),0) AS lifetime_value
          , MIN(a.Datetime) AS first_visit
          , MAX(a.Datetime) AS last_visit
          , MAX(CASE WHEN a.Description like '%Unlimited%' OR a.Description like '%Month%'
            THEN a.DATETIME ELSE NULL END) as most_recent_package_date

        FROM transactions AS a
        GROUP BY 1
        ORDER BY lifetime_value DESC)  a
        , (SELECT @curRank := 0) r
       ;;
  }

  dimension: user_id {
    #X# Invalid LookML inside "dimension": {"label":null}
    description: "This is a random number based on the credit card used to identify a person."
    primary_key: yes
    type: string
    sql: ${TABLE}.user_id ;;
    html: Customer Lookup
      ;;

    link: {
      label: "Customer Lookup Dashboard"
      url: "/dashboards/2?User ID={{ value }}"
    }
  }

  dimension: lifetime_visits {
    description: "This is the number of times this person has visited Joli."
    type: number
    sql: ${TABLE}.lifetime_visits ;;
  }

  dimension: lifetime_value {
    description: "This is the total amount this person spent at Joli."
    type: number
    sql: ${TABLE}.lifetime_value ;;
    value_format_name: usd
  }

  dimension_group: first_visit {
    description: "This is the time of this customer's first visit."
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.first_visit ;;
  }

  dimension_group: last_visit {
    description: "This is the time of this customer's last visit."
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.last_visit ;;
  }

  dimension_group: most_recent_package {
    description: "This is the time of this customer last bought a package."
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.most_recent_package_date ;;
  }

  dimension: days_since_package_purchase {
    description: "How long ago (in days) did this customer buy the last package."
    type: number
    sql: datediff(CURDATE(), ${most_recent_package_raw}) ;;
  }

  dimension: days_remaining_in_package {
    description: "How long (in days) before this customer runs out of their last package."
    type: number
    sql: 30 - ${days_since_package_purchase} ;;
  }

  dimension: has_package {
    description: "Does this customer currently have an active package"
    type: yesno
    sql: ${days_remaining_in_package} > 0 ;;
  }

  dimension: rank {
    #1 is the most valuable customer).
    description: "This is how valuable this customer is as a rank ("
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: days_as_customer {
    description: "This is the number of days between the first and last visit of the customer."
    type: number
    sql: datediff(${last_visit_raw}, ${first_visit_raw}) ;;
  }

  dimension: is_recent {
    description: "Did this person come in within the past 30 days?"
    type: yesno
    sql: datediff(CURDATE(), ${last_visit_raw}) < 30 ;;
  }

  dimension: returned {
    description: "Has this person visited Joli more than once?"
    type: yesno
    sql: ${lifetime_visits} > 1 ;;
  }

  dimension: is_active {
    description: "This person has come more than once AND within the past 30 days"
    type: yesno
    sql: ${is_recent} and ${returned} ;;
  }

  measure: count {
    description: "This is the total number of customers."
    type: count
    drill_fields: [detail*]
  }

  measure: average_days_as_customer {
    type: average
    description: "This is the average number of days these customers have been custoemrs."
    sql: ${days_as_customer} ;;
  }

  measure: count_active_customers {
    description: "This is the total number of customers who have come in the past 30 days"
    type: count

    filters: {
      field: is_active
      value: "yes"
    }

    drill_fields: [detail*]
  }

  measure: count_package_customers {
    description: "This is the total number of customers who have an active package."
    type: count

    filters: {
      field: has_package
      value: "yes"
    }

    drill_fields: [detail*]
  }

  measure: average_lifetime_value {
    description: "This is average that ALL customers have spent at Joli over their lifetime as customers."
    type: average
    sql: ${lifetime_value} ;;
    drill_fields: [detail*]
    value_format_name: usd
  }

  measure: average_repeat_customer_lifetime_value {
    description: "This is average that all customers have spent at Joli over their lifetime as customers."
    type: average
    sql: ${lifetime_value} ;;
    drill_fields: [detail*]
    value_format_name: usd

    filters: {
      field: returned
      value: "yes"
    }
  }

  measure: average_lifetime_visits {
    description: "This is average number of times that ALL customers have visited Joli."
    type: average
    sql: ${lifetime_visits} ;;
    drill_fields: [detail*]
    value_format_name: decimal_2
  }

  measure: average_repeat_customer_lifetime_visits {
    description: "This is average number of times that REPEAT customers have visited Joli."
    type: average
    sql: ${lifetime_visits} ;;
    drill_fields: [detail*]
    value_format_name: decimal_2

    filters: {
      field: returned
      value: "yes"
    }
  }

  measure: count_repeat_customers {
    description: "This is how many customers have come back for a second appointment."
    type: count

    filters: {
      field: returned
      value: "yes"
    }

    drill_fields: [detail*]
  }

  measure: percent_repeat_customer {
    description: "This is the percent of people who have come back for a second appointment."
    type: number
    sql: 1.0 * ${count_repeat_customers} / NULLIF(${count},0) ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [
      user_id,
      rank,
      lifetime_visits,
      lifetime_value,
      first_visit_time,
      last_visit_time
    ]
  }
}
