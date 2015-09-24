-- CURRENT DATA views

-- Nodes
DROP VIEW IF EXISTS api_current_nodes;
CREATE VIEW api_current_nodes AS
SELECT
  current_nodes.id as id,
  current_nodes.visible,
  current_nodes.version,
  current_nodes.changeset_id as changeset,
  current_nodes.timestamp AT TIME ZONE 'UTC' as timestamp,
  users.display_name as user,
  changesets.user_id as uid,
  current_nodes.latitude/10000000::float as lat,
  current_nodes.longitude/10000000::float as lon,
  (SELECT json_agg(tags) from (SELECT k, v FROM current_node_tags WHERE node_id = current_nodes.id) tags) AS tag
FROM
  current_nodes
  JOIN changesets
    ON current_nodes.changeset_id = changesets.id
     JOIN users
       ON changesets.user_id = users.id;

-- Ways
DROP VIEW IF EXISTS api_current_ways;
CREATE VIEW api_current_ways AS
SELECT
  current_ways.id AS id,
  current_ways.visible AS visible,
  current_ways.version AS VERSION,
  current_ways.changeset_id AS changeset,
  current_ways.timestamp AT TIME ZONE 'UTC' AS TIMESTAMP,
  users.display_name AS USER,
  changesets.user_id AS uid,
  (SELECT json_agg(nodes) FROM (
    SELECT node_id AS ref
    FROM current_way_nodes
    WHERE current_way_nodes.way_id = current_ways.id
      AND version = current_ways.version
    ORDER BY sequence_id
    ) nodes
  ) AS nd,
  (SELECT json_agg(tags) FROM (
      SELECT k, v
      FROM current_way_tags
      WHERE current_way_tags.way_id = current_ways.id
    ) tags
  ) AS tag
FROM
  current_ways
  JOIN changesets
    ON current_ways.changeset_id = changesets.id
  JOIN users
    ON changesets.user_id = users.id;

-- Relations
DROP VIEW IF EXISTS api_current_relations;
CREATE VIEW api_current_relations AS
SELECT
  current_relations.id as id,
  current_relations.visible as visible,
  current_relations.version as version,
  current_relations.changeset_id as changeset,
  current_relations.timestamp AT TIME ZONE 'UTC' as timestamp,
  users.display_name as user,
  changesets.user_id as uid,
  (SELECT json_agg(members) FROM (
    SELECT
      lower(member_type::text) as type,
      member_id as ref, 
      member_role as role
    FROM
      relation_members 
    WHERE
      relation_id = current_relations.id
  ) members) as member,
  (SELECT json_agg(tags) FROM (
    SELECT
      k,
      v
    FROM
      current_relation_tags
    WHERE
      current_relation_tags.relation_id = current_relations.id
  ) tags) as tag
FROM
  current_relations
  JOIN changesets
    ON current_relations.changeset_id = changesets.id
    JOIN users
      ON changesets.user_id = users.id;

-- ALL DATA Views

-- Nodes
DROP VIEW IF EXISTS api_nodes;
CREATE VIEW api_nodes AS
SELECT
  nodes.node_id as id,
  nodes.visible,
  nodes.version,
  nodes.changeset_id as changeset,
  nodes.timestamp AT TIME ZONE 'UTC' as timestamp,
  users.display_name as user,
  changesets.user_id as uid,
  nodes.latitude/10000000::float as lat,
  nodes.longitude/10000000::float as lon,
  (SELECT json_agg(tags) from (SELECT k, v FROM node_tags WHERE node_id = nodes.node_id AND version = nodes.version) tags) AS tag
FROM
  nodes
  JOIN changesets
    ON nodes.changeset_id = changesets.id
     JOIN users
       ON changesets.user_id = users.id;

-- Ways
DROP VIEW IF EXISTS api_ways;
CREATE VIEW api_ways AS
SELECT
  ways.way_id AS id,
  ways.visible AS visible,
  ways.version AS VERSION,
  ways.changeset_id AS changeset,
  ways.timestamp AT TIME ZONE 'UTC' AS TIMESTAMP,
  users.display_name AS USER,
  changesets.user_id AS uid,
  (SELECT json_agg(nodes) FROM (
    SELECT node_id AS ref
    FROM way_nodes
    WHERE way_nodes.way_id = ways.way_id
      AND version = ways.version
    ORDER BY sequence_id
    ) nodes
  ) AS nd,
  (SELECT json_agg(tags) FROM (
      SELECT k, v
      FROM way_tags
      WHERE way_tags.way_id = ways.way_id AND
      way_tags.version = ways.version
    ) tags
  ) AS tag
FROM
  ways
  JOIN changesets
    ON ways.changeset_id = changesets.id
  JOIN users
    ON changesets.user_id = users.id;

