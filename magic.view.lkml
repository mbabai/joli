explore: magic {
  persist_for: "0 seconds"
  hidden: yes
}

# ♣ ♦ ♥ ♠
# ETL "in a flash"
# fire -> redshift
# Combustion takes oxygen and any hydrocarbon.
# - Fire creates water and CO2, as the water cools, it condenses into small paticles.
# - What I'm trying to say is that it's cloud based.


view: magic {
  derived_table: {
    sql_trigger_value: SELECT 1 ;;
    indexes: ["selected_card"]
    sql: SELECT 'your card' as selected_card, 'your name' as audience_name
      ;;
  }

  filter: audience_name {}

  dimension: selected_card {
    sql: ${TABLE}.selected_card ;;
    html: <p> 9♥ </p>
      ;;
  }
}
