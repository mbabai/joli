- explore: magic
  persist_for: 0 seconds
  hidden: true
#         ♠ ♡ ♢ ♣  
# ETL "in a flash"
# fire -> redshift
# Combustion takes oxygen and any hydrocarbon. 
# - Fire creates water and CO2, as the water cools, it condenses into small paticles. 
# - What I'm trying to say is that it's cloud based. 


- view: magic
  derived_table:
    sql: |
      SELECT 'your card' as selected_card


  fields:
    - filter: audience_name
    
    - dimension: selected_card_raw
      hidden: true
      sql: ${TABLE}.selected_card



    - measure: selected_card
      type: count
      html: |
        <p> 9♡ </p>
