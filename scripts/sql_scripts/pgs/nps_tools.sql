------------------------------
-- Keeps track of changes to geometries so they can be removed from old maps
CREATE TABLE public.nps_change_log
(
  osm_id bigint,
  version integer,
  member_type character(1),
  way geometry,
  rendered timestamp without time zone,
  change_time timestamp without time zone
);

-----------------------------------------------------------------------
-- nps render tables

-- Table: public.nps_render_point

-- DROP TABLE public.nps_render_point;

CREATE TABLE public.nps_render_point
(
  osm_id bigint NOT NULL,
  version integer,
  name text,
  type text, -- This is a calculated field. It calculates the point "type" from its "tags" field. It uses the o2p_get_name (true) function to perform the calculation.
  nps_type text, -- This is a calculated field. It calculates the polygon "type" from its "tags" field. It uses the o2p_get_name (false) function to perform the calculation.
  tags hstore, -- This contains all of the OpenStreetMap style tags associated with this point.
  rendered timestamp without time zone, -- This contains the time that this specific point was rendered. This is important for synchronizing the render tools.
  the_geom geometry, -- Contains the geometry for the point.
  z_order integer, -- Contains the display order of the points.  This is a calculated field, it is calclated from the "tags" field using the "nps_node_o2p_calculate_zorder" function.
  unit_code text, -- The unit code of the park that contains this point
  CONSTRAINT osm_id PRIMARY KEY (osm_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.nps_render_point
  OWNER TO osm;
COMMENT ON TABLE public.nps_render_point
  IS 'This table contains the most recent version of all visible points in order to be displayed on park tiles as well as be used in CartoDB.
In the future (as on jan 2015) this table will only contain the points that have been fully validated';
COMMENT ON COLUMN public.nps_render_point.type IS 'This is a calculated field. It calculates the point "type" from its "tags" field. It uses the o2p_get_name function to perform the calculation.';
COMMENT ON COLUMN public.nps_render_point.tags IS 'This contains all of the OpenStreetMap style tags associated with this point.';
COMMENT ON COLUMN public.nps_render_point.rendered IS 'This contains the time that this specific point was rendered. This is important for synchronizing the render tools.';
COMMENT ON COLUMN public.nps_render_point.the_geom IS 'Contains the geometry for the point.';
COMMENT ON COLUMN public.nps_render_point.z_order IS 'Contains the display order of the points.  This is a calculated field, it is calclated from the "tags" field using the "nps_node_o2p_calculate_zorder" function.';
COMMENT ON COLUMN public.nps_render_point.unit_code IS 'The unit code of the park that contains this point';


-----------------------------------------------------------------------
-- nps render tables

-- Table: public.nps_render_polygon

-- DROP TABLE public.nps_render_polygon;

CREATE TABLE public.nps_render_polygon
(
  osm_id bigint NOT NULL,
  version integer,
  name text,
  type text, -- This is a calculated field. It calculates the polygon "type" from its "tags" field. It uses the o2p_get_name (true) function to perform the calculation.
  nps_type text, -- This is a calculated field. It calculates the polygon "type" from its "tags" field. It uses the o2p_get_name (false) function to perform the calculation.
  tags hstore, -- This contains all of the OpenStreetMap style tags associated with this polygon.
  rendered timestamp without time zone, -- This contains the time that this specific polygon was rendered. This is important for synchronizing the render tools.
  the_geom geometry, -- Contains the geometry for the polygon.
  z_order integer, -- Contains the display order of the polygons.  This is a calculated field, it is calclated from the "tags" field using the "nps_node_o2p_calculate_zorder" function.
  unit_code text, -- The unit code of the park that contains this polygon
  CONSTRAINT nps_render_polygon_osm_id PRIMARY KEY (osm_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.nps_render_polygon
  OWNER TO osm;
COMMENT ON TABLE public.nps_render_polygon
  IS 'This table contains the most recent version of all visible polygons in order to be displayed on park tiles as well as be used in CartoDB.
In the future (as on jan 2015) this table will only contain the polygons that have been fully validated';
COMMENT ON COLUMN public.nps_render_polygon.type IS 'This is a calculated field. It calculates the polygon "type" from its "tags" field. It uses the o2p_get_name function to perform the calculation.';
COMMENT ON COLUMN public.nps_render_polygon.tags IS 'This contains all of the OpenStreetMap style tags associated with this polygon.';
COMMENT ON COLUMN public.nps_render_polygon.rendered IS 'This contains the time that this specific polygon was rendered. This is important for synchronizing the render tools.';
COMMENT ON COLUMN public.nps_render_polygon.the_geom IS 'Contains the geometry for the polygon.';
COMMENT ON COLUMN public.nps_render_polygon.z_order IS 'Contains the display order of the polygons.  This is a calculated field, it is calclated from the "tags" field using the "nps_node_o2p_calculate_zorder" function.';
COMMENT ON COLUMN public.nps_render_polygon.unit_code IS 'The unit code of the park that contains this polygon';


-----------------------------------------------------------------------
-- nps render tables

-- Table: public.nps_render_line

-- DROP TABLE public.nps_render_line;

CREATE TABLE public.nps_render_line
(
  osm_id bigint NOT NULL,
  version integer,
  name text,
  type text, -- This is a calculated field. It calculates the line "type" from its "tags" field. It uses the o2p_get_name (true) function to perform the calculation.
  nps_type text, -- This is a calculated field. It calculates the polygon "type" from its "tags" field. It uses the o2p_get_name (false) function to perform the calculation.
  tags hstore, -- This contains all of the OpenStreetMap style tags associated with this line.
  rendered timestamp without time zone, -- This contains the time that this specific line was rendered. This is important for synchronizing the render tools.
  the_geom geometry, -- Contains the geometry for the line.
  z_order integer, -- Contains the display order of the lines.  This is a calculated field, it is calclated from the "tags" field using the "nps_node_o2p_calculate_zorder" function.
  unit_code text, -- The unit code of the park that contains this line
  CONSTRAINT nps_render_line_osm_id PRIMARY KEY (osm_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.nps_render_line
  OWNER TO osm;
COMMENT ON TABLE public.nps_render_line
  IS 'This table contains the most recent version of all visible lines in order to be displayed on park tiles as well as be used in CartoDB.
In the future (as on jan 2015) this table will only contain the lines that have been fully validated';
COMMENT ON COLUMN public.nps_render_line.type IS 'This is a calculated field. It calculates the line "type" from its "tags" field. It uses the o2p_get_name function to perform the calculation.';
COMMENT ON COLUMN public.nps_render_line.tags IS 'This contains all of the OpenStreetMap style tags associated with this line.';
COMMENT ON COLUMN public.nps_render_line.rendered IS 'This contains the time that this specific line was rendered. This is important for synchronizing the render tools.';
COMMENT ON COLUMN public.nps_render_line.the_geom IS 'Contains the geometry for the line.';
COMMENT ON COLUMN public.nps_render_line.z_order IS 'Contains the display order of the lines.  This is a calculated field, it is calclated from the "tags" field using the "nps_node_o2p_calculate_zorder" function.';
COMMENT ON COLUMN public.nps_render_line.unit_code IS 'The unit code of the park that contains this line';

--------------------------------------------------------
------------------------------
-- nps_render_log
------------------------------
-- This table is how we keep track of each process that was run
CREATE TABLE nps_render_log
(
  render_id bigint,
  task_name character varying(255),
  run_time timestamp without time zone,
  end_time timestamp without time zone,
  status character varying(255)
);
-----------------------------------------------------------------------

-----------------------------------------------------------------------
CREATE OR REPLACE VIEW public.nps_cartodb_point_view AS
SELECT
  "nps_render_point"."osm_id" AS "cartodb_id",
  "nps_render_point"."version" AS "version",
  "nps_render_point"."tags" -> 'name'::text AS "name",
  CASE
    WHEN "nps_render_point"."osm_id" < 0 THEN
      'r' || ("nps_render_point"."osm_id" * -1)
    ELSE
      'n' || "nps_render_point"."osm_id"
  END AS "places_id",
  lower("nps_render_point"."unit_code") AS "unit_code",
  "nps_render_point"."nps_type" AS "type",
  "nps_render_point"."tags"::json::text AS "tags",
  "nps_render_point"."the_geom" AS "the_geom",
  "nps_render_point"."rendered" AS "last_modified"
FROM "nps_render_point";
COMMENT ON VIEW public.nps_cartodb_point_view
  IS 'This view is designed to transform our internal nps_render_point table into the table we maintain in cartodb.';
  
---------------------------------
-- View: nps_tilemill_point_view

-- DROP VIEW nps_tilemill_point_view;
CREATE OR REPLACE VIEW "nps_tilemill_point_view" AS 
  SELECT "nps_render_point"."osm_id",
    "nps_render_point"."name",
    "nps_render_point"."nps_type" AS "type",
    "nps_render_point"."the_geom" AS "way",
    "nps_render_point"."z_order",
    "nps_render_point"."unit_code",
    "render_park_polys"."minzoompoly"
   FROM
     "nps_render_point"
     LEFT JOIN "render_park_polys" ON lower("nps_render_point"."unit_code") = lower("render_park_polys"."unit_code"::text)
   WHERE "nps_render_point"."type" IS NOT NULL;
-----------------------------------------------------------------------

-----------------------------------------------------------------------
CREATE OR REPLACE VIEW public.nps_cartodb_polygon_view AS
SELECT
  "nps_render_polygon"."osm_id" AS "cartodb_id",
  "nps_render_polygon"."version" AS "version",
  "nps_render_polygon"."tags" -> 'name'::text AS "name",
  CASE
    WHEN "nps_render_polygon"."osm_id" < 0 THEN
      'r' || ("nps_render_polygon"."osm_id" * -1)
    ELSE
      'w' || "nps_render_polygon"."osm_id"
  END AS "places_id",
  "nps_render_polygon"."unit_code" AS "unit_code",
  "nps_render_polygon"."nps_type" AS "type",
  "nps_render_polygon"."tags"::json::text AS tags,
  "nps_render_polygon"."the_geom" AS the_geom,
  "nps_render_polygon"."rendered" AS "last_modified"
FROM "nps_render_polygon";;
COMMENT ON VIEW public.nps_cartodb_polygon_view
  IS 'This view is designed to transform our internal nps_render_polygon table into the table we maintain in cartodb.';
  
---------------------------------

-----------------------------------------------------------------------
CREATE OR REPLACE VIEW public.nps_cartodb_line_view AS
SELECT
  "nps_render_line"."osm_id" AS "cartodb_id",
  "nps_render_line"."version" AS "version",
  "nps_render_line"."tags" -> 'name'::text AS "name",
  CASE
    WHEN "nps_render_line"."osm_id" < 0 THEN
      'r' || ("nps_render_line"."osm_id" * -1)
    ELSE
      'w' || "nps_render_line"."osm_id"
  END AS "places_id",
  "nps_render_line"."unit_code" AS "unit_code",
  "nps_render_line"."nps_type" AS "type",
  "nps_render_line"."tags"::json::text AS tags,
  "nps_render_line"."the_geom" AS the_geom,
  "nps_render_line"."rendered" AS "last_modified"
FROM "nps_render_line";;
COMMENT ON VIEW public.nps_cartodb_line_view
  IS 'This view is designed to transform our internal nps_render_line table into the table we maintain in cartodb.';
  
---------------------------------

CREATE OR REPLACE FUNCTION public.nps_node_o2p_calculate_zorder(text)
  RETURNS integer AS
$BODY$
DECLARE
  v_tag ALIAS for $1;
  v_zorder integer;
BEGIN

SELECT
  CASE
    WHEN v_tag = 'Visitor Center' THEN 40
    WHEN v_tag = 'Ranger Station' THEN 38
    WHEN v_tag = 'Information' THEN 36
    WHEN v_tag = 'Lodge' THEN 34
    WHEN v_tag = 'Campground' THEN 32
    WHEN v_tag = 'Food Service' THEN 30
    WHEN v_tag = 'Store' THEN 28
    WHEN v_tag = 'Picnic Site' THEN 26
    WHEN v_tag = 'Picnic Table' THEN 26
    WHEN v_tag = 'Trailhead' THEN 24
    WHEN v_tag = 'Car Parking' THEN 22
    WHEN v_tag = 'Restrooms' THEN 20
    ELSE 0
  END AS order
INTO
  v_zorder;

RETURN v_zorder;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.nps_node_o2p_calculate_zorder(text)
  OWNER TO postgres;
  ------------
  
  -----
-- Convert JSON to hstore
CREATE OR REPLACE FUNCTION public.json_to_hstore(
  json
)
  RETURNS hstore AS $json_to_hstore$
DECLARE
  v_json ALIAS for $1;
  v_hstore HSTORE;
BEGIN
SELECT
  hstore(array_agg(key), array_agg(value))
FROM
 json_each_text(v_json)
INTO
  v_hstore;

 RETURN v_hstore;
END;
$json_to_hstore$
LANGUAGE plpgsql;
------------------------

------------------------
CREATE OR REPLACE FUNCTION public.o2p_get_name(
  hstore,
  text[],
  boolean
)
  RETURNS text AS $o2p_get_name$
DECLARE
  v_hstore ALIAS for $1;
  v_geometry_type ALIAS FOR $2;
  v_all ALIAS for $3;
  v_name TEXT;
  v_tag_count bigint;
BEGIN

SELECT
  ARRAY_LENGTH(ARRAY_AGG("key"),1)
FROM
  UNNEST(AKEYS(v_hstore)) "key"
WHERE
  "key" NOT LIKE 'nps:%'
INTO
  v_tag_count;


IF v_tag_count > 0 THEN
  SELECT
    "name"
  FROM (
    SELECT
      CASE 
        WHEN "geometry" && v_geometry_type THEN "name"
        ELSE null
      END as "name",
      "pathname",
      max("hstore_len") AS "hstore_len",
      count(*) AS "match_count",
      max("matchscore") as "matchscore",
      "all_tags",
      bool_and("searchable") as "searchable"
    FROM (
      SELECT
        "name",
        "pathname",
        "available_tags",
        "all_tags",
        "searchable",
        "matchscore",
        "geometry",
        each(v_hstore) AS "input_tags",
        "hstore_len"
      FROM (
        SELECT
          "name",
          "pathname",
          each("tags") AS "available_tags",
          "tags" as "all_tags",
          "searchable",
          "matchscore",
          "geometry",
          "hstore_len"
        FROM (
          SELECT
            "hstore_tag_list"."name",
            "hstore_tag_list"."pathname",
            "searchable",
            "matchscore",
            "geometry",
            (SELECT hstore(array_agg("key"), array_agg(hstore_tag_list.tags->"key")) from unnest(akeys(hstore_tag_list.tags)) "key" WHERE "key" NOT LIKE 'nps:%') "tags",
            (SELECT array_length(array_agg("key"),1) FROM unnest(akeys("hstore_tag_list"."tags")) "key" WHERE "key" NOT LIKE 'nps:%') "hstore_len"
          FROM
            (
              SELECT
                "name",
                "pathname",
                json_to_hstore("tags") AS "tags",
                COALESCE("searchable",false) as "searchable",
                "matchscore",
                "geometry"
              FROM
                "tag_list"
              WHERE
                ((ARRAY['point'] && v_geometry_type AND "tag_list"."geometry" && ARRAY['point']) OR
                (ARRAY['line','area'] && v_geometry_type AND "tag_list"."geometry" && ARRAY['line','area'])) AND
                (v_all OR (
                  "tag_list"."searchable" is true
                ))
            ) "hstore_tag_list"
        ) "available_tags"
      ) "explode_tags"
    ) "paired_tags"
    WHERE
      "available_tags" = "input_tags"  OR
      (hstore(available_tags)->'value' = '*' AND hstore(available_tags)->'key' = hstore(input_tags)->'key')
    GROUP BY
      "all_tags",
      "name",
      "pathname",
      "geometry"
    ) "counted_tags"
  WHERE
    "hstore_len" = "match_count"
  ORDER BY
    "match_count" DESC,
    "searchable" DESC,
    "matchscore" DESC,
    avals("all_tags") && ARRAY['*']
  LIMIT
    1
  INTO
    v_name;
  ELSE
    SELECT null INTO v_name;
  END IF;

 RETURN v_name;
END;
$o2p_get_name$
LANGUAGE plpgsql;
--------------------------------


--------------------------------
CREATE OR REPLACE VIEW public.nps_planet_osm_point_view AS 
SELECT
  "osm_id",
  "version",
  "name",
  "fcat",
  "nps_fcat",
  "tags", 
  "created", 
  "way",
  nps_node_o2p_calculate_zorder("base"."nps_fcat") as "z_order",
  COALESCE("unit_code", (
    -- If the unit_code is null, try to join it up
    SELECT
      LOWER(unit_code)
    FROM
      render_park_polys
    WHERE
      -- The projection for OSM is 900913, although we use 3857, and they are identical
      -- PostGIS requires a 'transform' between these two SRIDs when doing a comparison
      ST_Transform("base"."way", 3857) && "render_park_polys"."poly_geom" AND 
      ST_Contains("render_park_polys"."poly_geom",ST_Transform("base"."way", 3857))
    ORDER BY minzoompoly, area
    LIMIT 1
  )) AS "unit_code"
FROM (
  SELECT
    "nodes"."id" AS "osm_id",
    "nodes"."version" AS "version",
    "nodes"."tags" -> 'name'::text AS "name",
    o2p_get_name("tags", ARRAY['point'], true) AS "fcat",
    o2p_get_name("tags", ARRAY['point'], false) AS "nps_fcat",
    "tags" AS "tags",
    NOW()::timestamp without time zone AS "created",
    st_transform(nodes.geom, 900913) AS "way",
    "nodes"."tags" -> 'nps:unit_code'::text AS "unit_code"
  FROM
    "nodes"
  WHERE
    (
      SELECT
        array_length(array_agg("key"),1)
      FROM
        unnest(akeys(nodes.tags)) "key"
      WHERE
        "key" NOT LIKE 'nps:%'
    ) > 0
) "base"
WHERE
  "fcat" IS NOT NULL;
--------------------------------

--------------------------------
CREATE OR REPLACE VIEW public.nps_planet_osm_polygon_view AS 
SELECT
  "base"."osm_id",
  "base"."version",
  "base"."name",
  "base"."fcat",
  "base"."nps_fcat",
  "base"."tags", 
  "base"."created", 
  "base"."way",
  nps_node_o2p_calculate_zorder("base"."nps_fcat") AS "z_order",
  COALESCE("base"."unit_code", (
    -- If the unit_code is null, try to join it up
    SELECT
      LOWER("render_park_polys"."unit_code")
    FROM
      "render_park_polys"
    WHERE
      -- The projection for OSM is 900913, although we use 3857, and they are identical
      -- PostGIS requires a 'transform' between these two SRIDs when doing a comparison
      ST_Transform("base"."way", 3857) && "render_park_polys"."poly_geom" AND 
      ST_Contains("render_park_polys"."poly_geom",ST_Transform("base"."way", 3857))
    ORDER BY "render_park_polys"."minzoompoly", "render_park_polys"."area"
    LIMIT 1
  )) AS "unit_code"
FROM (
  SELECT
    "ways"."id" AS "osm_id",
    "ways"."version" AS "version",
    "ways"."tags" -> 'name'::text AS "name",
    o2p_get_name("ways"."tags", ARRAY['area'], true) AS "fcat",
    o2p_get_name("ways"."tags", ARRAY['area'], false) AS "nps_fcat",
    "ways"."tags" AS "tags",
    NOW()::timestamp without time zone AS "created",
    ST_MakePolygon(ST_Transform(o2p_calculate_nodes_to_line("ways"."nodes"), 900913)) AS way,
    "ways"."tags" -> 'nps:unit_code'::text AS "unit_code"
  FROM
    "ways"
  WHERE
    ARRAY_LENGTH("ways"."nodes", 1) >= 4 AND
    NOT (EXISTS (
      SELECT
        1
      FROM
        relation_members JOIN relations 
        ON "relation_members"."relation_id" = "relations"."id"
      WHERE "relation_members"."member_id" = "ways"."id" AND
        UPPER("relation_members"."member_type") = 'W'::bpchar AND
          (
            ("relations"."tags" -> 'type'::text) = 'multipolygon'::text OR
            ("relations"."tags" -> 'type'::text) = 'boundary'::text OR
            ("relations"."tags" -> 'type'::text) = 'route'::text
          )
    )) AND
    (
      SELECT
        ARRAY_LENGTH(array_agg("key"),1)
      FROM
        UNNEST(AKEYS("ways"."tags")) "key"
      WHERE
        "key" NOT LIKE 'nps:%'
    ) > 0 AND
    ST_IsClosed(o2p_calculate_nodes_to_line("ways"."nodes"))
  UNION ALL
  SELECT
    "rel_poly"."osm_id" AS "osm_id",
    "rel_poly"."version" AS "version",
    "rel_poly"."tags" -> 'name'::text AS "name",
    o2p_get_name("rel_poly"."tags", ARRAY['area'], true) AS "fcat",
    o2p_get_name("rel_poly"."tags", ARRAY['area'], false) AS "nps_fcat",
    "rel_poly"."tags" AS "tags",
    NOW()::timestamp without time zone AS "created",
    rel_poly.way AS "way",
    "rel_poly"."tags" -> 'nps:unit_code'::text AS "unit_code"
  FROM (
    SELECT
      "relation_members"."relation_id" * (-1) AS "osm_id",
      "relations"."version" AS "version",
      "relations"."tags",
      ST_Transform(ST_Union(o2p_aggregate_polygon_relation("relation_members"."relation_id")), 900913) AS "way"
    FROM
      "ways"
        JOIN "relation_members" ON "ways"."id" = "relation_members"."member_id"
        JOIN "relations" ON "relation_members"."relation_id" = "relations"."id"
    WHERE
      (
        SELECT
          ARRAY_LENGTH(ARRAY_AGG("key"),1)
        FROM
          UNNEST(AKEYS("relations"."tags")) "key"
        WHERE
          "key" NOT LIKE 'nps:%'
      ) > 0 AND
      ARRAY_LENGTH("ways"."nodes", 1) >= 4 AND
      ST_IsClosed(o2p_calculate_nodes_to_line(ways.nodes)) AND
      exist(relations.tags, 'type'::text) AND
      (
        (relations.tags -> 'type'::text) = 'multipolygon'::text OR
        (relations.tags -> 'type'::text) = 'boundary'::text OR
        (relations.tags -> 'type'::text) = 'route'::text
      )
      GROUP BY
        "relation_members"."relation_id",
        "relations"."version",
        "relations"."tags"
  ) rel_poly
) "base"
WHERE
  "base"."fcat" IS NOT NULL;
--------------------------------

--------------------------------
CREATE OR REPLACE VIEW public.nps_planet_osm_line_view AS 
SELECT
  "base"."osm_id",
  "base"."version",
  "base"."name",
  "base"."fcat",
  "base"."nps_fcat",
  "base"."tags", 
  "base"."created", 
  "base"."way",
  nps_node_o2p_calculate_zorder("base"."nps_fcat") AS "z_order",
  COALESCE("base"."unit_code", (
    -- If the unit_code is null, try to join it up
    SELECT
      LOWER("render_park_polys"."unit_code")
    FROM
      "render_park_polys"
    WHERE
      -- The projection for OSM is 900913, although we use 3857, and they are identical
      -- PostGIS requires a 'transform' between these two SRIDs when doing a comparison
      ST_Transform("base"."way", 3857) && "render_park_polys"."poly_geom" AND 
      ST_Contains("render_park_polys"."poly_geom",ST_Transform("base"."way", 3857))
    ORDER BY "render_park_polys"."minzoompoly", "render_park_polys"."area"
    LIMIT 1
  )) AS "unit_code"
FROM (
  SELECT
    "ways"."id" AS "osm_id",
    "ways"."version" AS "version",
    "ways"."tags" -> 'name'::text AS "name",
    o2p_get_name("ways"."tags", ARRAY['line'], true) AS "fcat",
    o2p_get_name("ways"."tags", ARRAY['line'], false) AS "nps_fcat",
    "ways"."tags" AS "tags",
    NOW()::timestamp without time zone AS "created",
    ST_Transform(o2p_calculate_nodes_to_line(ways.nodes), 900913) AS "way",
    "ways"."tags" -> 'nps:unit_code'::text AS "unit_code"
  FROM
    "ways"
  WHERE
    NOT (EXISTS (
      SELECT
        1
      FROM
        relation_members JOIN relations 
        ON "relation_members"."relation_id" = "relations"."id"
      WHERE "relation_members"."member_id" = "ways"."id" AND
        UPPER("relation_members"."member_type") = 'W'::bpchar AND
        ("relations"."tags" -> 'type'::text) = 'route'::text
    )) AND
    (
      SELECT
        ARRAY_LENGTH(array_agg("key"),1)
      FROM
        UNNEST(AKEYS("ways"."tags")) "key"
      WHERE
        "key" NOT LIKE 'nps:%'
    ) > 0
  UNION ALL
  SELECT
    "rel_line"."osm_id" AS "osm_id",
    "rel_line"."version" AS "version",
    "rel_line"."tags" -> 'name'::text AS "name",
    o2p_get_name("rel_line"."tags", ARRAY['line'], true) AS "fcat",
    o2p_get_name("rel_line"."tags", ARRAY['line'], false) AS "nps_fcat",
    "rel_line"."tags" AS "tags",
    NOW()::timestamp without time zone AS "created",
    rel_line.way AS "way",
    "rel_line"."tags" -> 'nps:unit_code'::text AS "unit_code"
  FROM (
    SELECT
      "relation_members"."relation_id" * (-1) AS "osm_id",
      "relations"."version",
      "relations"."tags",
      ST_Transform(ST_Union(o2p_aggregate_line_relation("relation_members"."relation_id")), 900913) AS "way"
      FROM
        "ways"
        JOIN "relation_members" ON "ways"."id" = "relation_members"."member_id"
        JOIN "relations" ON "relation_members"."relation_id" = "relations"."id"
      WHERE
        (
          SELECT
            ARRAY_LENGTH(ARRAY_AGG("key"),1)
          FROM
            UNNEST(AKEYS("relations"."tags")) "key"
          WHERE
            "key" NOT LIKE 'nps:%'
        ) > 0 AND
        exist(relations.tags, 'type'::text)
        GROUP BY
          "relation_members"."relation_id",
          "relations"."version",
          "relations"."tags"
      ) rel_line
) "base"
WHERE
  "base"."fcat" IS NOT NULL;
--------------------------------

----------------------------------------

-- Function: public.o2p_render_element(bigint, character)

-- DROP FUNCTION public.o2p_render_element(bigint, character);

CREATE OR REPLACE FUNCTION public.o2p_render_element(
    bigint,
    character)
  RETURNS boolean AS
$BODY$
  DECLARE
    v_id ALIAS FOR $1;
    v_member_type ALIAS FOR $2;
    v_rel_id BIGINT;
  BEGIN

  -- We make relation ids negative so they don't stomp on the namespace for ways
    IF UPPER(v_member_type) = 'R' THEN
      SELECT v_id * -1 INTO v_id;
    END IF;

  -- Add any information that will be deleting / changing
  -- to the change log, which is used to keep the renderers synchronized
    IF UPPER(v_member_type) = 'N' THEN
    -- Nodes have different OSM_IDs than ways, so we do them separently
      INSERT INTO nps_change_log (
        SELECT
          v_id AS "osm_id",
          MIN("nps_rendered"."version") AS "version",
          v_member_type AS "member_type",
          ST_UNION("nps_rendered"."the_geom") AS "way",
          MIN("nps_rendered"."rendered") AS "created",
          NOW()::timestamp without time zone AS "change_time"
        FROM (
           SELECT
             "osm_id",
             "version",
             "the_geom",
             "rendered"
           FROM
             "nps_render_point") AS "nps_rendered"
        WHERE
          "osm_id" = v_id
      );

      DELETE FROM "nps_render_point" WHERE osm_id = v_id;
      INSERT INTO "nps_render_point" (
        SELECT
          "osm_id" AS "osm_id",
          "version" AS "version",
          "name" AS "name",
          "superclass" AS "superclass",
          "class" AS "class",
          "type" AS "type",
          "v1_type" AS "v1_type",
          "tags" AS "tags",
          "created" AS "rendered",
          "way" AS "the_geom",
          "z_order" AS "z_order",
          "unit_code" AS "unit_code"
        FROM "nps_render_point_view"
        WHERE "osm_id" = v_id
      );
    ELSE
      -- Nodes have different OSM_IDs than ways, so we do them separently
      -- relations also have different ids, but we make them negative so they can fit in the same namespace
      INSERT INTO nps_change_log (
      SELECT
        v_id AS "osm_id",
        MIN("nps_rendered"."version") AS "version",
        v_member_type AS "member_type",
        ST_UNION("nps_rendered"."the_geom") AS "way",
        MIN("nps_rendered"."rendered") AS "created",
        NOW()::timestamp without time zone AS "change_time"
      FROM (
         SELECT
           "osm_id",
           "version",
           "the_geom",
           "rendered"
         FROM
           "nps_render_polygon"
         UNION ALL
         SELECT
           "osm_id",
           "version",
           "the_geom",
           "rendered"
         FROM
           "nps_render_line") AS "nps_rendered"
      WHERE
        "osm_id" = v_id
    );

      DELETE FROM "nps_render_polygon" WHERE "osm_id" = v_id;
      INSERT INTO "nps_render_polygon" (
        SELECT
          "osm_id" AS "osm_id",
          "version" AS "version",
          "name" AS "name",
          "superclass" AS "superclass",
          "class" AS "class",
          "type" AS "type",
          "v1_type" AS "v1_type",
          "tags" AS "tags",
          "created" AS "rendered",
          "way" AS "the_geom",
          "z_order" AS "z_order",
          "unit_code" AS "unit_code"
        FROM "nps_render_polygon_view"
        WHERE "osm_id" = v_id
      );

      DELETE FROM "nps_render_line" WHERE "osm_id" = v_id;
      INSERT INTO "nps_render_line" (
        SELECT
          "osm_id" AS "osm_id",
          "version" AS "version",
          "name" AS "name",
          "tags" AS "tags",
          "created" AS "rendered",
          "way" AS "the_geom",
          "superclass" AS "superclass",
          "class" AS "class",
          "type" AS "type",
          "v1_type" AS "v1_type",
          "z_order" AS "z_order",
          "unit_code" AS "unit_code"
        FROM "nps_render_line_view"
        WHERE "osm_id" = v_id
      );
    END IF;

-- Now that the render tables are updated, update the sync table
    DELETE FROM "summary_sync" WHERE places_id = lower(v_member_type) || abs(v_id);
    INSERT INTO "summary_sync" SELECT * FROM "summary_view" WHERE places_id = lower(v_member_type) || abs(v_id);

    RETURN true;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.o2p_render_element(bigint, character)
  OWNER TO postgres;

--------------------------------
-- Render a full changeset
CREATE OR REPLACE FUNCTION public.o2p_render_changeset(bigint)
  RETURNS boolean[] AS
$BODY$
  DECLARE
    v_changeset_id ALIAS FOR $1;
    v_return_value boolean[];
  BEGIN
    SELECT array_agg(o2p_render_element(all_types.id, all_types.member_type)) FROM (
      SELECT id, 'N'::character as member_type, changeset from api_nodes 
      UNION ALL
      SELECT id, 'W'::character as member_type, changeset from api_ways
      UNION ALL
      SELECT id, 'R'::character as member_type, changeset from api_relations
    ) all_types
    WHERE all_types.changeset = v_changeset_id
    INTO v_return_value;

    RETURN v_return_value;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
--------------------------------
-- Render a full changeset
-- Function: public.pgs_update()

-- DROP FUNCTION public.pgs_update();

CREATE OR REPLACE FUNCTION public.pgs_update()
  RETURNS boolean[] AS
$BODY$
  DECLARE
    v_return_value boolean[];
    v_empty_records text[];
  BEGIN
    SELECT array_agg(not o2p_render_changeset(api_changesets.id) && ARRAY[false])
    FROM api_changesets
    WHERE api_changesets.closed_at > (
      SELECT max(all_types_rendered.rendered) FROM (
        SELECT rendered from nps_render_point
        UNION ALL
        SELECT rendered from nps_render_line
        UNION ALL
        SELECT rendered from nps_render_polygon
      ) all_types_rendered)
    INTO v_return_value;

    -- Clean out elements that no longer exist
    SELECT
      array_agg("places_id")
    FROM
      "summary_view"
    WHERE
      "changeset_id" IS NULL
    INTO
      v_empty_records;

    DELETE FROM "nps_render_polygon" WHERE CASE WHEN "osm_id" < 0 THEN 'r' ELSE 'w' END || ABS("osm_id") = ANY(v_empty_records);
    DELETE FROM "nps_render_line" WHERE CASE WHEN "osm_id" < 0 THEN 'r' ELSE 'w' END || ABS("osm_id") = ANY(v_empty_records);
    DELETE FROM "nps_render_point" WHERE 'n' || "osm_id" = ANY(v_empty_records);
    DELETE FROM "summary_sync" WHERE "places_id" = ANY(v_empty_records);

    RETURN v_return_value;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.pgs_update()
  OWNER TO postgres;

-------------------
-- summary view
-------------------
CREATE OR REPLACE VIEW "summary_view" AS
SELECT
  "elements"."osm_id",
  "elements"."places_id",
  "elements"."version",
  "elements"."name",
  "elements"."superclass",
  "elements"."class",
  lower("elements"."type") AS "type",
  "elements"."tags"::json AS "tags",
  "elements"."element_type" AS "element_type",
  ST_Transform("elements"."the_geom", 4326) AS "the_geom",
  "elements"."tstamp",
  "elements"."changeset_id",
  "elements"."changeset_tags"::json AS "changeset_tags",
  ("elements"."changeset_tags"::json -> 'created_by')::text AS "changeset_editor",
  ("elements"."changeset_tags"::json -> 'comment')::text AS "changeset_comment",
  ("elements"."changeset_tags"::json -> 'imagery_used')::text AS "changeset_imagery",
  "elements"."tags"->'nps:unit_code' AS "unit_code",
  (SELECT "long_name" FROM "render_park_polys" WHERE lower("elements"."tags" -> 'nps:unit_code') = lower("render_park_polys"."unit_code") LIMIT 1) AS "unit_name",
  "elements"."user_id" as "user_id",
  "users"."name" AS "user_name"
FROM (
  SELECT
    "nps_render_point"."osm_id",
    'n' || "nps_render_point"."osm_id" AS "places_id",
    "nps_render_point"."version",
    "nps_render_point"."name",
    "nps_render_point"."superclass",
    "nps_render_point"."class",
    "nps_render_point"."type",
    "nps_render_point"."tags",
    "nps_render_point"."the_geom",
    'point' AS "element_type",
    "nodes"."tstamp" As "tstamp",
    "nodes"."changeset_id" as "changeset_id",
    (select hstore(array_agg(k), array_agg(v)) from json_populate_recordset(null::new_hstore,(SELECT json_agg("result") FROM (SELECT "k", "v" FROM "api_changeset_tags" WHERE "api_changeset_tags"."changeset_id" = "nodes"."changeset_id") "result")))::json AS "changeset_tags",
    "nodes"."user_id" as "user_id"
  FROM
    nps_render_point LEFT JOIN nodes ON nodes.id = osm_id
  UNION ALL
  SELECT
    "nps_render_line"."osm_id",
    CASE WHEN "nps_render_line"."osm_id" < 0 THEN 'r' || "nps_render_line"."osm_id" * -1 ELSE 'w' || "nps_render_line"."osm_id" END AS "places_id",
    "nps_render_line"."version",
    "nps_render_line"."name",
    "nps_render_line"."superclass",
    "nps_render_line"."class",
    "nps_render_line"."type",
    "nps_render_line"."tags",
    "nps_render_line"."the_geom",
    'line' AS "element_type",
    CASE WHEN
      "nps_render_line"."osm_id" < 0 THEN "relations"."tstamp"
    ELSE "ways"."tstamp"
    END as "tstamp",
    CASE WHEN
      "nps_render_line"."osm_id" < 0 THEN "relations"."changeset_id"
    ELSE "ways"."changeset_id"
    END as "changeset_id",
    CASE WHEN
      "nps_render_line"."osm_id" < 0 THEN
      (select hstore(array_agg(k), array_agg(v)) from json_populate_recordset(null::new_hstore,(SELECT json_agg("result") FROM (SELECT "k", "v" FROM "api_changeset_tags" WHERE "api_changeset_tags"."changeset_id" = "relations"."changeset_id") "result")))::json
    ELSE
      (select hstore(array_agg(k), array_agg(v)) from json_populate_recordset(null::new_hstore,(SELECT json_agg("result") FROM (SELECT "k", "v" FROM "api_changeset_tags" WHERE "api_changeset_tags"."changeset_id" = "ways"."changeset_id") "result")))::json
    END AS "changeset_tags",
    CASE WHEN
      "nps_render_line"."osm_id" < 0 THEN "relations"."user_id"
    ELSE "ways"."user_id"
    END as "user_id"
  FROM
    "nps_render_line"
      LEFT JOIN "ways" ON "nps_render_line"."osm_id" = "ways"."id"
      LEFT JOIN "relations" ON "nps_render_line"."osm_id" * -1 = "relations"."id"
  UNION ALL
  SELECT
    "nps_render_polygon"."osm_id",
    CASE WHEN "nps_render_polygon"."osm_id" < 0 THEN 'r' || "nps_render_polygon"."osm_id" * -1 ELSE 'w' || "nps_render_polygon"."osm_id" END AS "places_id",
    "nps_render_polygon"."version",
    "nps_render_polygon"."name",
    "nps_render_polygon"."superclass",
    "nps_render_polygon"."class",
    "nps_render_polygon"."type",
    "nps_render_polygon"."tags",
    "nps_render_polygon"."the_geom",
    'polygon' AS "element_type",
    CASE WHEN
      "nps_render_polygon"."osm_id" < 0 THEN "relations"."tstamp"
    ELSE "ways"."tstamp"
    END as "tstamp",
    CASE WHEN
      "nps_render_polygon"."osm_id" < 0 THEN "relations"."changeset_id"
    ELSE "ways"."changeset_id"
    END as "changeset_id",
    CASE WHEN
      "nps_render_polygon"."osm_id" < 0 THEN
      (select hstore(array_agg(k), array_agg(v)) from json_populate_recordset(null::new_hstore,(SELECT json_agg("result") FROM (SELECT "k", "v" FROM "api_changeset_tags" WHERE "api_changeset_tags"."changeset_id" = "relations"."changeset_id") "result")))::json
    ELSE
      (select hstore(array_agg(k), array_agg(v)) from json_populate_recordset(null::new_hstore,(SELECT json_agg("result") FROM (SELECT "k", "v" FROM "api_changeset_tags" WHERE "api_changeset_tags"."changeset_id" = "ways"."changeset_id") "result")))::json
    END AS "changeset_tags",
   CASE WHEN
      "nps_render_polygon"."osm_id" < 0 THEN "relations"."user_id"
    ELSE "ways"."user_id"
    END as "user_id"
  FROM
    "nps_render_polygon"
      LEFT JOIN "ways" ON "nps_render_polygon"."osm_id" = "ways"."id"
      LEFT JOIN "relations" ON "nps_render_polygon"."osm_id" * -1 = "relations"."id"
) AS "elements"
  LEFT JOIN "users" ON "elements"."user_id" = "users"."id";
  
CREATE TABLE summary_sync AS SELECT * FROM summary_view;

---------------------------
-- Foreign Data
---------------------------
CREATE EXTENSION postgres_fdw;
CREATE SERVER places_api FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', port '5432', dbname 'places_api');
CREATE USER MAPPING FOR PUBLIC SERVER places_api OPTIONS (user 'postgres', password 'postgres');


--DROP FOREIGN TABLE api_changesets;
CREATE FOREIGN TABLE api_changesets (id bigint, closed_at timestamp without time zone) SERVER places_api OPTIONS (table_name 'changesets');
--DROP FOREIGN TABLE api_nodes;
CREATE FOREIGN TABLE api_nodes (id bigint, visible boolean, version bigint, changeset bigint, "timestamp" timestamp without time zone, "user" text, uid bigint, lat double precision, lon double precision, tag JSON) SERVER places_api OPTIONS (table_name 'pgs_current_nodes');
--DROP FOREIGN TABLE api_ways;
CREATE FOREIGN TABLE api_ways (id bigint, visible boolean, version bigint, changeset bigint, "timestamp" timestamp without time zone, "user" text, "uid" bigint, nd JSON, tag JSON)  SERVER places_api OPTIONS (table_name 'pgs_current_ways');
--DROP FOREIGN TABLE api_relations;
CREATE FOREIGN TABLE api_relations (id bigint, visible boolean, version bigint, changeset bigint, "timestamp" timestamp without time zone, "user" text, "uid" bigint, member JSON, tag JSON) SERVER places_api OPTIONS (table_name 'pgs_current_relations');
--DROP FOREIGN TABLE api_users;
CREATE FOREIGN TABLE api_users (email character varying (255), id bigint, display_name character varying (255)) SERVER places_api OPTIONS (table_name 'users');
--DROP FOREIGN TABLE api_changeset_tags;
CREATE FOREIGN TABLE api_changeset_tags (changeset_id bigint, k text, v text) SERVER places_api OPTIONS (table_name 'changeset_tags');
--DROP FOREIGN TABLE api_element_info;
CREATE FOREIGN TABLE api_element_info (id bigint, geometry text, max_version bigint, created_time text, updated_time text, created_changeset text, updated_changeset text) SERVER places_api OPTIONS (table_name 'api_element_info');
