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

-- Sync disabled for now
-- Now that the render tables are updated, update the sync table
    -- DELETE FROM "summary_sync" WHERE places_id = lower(v_member_type) || abs(v_id);
    -- INSERT INTO "summary_sync" SELECT * FROM "summary_view" WHERE places_id = lower(v_member_type) || abs(v_id);

    RETURN true;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.o2p_render_element(bigint, character)
  OWNER TO postgres;
