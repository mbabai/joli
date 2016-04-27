- explore: magic
  persist_for: 0 seconds
  hidden: true
#         ♠
#         ♡
#         ♢
#         ♣  
- view: magic
  derived_table:
    sql: |
      SELECT 'your card' as selected_card


  fields:
  
    - filter: audience_name
      
#     - dimension: selected
#       type: time
#       timeframes: [raw,date]
#       sql: NOW()
    
    - dimension: selected_card_raw
      hidden: true
      sql: ${TABLE}.selected_card



    - measure: selected_card
      type: count
      html: |
        <p> 6♠ </p>
