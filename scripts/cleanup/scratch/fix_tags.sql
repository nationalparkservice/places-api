-- Canoe / Kayak
/*SELECT
  'INSERT INTO node_tags (node_id, version, k, v) VALUES (' || osm_id ||', ' || version || ', ' || E'\'motorboat\', \'no\');' as sql
FROM
  nps_render_point
WHERE
  (tags->'leisure') = 'slipway' AND
  (tags->'canoe') is not null AND
  (tags->'motorboat') is null;

SELECT
  'SELECT * FROM close_changeset(' || changeset || ');' as sql
FROM
(
SELECT (SELECT changeset_id FROM nodes WHERE id = osm_id) as changeset
FROM nps_render_point
WHERE
  (tags->'leisure') = 'slipway' AND
  (tags->'canoe') is not null AND
  (tags->'motorboat') is null
) z
GROUP BY changeset;
*/

SELECT
  count(*)
  -- osm_id,
  -- version
FROM
  nps_render_line
WHERE
  (tags->'canoe') is not null AND
  (tags->'motorway') is not null;
