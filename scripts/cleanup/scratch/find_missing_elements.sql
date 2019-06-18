SELECT
  o2p_render_element(nps_render_point.osm_id, 'N')
  -- 'N' as member_type,
  -- nps_render_point.osm_id
  -- nps_render_point.superclass,
  -- nps_render_point.class,
  -- nps_render_point.type,
  -- o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json AS preset
FROM
 nps_render_point
WHERE
  o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'superclass' != nps_render_point.superclass OR
  o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'class' != nps_render_point.class OR
  o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json->>'type' != nps_render_point.type
UNION ALL
SELECT
  o2p_render_element(nps_render_line.osm_id, CASE WHEN osm_id > 0 THEN 'W' ELSE 'R' END)
  -- CASE WHEN osm_id > 0 THEN 'W' ELSE 'R' END AS member_type,
  -- nps_render_line.osm_id
  -- nps_render_point.superclass,
  -- nps_render_point.class,
  -- nps_render_point.type,
  -- o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json AS preset
FROM
 nps_render_line
WHERE
  o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'superclass' != nps_render_line.superclass OR
  o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'class' != nps_render_line.class OR
  o2p_get_preset(nps_render_line.tags, ARRAY['line'::text])::json->>'type' != nps_render_line.type
UNION ALL
SELECT
  o2p_render_element(nps_render_polygon.osm_id, CASE WHEN osm_id > 0 THEN 'W' ELSE 'R' END)
  -- CASE WHEN osm_id > 0 THEN 'W' ELSE 'R' END AS member_type,
  -- nps_render_polygon.osm_id
  -- nps_render_point.superclass,
  -- nps_render_point.class,
  -- nps_render_point.type,
  -- o2p_get_preset(nps_render_point.tags, ARRAY['point'::text])::json AS preset
FROM
 nps_render_polygon
WHERE
  o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'superclass' != nps_render_polygon.superclass OR
  o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'class' != nps_render_polygon.class OR
  o2p_get_preset(nps_render_polygon.tags, ARRAY['line'::text])::json->>'type' != nps_render_polygon.type;
