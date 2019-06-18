-- This script will find any elements that haven't been rendered for whatever reason, and it will render them
-- This runs relatively quickly because it is greedy on selecting what records are missing
-- This also means that there will always be records that it tries to render

SELECT
  ways.id,
  (SELECT o2p_render_element(ways.id, 'W')) AS rerendered
FROM
 ways
WHERE
  id NOT IN (
    SELECT osm_id FROM nps_render_polygon WHERE osm_id >= 0
    UNION
    SELECT osm_id FROM nps_render_line WHERE osm_id >= 0
  ) AND
  tags IS NOT NULL
UNION ALL
SELECT
  relations.id,
  (SELECT o2p_render_element(relations.id, 'R')) AS rerendered
FROM
 relations
WHERE
  id NOT IN (
    SELECT osm_id * -1 FROM nps_render_polygon WHERE osm_id < 0
    UNION
    SELECT osm_id * -1 FROM nps_render_line WHERE osm_id < 0
  ) AND
  tags IS NOT NULL
UNION ALL
SELECT
  nodes.id,
  (SELECT o2p_render_element(nodes.id, 'N')) AS rerendered
FROM
 nodes
WHERE
  id NOT IN (
    SELECT osm_id FROM nps_render_point
  ) AND
  array_length(akeys(tags - 'nps:unit_code'::text), 1) IS NOT NULL;
