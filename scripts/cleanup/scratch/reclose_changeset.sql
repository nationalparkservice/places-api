SELECT
  way_id, ways.changeset_id, node_id, nodes.id
FROM
  way_nodes
  LEFT JOIN nodes ON way_nodes.node_id = nodes.id
  JOIN ways on ways.id = way_nodes.way_id
WHERE
nodes.id is null;
