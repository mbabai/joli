view: customer_monthly_facts {
  derived_table: {
    sql: SELECT
        DATE(DATE_FORMAT(a.Datetime, '%Y-%m-01')) AS visit_month
        , DATE(DATE_FORMAT(a.Datetime - INTERVAL 1 MONTH,'%Y-%m-01')) as last_month
        , md5(CONCAT((a.`Card Brand`) , (a.`PAN Suffix`))) AS user_id
        , COUNT(*) AS month_visits
        , COALESCE(SUM((a.`Gross Sales`)),0) AS month_value
      FROM transactions AS a

      GROUP BY 1,2,3
      ORDER BY 1,2
       ;;
    persist_for: "5 minutes"
    #     sql_trigger_value: SELECT MAX(datetime) from transactions
    indexes: ["user_id"]
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: visit {
    type: time
    timeframes: [month]
    sql: ${TABLE}.visit_month ;;
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

  dimension: spent_last_month {
    description: "Did this person spend money the previous month?"
    type: yesno
    sql: ${customer_last_month.month_value} > 0 ;;
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

  #THIS MONTH
  measure: average_month_active_customer_value {
    description: "This is the average spend THIS month of active customers who were also active last month."
    type: average
    sql: ${month_value} ;;
    value_format_name: usd

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

  measure: total_month_active_customer_value {
    description: "This is the total spend THIS month of active customers who were also active last month."
    type: sum
    sql: ${month_value} ;;
    value_format_name: usd

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

  #LAST MONTH
  measure: average_last_month_active_customer_value {
    description: "This is the average spend LAST month of active customers who were also active last month."
    type: average
    sql: ${customer_last_month.month_value} ;;
    value_format_name: usd

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

  measure: total_last_month_active_customer_value {
    description: "This is the total spend LAST month of active customers who were also active last month."
    type: sum
    sql: ${customer_last_month.month_value} ;;
    value_format_name: usd

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

  measure: total_churn {
    description: "This is the churn. In short, it is the DECREASE in the amount of money your active repeat customers are spending month to month."
    type: number
    sql: ${total_last_month_active_customer_value} - ${total_month_active_customer_value} ;;
    value_format_name: usd
  }

  measure: total_churn_percentage {
    description: "This is the same as total churn, but as a percent of the previous month."
    type: number
    sql: 1.0 * ${total_churn} / NULLIF(${total_last_month_active_customer_value},0) ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [
      customer_facts.user_id,
      visit_month,
      month_visits,
      month_value,
      customer_last_month.month_visits,
      customer_last_month.month_value
    ]
  }
}