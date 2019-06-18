-- This looks for rendered objects that have the wrong version
-- It then re-renders then with the right version

SELECT
  nps_render_point.osm_id,
  (SELECT o2p_render_element(nps_render_point.osm_id, 'N')) AS rerendered
FROM
  nps_render_point JOIN nodes on nodes.id = nps_render_point.osm_id
WHERE
  nodes.version != nps_render_point.version
UNION
SELECT
  nps_render_polygon.osm_id,
  (SELECT o2p_render_element(nps_render_polygon.osm_id, 'W')) AS rerendered
FROM
  nps_render_polygon JOIN ways ON ways.id = nps_render_polygon.osm_id
WHERE
  nps_render_polygon.osm_id >= 0 AND
  nps_render_polygon.version != ways.version
UNION
SELECT
  nps_render_line.osm_id,
  (SELECT o2p_render_element(nps_render_line.osm_id, 'W')) AS rerendered
FROM
  nps_render_line JOIN ways ON ways.id = nps_render_line.osm_id
WHERE
  nps_render_line.osm_id >= 0 AND
  nps_render_line.version != ways.version
UNION
SELECT
  nps_render_polygon.osm_id,
  (SELECT o2p_render_element(nps_render_polygon.osm_id, 'W')) AS rerendered
FROM
  nps_render_polygon JOIN relations ON relations.id = nps_render_polygon.osm_id * -1
WHERE
  nps_render_polygon.osm_id < 0 AND
  nps_render_polygon.version != relations.version
UNION
SELECT
  nps_render_line.osm_id,
  (SELECT o2p_render_element(nps_render_line.osm_id, 'W')) AS rerendered
FROM
  nps_render_line JOIN relations ON relations.id = nps_render_line.osm_id * -1
WHERE
  nps_render_line.osm_id < 0 AND
  nps_render_line.version != relations.version;
