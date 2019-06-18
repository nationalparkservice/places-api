SELECT rel_poly.osm_id,
            rel_poly.version,
            rel_poly.tags -> 'name'::text AS name,
            o2p_get_preset(rel_poly.tags, ARRAY['area'::text])::json AS preset,
            o2p_get_name(rel_poly.tags, ARRAY['area'::text], false) AS v1_type,
            rel_poly.tags,
            now()::timestamp without time zone AS created,
            rel_poly.way,
            rel_poly.tags -> 'nps:unit_code'::text AS unit_code
           FROM ( SELECT relation_members.relation_id * (-1) AS osm_id,
                    relations.version,
                    relations.tags,
                    st_buffer(st_transform(st_union(o2p_aggregate_polygon_relation(relation_members.relation_id)), 900913), 0) AS way
                   FROM ways
                     JOIN relation_members ON ways.id = relation_members.member_id
                     JOIN relations ON relation_members.relation_id = relations.id
                  WHERE (( SELECT array_length(array_agg(key.key), 1) AS array_length
                           FROM unnest(akeys(relations.tags)) key(key)
                          WHERE key.key !~~ 'nps:%'::text)) > 0 AND array_length(ways.nodes, 1) >= 4 AND st_isclosed(o2p_calculate_nodes_to_line(ways.nodes)) AND exist(relations.tags, 'type'::text) AND ((relations.tags -> 'type'::text) = 'multipolygon'::text OR (relations.tags -> 'type'::text) = 'boundary'::text OR (relations.tags -> 'type'::text) = 'route'::text)
                      and relation_id = 1857
                  GROUP BY relation_members.relation_id, relations.version, relations.tags) rel_poly