-- Relations
DROP VIEW IF EXISTS api_relations;
CREATE VIEW api_relations AS
SELECT
  relations.relation_id as id,
  relations.visible as visible,
  relations.version as version,
  relations.changeset_id as changeset,
  relations.timestamp AT TIME ZONE 'UTC' as timestamp,
  users.display_name as user,
  changesets.user_id as uid,
  (SELECT json_agg(members) FROM (
    SELECT
      lower(member_type::text) as type,
      member_id as ref, 
      member_role as role
    FROM
      relation_members 
    WHERE
      relation_members.relation_id = relations.relation_id AND
      relation_members.version = relations.version
  ) members) as member,
  (SELECT json_agg(tags) FROM (
    SELECT
      k,
      v
    FROM
      relation_tags
    WHERE
      relation_tags.relation_id = relations.relation_id AND
      relation_tags.version = relations.version
  ) tags) as tag
FROM
  relations
  JOIN changesets
    ON relations.changeset_id = changesets.id
    JOIN users
      ON changesets.user_id = users.id;

-- Changesets
DROP VIEW IF EXISTS api_changesets;
CREATE VIEW api_changesets AS
SELECT
  changesets.id as id,
  users.display_name as user,
  changesets.user_id as uid,
  changesets.created_at AT TIME ZONE 'UTC' as created_at,
  changesets.closed_at AT TIME ZONE 'UTC' as closed_at,
  (select (closed_at>created_at AND num_changes<=50000) AS open from changesets open where open.id = changesets.id) as open,
  changesets.min_lat/10000000::float as min_lat,
  changesets.min_lon/10000000::float as min_lon,
  changesets.max_lat/10000000::float as max_lat,
  changesets.max_lon/10000000::float as max_lon,
  (SELECT json_agg(tags) FROM (
    SELECT k, v
    FROM changeset_tags
    WHERE changeset_id = changesets.id
  ) tags) as tag
FROM
  changesets
  JOIN users
    ON changesets.user_id = users.id;

-----------
-- Get created date and updated date, as well as min and max version
DROP VIEW IF EXISTS api_element_info;
CREATE VIEW api_element_info AS
SELECT
  "calculated_elements"."id",
  "calculated_elements"."geometry",
  "calculated_elements"."min_version",
  "calculated_elements"."max_version",
  "calculated_elements"."created_time",
  "calculated_elements"."updated_time",
  "calculated_elements"."created_changeset",
  "calculated_elements"."updated_changeset"
FROM (
SELECT
  "agg_elements"."id",
  "agg_elements"."geometry",
  "agg_elements"."min_version",
  "agg_elements"."max_version",
  (SELECT "timestamp"
   FROM (
     SELECT 
       (json_array_elements("agg_elements"."times")->>'version')::int AS "version",
       json_array_elements("agg_elements"."times")->>'timestamp' AS "timestamp"
   ) "create_time"
   WHERE "create_time"."version" =  "agg_elements"."min_version"
  ) AS "created_time",
  (SELECT "timestamp"
   FROM (
      SELECT
        (json_array_elements("agg_elements"."times")->>'version')::int AS "version",
        json_array_elements("agg_elements"."times")->>'timestamp' AS "timestamp"
   ) "update_time"
   WHERE "update_time"."version" =  "agg_elements"."max_version"
   ) AS "updated_time",
  (SELECT "changeset_id"
   FROM (
     SELECT 
       (json_array_elements("agg_elements"."times")->>'version')::int AS "version",
       json_array_elements("agg_elements"."times")->>'changeset_id' AS "changeset_id"
   ) "create_time"
   WHERE "create_time"."version" =  "agg_elements"."min_version"
  ) AS "created_changeset",
  (SELECT "changeset_id"
   FROM (
      SELECT
        (json_array_elements("agg_elements"."times")->>'version')::int AS "version",
        json_array_elements("agg_elements"."times")->>'changeset_id' AS "changeset_id"
   ) "update_time"
   WHERE "update_time"."version" =  "agg_elements"."max_version"
   ) AS "updated_changeset"
FROM 
  (
    SELECT
      "nodes"."node_id" AS "id",
      'n'::text AS "geometry",
      min("nodes"."version") AS "min_version",
      max("nodes"."version") AS "max_version",
      json_agg((SELECT row_to_json("_") FROM (SELECT "version", "timestamp", "changeset_id") AS "_")) AS "times"
    FROM
      "nodes"
    GROUP BY "node_id"
    UNION ALL
    SELECT
      "ways"."way_id" AS "id",
      'w'::text AS "geometry",
      min("ways"."version") AS "min_version",
      max("ways"."version") AS "max_version",
      json_agg((SELECT row_to_json("_") FROM (SELECT "version", "timestamp", "changeset_id") AS "_")) AS "times"
    FROM
      "ways"
    GROUP BY "way_id"
    UNION ALL
    SELECT
      "relations"."relation_id" AS "id",
      'r'::text AS "geometry",
      min("relations"."version") AS "min_version",
      max("relations"."version") AS "max_version",
      json_agg((SELECT row_to_json("_") FROM (SELECT "version", "timestamp", "changeset_id") AS "_")) AS "times"
    FROM
      "relations"
    GROUP BY "relation_id"
  ) "agg_elements"
WHERE
    "agg_elements"."min_version" != "agg_elements"."max_version") "calculated_elements";
