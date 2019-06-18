SELECT
temp_points.id--, (select count(*) from nps_render_point  where osm_id = temp_points.id) as rendered
  -- o2p_render_element(nodes.id, 'N')
FROM
  temp_points LEFT OUTER JOIN
    nodes ON nodes.id = temp_points.id
WHERE
  nodes.id IS NULL; -- AND
  -- nodes.tags IS NOT NULL AND
  --   (
  --     (
  --       SELECT
  --         ARRAY_LENGTH(ARRAY_AGG(key.key), 1) AS array_length
  --       FROM
  --         UNNEST(AKEYS(nodes.tags)) key(key)
  --       WHERE
  --         key.key !~~ 'nps:%'::text
  --     )
  --   ) > 0;
