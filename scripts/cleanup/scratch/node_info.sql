SELECT
  node_id,
  changeset_id,
  visible,
  version,
  timestamp,
  users.display_name,
  (select array_agg((k,v)) from node_tags where node_tags.node_id = nodes.node_id) as kv
FROM
  nodes JOIN changesets on nodes.changeset_id = changesets.id
  join users on changesets.user_id = users.id
ORDER BY
  timestamp desc
LIMIT 10;
