SELECT display_name, array_agg(park) as parks, count(*) as total_features from 
(SELECT user_id, tags->'nps:unit_code' as park FROM nodes WHERE
tags->'nps:unit_code' IN ('badl','iatr','lecl','noco','ozar','slbe','losa','chyo','mnrr','cuva','fosc','fila','libo','miss','nico','heho','rira','apis','wicl','jaga','pipe','fous','pevi','gwca','voya','grpo','buff','brvb','pull','piro','sacn','hosp','indu','gero','niob','daav','liho','knri','home','wiho','chsc','mimi','agfo','ulsg','fosm','jeca','kewe','hocu','jeff','efmo','fols','tapr','hstr','isro','arpo','scbl','thro','wica','wicr','moru','chro','dabe','peri')
UNION
SELECT user_id, tags->'nps:unit_code' as park from ways WHERE 
tags->'nps:unit_code' IN ('badl','iatr','lecl','noco','ozar','slbe','losa','chyo','mnrr','cuva','fosc','fila','libo','miss','nico','heho','rira','apis','wicl','jaga','pipe','fous','pevi','gwca','voya','grpo','buff','brvb','pull','piro','sacn','hosp','indu','gero','niob','daav','liho','knri','home','wiho','chsc','mimi','agfo','ulsg','fosm','jeca','kewe','hocu','jeff','efmo','fols','tapr','hstr','isro','arpo','scbl','thro','wica','wicr','moru','chro','dabe','peri')
UNION
SELECT user_id, tags->'nps:unit_code' as park from relations WHERE
tags->'nps:unit_code' IN ('badl','iatr','lecl','noco','ozar','slbe','losa','chyo','mnrr','cuva','fosc','fila','libo','miss','nico','heho','rira','apis','wicl','jaga','pipe','fous','pevi','gwca','voya','grpo','buff','brvb','pull','piro','sacn','hosp','indu','gero','niob','daav','liho','knri','home','wiho','chsc','mimi','agfo','ulsg','fosm','jeca','kewe','hocu','jeff','efmo','fols','tapr','hstr','isro','arpo','scbl','thro','wica','wicr','moru','chro','dabe','peri')
) mwr_editors JOIN api_users on user_id = id
group by display_name order by total_features desc, display_name;
