SELECT unit_code, /*user_name,*/ count(*) FROM (
  SELECT
    -- current_nodes.changeset_id,
   current_node_tags.v as unit_code,
   display_name as user_name
    -- changeset_tags.v as editor
  FROM
    "current_nodes"
    JOIN "changesets" ON "changesets"."id" = "current_nodes"."changeset_id"
    JOIN "users" ON "users"."id" = "changesets"."user_id"
    JOIN "changeset_tags" ON "changeset_tags"."changeset_id" = "current_nodes"."changeset_id" AND "changeset_tags"."k" = 'created_by'
    JOIN "current_node_tags" ON "current_nodes".id ="current_node_tags".node_id AND current_nodes.version = "current_node_tags".version and "current_node_tags"."k" = 'nps:unit_code'
  WHERE
    current_nodes.timestamp >= to_timestamp('1/7/2015 00:00:00', 'DD/MM/YYYY HH24:MI:SS')::timestamp with time zone AND
    current_nodes.visible = true AND
    changeset_tags.v NOT LIKE 'JOSM/%' AND
    current_node_tags.v IN ('seki','npsa','olym','mcho','seki','laro','seki','klse','yose','rola','pore','tusk','crmo','chis','amme','havo','alca','puho','kala','lach','grba','moja','lake','mora','wapa','cech','depo','hale','goga','jotr','redw','noca','manz','samo','valr','fopo','rori','prsf','lewi','nepe','crla','deva','euon','whmi','lavo','hafo','muwo','safr','hono','para','poch','biho','puhe','cabr','ciro','fova','jomu','miin','joda','kaho','labe','pinn','sajh','whis','ebla','orca') AND
    "users"."display_name" NOT IN ('Nathaniel Irwin', 'Chad Lawlis', 'Jake Coolidge', 'Taylor Long', 'James McAndrew', 'Places Sync Importer')
) as a GROUP BY unit_code/*, user_name*/ ORDER BY unit_code/*, user_name*/;

