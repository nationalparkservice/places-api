 SELECT edit_user, source, count(*) as edits, 'point' as type FROM 
(SELECT
  api_users.display_name as edit_user,
  CASE
    WHEN left(api_changeset_tags.V, 2) = 'iD' then 'Places Editor (' || api_changeset_tags.V || ')'
    ELSE coalesce(nodes.tags->'nps:source_system', nodes.tags->'source')
  END as source
FROM
  nodes JOIN nps_render_point
    ON nodes.id = nps_render_point.osm_id
    JOIN api_users ON nodes.user_id = api_users.id
    JOIN api_changeset_tags ON api_changeset_tags.changeset_id = nodes.changeset_id AND api_changeset_tags.k = 'created_by'
WHERE
  nps_render_point.unit_code = 'thro'
) as summary
GROUP BY edit_user, source
ORDER BY edits desc;

SELECT edit_user, source, count(*) as edits, 'line' as type FROM 
(SELECT
  api_users.display_name as edit_user,
  CASE
    WHEN left(api_changeset_tags.V, 2) = 'iD' then 'Places Editor (' || api_changeset_tags.V || ')'
    ELSE coalesce(ways.tags->'nps:source_system', ways.tags->'source')
  END as source
FROM
  ways JOIN nps_render_line
    ON ways.id = nps_render_line.osm_id
    JOIN api_users ON ways.user_id = api_users.id
    JOIN api_changeset_tags ON api_changeset_tags.changeset_id = ways.changeset_id AND api_changeset_tags.k = 'created_by'
WHERE
  nps_render_line.unit_code = 'thro'
) as summary
GROUP BY edit_user, source
ORDER BY edits desc;

SELECT edit_user, source, count(*) as edits, 'polygon' as type FROM 
(SELECT
  api_users.display_name as edit_user,
  CASE
    WHEN left(api_changeset_tags.V, 2) = 'iD' then 'Places Editor (' || api_changeset_tags.V || ')'
    ELSE coalesce(ways.tags->'nps:source_system', ways.tags->'source')
  END as source
FROM
  ways JOIN nps_render_polygon
    ON ways.id = nps_render_polygon.osm_id
    JOIN api_users ON ways.user_id = api_users.id
    JOIN api_changeset_tags ON api_changeset_tags.changeset_id = ways.changeset_id AND api_changeset_tags.k = 'created_by'
WHERE
  nps_render_polygon.unit_code = 'thro'
) as summary
GROUP BY edit_user, source
ORDER BY edits desc;
