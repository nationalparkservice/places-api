-- -- Function: public.o2p_get_preset(hstore, text[])
--
-- -- DROP FUNCTION public.o2p_get_preset(hstore, text[]);
--
-- CREATE OR REPLACE FUNCTION public.o2p_get_preset(
--     hstore,
--     text[])
--   RETURNS text AS
-- $BODY$
-- DECLARE
--   v_hstore ALIAS for $1;
--   v_geometry_type ALIAS FOR $2;
--   v_name TEXT;
--   v_tag_count bigint;
-- BEGIN
--
-- SELECT
--   ARRAY_LENGTH(ARRAY_AGG("key"),1)
-- FROM
--   UNNEST(AKEYS(v_hstore)) "key"
-- WHERE
--   "key" NOT LIKE 'nps:%'
-- INTO
--   v_tag_count;
--
--
-- IF v_tag_count > 0 THEN
  SELECT
    -- "preset"::json
    *, (select tags from nodes where id =3295288) as element_tags
  FROM (
    SELECT
      CASE 
        WHEN "geometry" && ARRAY['point']::text[] THEN "preset"
        ELSE null
      END as "preset",
      "pathname",
      max("hstore_len") AS "hstore_len",
      count(*) AS "match_count",
      max("layerIndex") as "layerIndex",
      "all_tags",
      bool_and("inCarto") as "inCarto"
    FROM (
      SELECT
        "preset",
        "pathname",
        "available_tags",
        "all_tags",
        "inCarto",
        "layerIndex",
        "geometry",
        each((select tags from nodes where id =3295288)) AS "input_tags",
        "hstore_len"
      FROM (
        SELECT
          "preset",
          "pathname",
          each("tags") AS "available_tags",
          "tags" as "all_tags",
          "inCarto",
          "layerIndex",
          "geometry",
          "hstore_len"
        FROM (
          SELECT
            "hstore_tag_list"."preset",
            "hstore_tag_list"."pathname",
            "inCarto",
            "layerIndex",
            "geometry",
            (SELECT hstore(array_agg("key"), array_agg(hstore_tag_list.tags->"key")) from unnest(akeys(hstore_tag_list.tags)) "key" WHERE "key" NOT LIKE 'nps:%') "tags",
            (SELECT array_length(array_agg("key"),1) FROM unnest(akeys("hstore_tag_list"."tags")) "key" WHERE "key" NOT LIKE 'nps:%') "hstore_len"
          FROM
            (
              SELECT
                (SELECT row_to_json("_") FROM (SELECT "superclass", "class", "name" as "type", "layerIndex") AS "_")::text as "preset",
                "path" as "pathname",
                json_to_hstore("tags") AS "tags",
                COALESCE("inCarto",false) as "inCarto",
                "layerIndex",
                "geometry"
              FROM
                "nps_presets"
              WHERE
                "inCarto" = true AND
                ((ARRAY['point'] && ARRAY['point']::text[] AND "nps_presets"."geometry" && ARRAY['point']) OR
                (ARRAY['line','area'] && ARRAY['point']::text[] AND "nps_presets"."geometry" && ARRAY['line','area']))
            ) "hstore_tag_list"
        ) "available_tags"
      ) "explode_tags"
    ) "paired_tags"
    WHERE
      "available_tags" = "input_tags"  OR
      (hstore(available_tags)->'value' = '*' AND hstore(available_tags)->'key' = hstore(input_tags)->'key')
    GROUP BY
      "all_tags",
      "preset",
      "pathname",
      "geometry"
    ) "counted_tags"
  WHERE
    "hstore_len" = "match_count"
  ORDER BY
    "match_count" DESC,
    avals("all_tags") && ARRAY['*'],
    "inCarto" DESC,
    "layerIndex" DESC
  LIMIT
    10
--   INTO
--     v_name;
--   ELSE
--     SELECT null INTO v_name;
--   END IF;
--
--  RETURN v_name;
-- END;
-- $BODY$
--   LANGUAGE plpgsql VOLATILE
--   COST 100;
-- ALTER FUNCTION public.o2p_get_preset(hstore, text[])
--   OWNER TO postgres;
--
/*
select
  osm_id, superclass, class, type, tags, (o2p_get_preset(tags, ARRAY['point'])::json->>'type')::text
FROM
  nps_render_point
WHERE
  (o2p_get_preset(tags, ARRAY['point'])::json->>'type') != nps_render_point.type
limit 2;
*/
