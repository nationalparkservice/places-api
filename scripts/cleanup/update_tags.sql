-- Run this every time tags get changed
-- This will go through the database and find anything that has been rendered with the wrong tags and will update them
-- ALERT: This query may take up to an hour to run!

SELECT
  o2p_render_element(nps_render_point.osm_id, 'N')
FROM
 nps_render_point
WHERE
  o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'superclass' != nps_render_point.superclass OR
  o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'class' != nps_render_point.class OR
  o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'type' != nps_render_point.type OR
  (o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'layerIndex')::integer != nps_render_point."z_order"
UNION ALL
SELECT
  o2p_render_element(nps_render_line.osm_id, CASE WHEN osm_id >= 0 THEN 'W' ELSE 'R' END)
FROM
 nps_render_line
WHERE
  o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'superclass' != nps_render_line.superclass OR
  o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'class' != nps_render_line.class OR
  o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'type' != nps_render_line.type OR
  (o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'layerIndex')::integer != nps_render_line."z_order"
UNION ALL
SELECT
  o2p_render_element(nps_render_polygon.osm_id, CASE WHEN osm_id >= 0 THEN 'W' ELSE 'R' END)
FROM
 nps_render_polygon
WHERE
  o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'superclass' != nps_render_polygon.superclass OR
  o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'class' != nps_render_polygon.class OR
  o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'type' != nps_render_polygon.type OR
  (o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'layerIndex')::integer != nps_render_polygon."z_order";
