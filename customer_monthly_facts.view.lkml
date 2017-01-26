view: month_user_cartesian_blast {
  derived_table: {
    sql: SELECT a.user_id as user_id
          , b.visit_month as visit_month
          , b.last_month as last_month
        FROM
          (SELECT DISTINCT t.user_id AS user_id
          FROM ${transactions.SQL_TABLE_NAME} t
        ) a
        INNER JOIN
          (SELECT DISTINCT CAST(FORMAT_TIMESTAMP('%Y-%m-01', t.created_at ) as TIMESTAMP) AS visit_month
          , CAST(DATE_ADD(CAST(FORMAT_DATE('%Y-%m-01', DATE(t.created_at)) as DATE), INTERVAL -1 MONTH) as TIMESTAMP) as last_month
          FROM ${transactions.SQL_TABLE_NAME} t
        ) b ON 1=1
        ORDER BY 2, 1
        ;;
  }
}



view: customer_monthly_facts {
  derived_table: {
    sql: SELECT mucb.visit_month as visit_month
          , mucb.last_month as last_month
          , mucb.user_id as user_id
          , COALESCE(month_visits,0) as month_visits
          , COALESCE(month_value,0) as month_value
        FROM ${month_user_cartesian_blast.SQL_TABLE_NAME} mucb
        LEFT JOIN (
          SELECT
            CAST(FORMAT_DATE('%Y-%m-01', DATE(a.created_at)) as TIMESTAMP) AS visit_month
            , user_id
            , COUNT(*) AS month_visits
            , COALESCE(SUM(a.item_price),0) AS month_value

          FROM ${transactions.SQL_TABLE_NAME} AS a
          GROUP BY 1,2) facts ON facts.user_id = mucb.user_id AND facts.visit_month = mucb.visit_month
       ;;
#     persist_for: "5 minutes"
    #     sql_trigger_value: SELECT MAX(datetime) from transactions
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: visit {
    type: time
    timeframes: [raw,month]
    sql: ${TABLE}.visit_month ;;
  }

  dimension: is_first_month {
    type: yesno
    sql: ${visit_month} = ${customer_facts.first_visit_month} ;;
  }

  dimension_group: last {
    hidden: yes
    type: time
    timeframes: [month]
    sql: ${TABLE}.last_month ;;
  }

  dimension: prim_key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${user_id},' <> ',${visit_month})
      ;;
  }

  dimension: month_visits {
    description: "The number of visits this person had in this month."
    type: number
    sql: ${TABLE}.month_visits ;;
  }

  dimension: month_value {
    description: "The amount of money this person has spent in this month."
    type: number
    sql: ${TABLE}.month_value ;;
    value_format_name: usd
  }

  dimension:  spent_this_month {
    description: "Did this person spend money this month?"
    type:  yesno
    sql: ${month_value} > 0  ;;
  }

  dimension: spent_last_month {
    description: "Did this person spend money the previous month?"
    type: yesno
    sql: ${customer_last_month.spent_this_month} ;;
  }

  dimension: churn_category {
    case: {
      when: {
        sql: ${customer_last_month.month_value} > ${month_value} ;;
        label: "Positive"
      }

      when: {
        sql: ${customer_last_month.month_value} = ${month_value} ;;
        label: "Neutral"
      }

      when: {
        sql: ${customer_last_month.month_value} < ${month_value} ;;
        label: "Negative"
      }

      when: {
        sql: true ;;
        label: "unknown"
      }
    }
  }

#MEASURES:

  #AVERAGES
  measure: average_month_active_customer_value {
    group_label: "Averages"
    description: "This is the average spend THIS month of active customers who were also active last month."
    type: average
    sql: ${month_value} ;;
    value_format_name: usd
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: is_first_month
      value: "no"
    }
    drill_fields: [detail*]
  }
  measure: average_last_month_active_customer_value {
    group_label: "Averages"
    description: "This is the average spend LAST month of active customers."
    type: average
    sql: ${customer_last_month.month_value} ;;
    value_format_name: usd
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    drill_fields: [detail*]
  }
  measure: average_month_active_customer_visits {
    group_label: "Averages"
    description: "This is the average number of visits THIS month of active customers who were also active in the past."
    type: average
    sql: ${month_visits} ;;
    value_format_name:  decimal_2
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: is_first_month
      value: "no"
    }
    drill_fields: [detail*]
  }
  measure: average_last_month_active_customer_visits {
    group_label: "Averages"
    description: "This is the average number of visits LAST month of active customers."
    type: average
    sql: ${customer_last_month.month_visits} ;;
    value_format_name:  decimal_2
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: is_first_month
      value: "no"
    }
    drill_fields: [detail*]
  }
  #TOTALS
  measure: total_month_active_customer_visits {
    group_label: "Totals"
    description: "This is the total number of visits THIS month of active customers who were also active in the past."
    type: sum
    sql: ${month_visits} ;;
    value_format_name:  decimal_2
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: is_first_month
      value: "no"
    }
    drill_fields: [detail*]
  }
  measure: total_last_month_active_customer_visits {
    group_label: "Totals"
    description: "This is the total number of visits LAST month of active customers."
    type: sum
    sql: ${customer_last_month.month_visits} ;;
    value_format_name:  decimal_2
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: is_first_month
      value: "no"
    }
    drill_fields: [detail*]
  }
  measure: total_month_active_customer_value {
    group_label: "Totals"
    description: "This is the total spend THIS month of active customers who were also active in the past."
    type: sum
    sql: ${month_value} ;;
    value_format_name: usd
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: is_first_month
      value: "no"
    }
    drill_fields: [detail*]
  }

  measure: total_last_month_active_customer_value {
    group_label: "Totals"
    description: "This is the total spend LAST month of active customers."
    type: sum
    sql: ${customer_last_month.month_value} ;;
    value_format_name: usd
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: total_churn {
    group_label: "Totals"
    description: "This is the churn. In short, it is the DECREASE in the amount of money your active repeat customers are spending month to month."
    type: number
    sql: ${total_last_month_active_customer_value} - ${total_month_active_customer_value} ;;
    value_format_name: usd
  }

  measure: total_churn_percentage {
    group_label: "Totals"
    description: "This is the same as total churn, but as a percent of the previous month."
    type: number
    sql: 1.0 * ${total_churn} / NULLIF(${total_last_month_active_customer_value},0) ;;
    value_format_name: percent_2
  }

  measure: count_new_users {
    group_label: "Counts"
    type:  count_distinct
    sql:  ${user_id} ;;
    filters: {field: is_first_month value: "yes"}
  }

  measure: count_spending_users {
    group_label: "Counts"
    type:  count_distinct
    sql:  ${user_id} ;;
    filters: {
      field: spent_this_month
      value: "yes"
    }
    drill_fields: [detail*]
  }
  measure: count_last_month_spending_users {
    group_label: "Counts"
    type: count_distinct
    sql:  ${user_id} ;;
    filters: {
      field: spent_last_month
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: count_repeat_users {
    group_label: "Counts"
    type:  count_distinct
    sql:  ${user_id} ;;
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: spent_this_month
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: count_last_month_repeat_users {
    group_label: "Counts"
    type:  count_distinct
    sql:  ${user_id} ;;
    filters: {
      field: customer_facts.returned
      value: "yes"
    }
    filters: {
      field: spent_last_month
      value: "yes"
    }
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      customer_facts.user_id,
      customer_facts.visit_month,
      customer_facts.month_visits,
      customer_facts.month_value,
      customer_last_month.month_visits,
      customer_last_month.month_value
    ]
  }
}
