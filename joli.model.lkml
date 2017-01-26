connection: "joli_bq"
#78bbea #this is the Joli Blue
# include all the views
include: "*.view"
# include all the dashboards
include: "*.dashboard"
explore: transactions {
  label: "Joli Client & Transaction Information"
  persist_for: "0 minutes"

  join: customer_facts {
    view_label: "Customer"
    relationship: many_to_one
    sql_on: ${transactions.user_id} = ${customer_facts.user_id} ;;
  }


}


explore: customer_monthly_facts  {
  label: "Month by Month Customer Information"
  join: customer_last_month {
    from: customer_monthly_facts
    fields: []
    relationship: many_to_one
    sql_on: ${customer_monthly_facts.last_month} =  ${customer_last_month.visit_month}
      AND ${customer_monthly_facts.user_id} = ${customer_last_month.user_id}
       ;;
  }
  join: customer_facts {
    view_label: "Customer all-time facts"
    fields: [returned, rank]
    view_label: "Customer"
    relationship: many_to_one
    sql_on: ${customer_monthly_facts.user_id} = ${customer_facts.user_id} ;;
  }
}
