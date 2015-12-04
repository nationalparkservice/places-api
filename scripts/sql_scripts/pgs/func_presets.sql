CREATE OR REPLACE FUNCTION public.o2p_get_preset(
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
