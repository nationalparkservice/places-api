SELECT
  t || id as "node_id",
  tags -> 'nps:unit_code' as "unit_code",
  st_asgeojson(geom) as "geometry",
  tags::json as tags
FROM (
  SELECT id, changeset_id, tags, geom, 'n' as t FROM nodes UNION ALL
  SELECT id, changeset_id, tags, null as geom, 'w' as t FROM ways UNION ALL
  SELECT id, changeset_id, tags, null as geom, 'r' as t FROM relations
     ) g JOIN "public"."api_changeset_tags"
     ON "g"."changeset_id" = "public"."api_changeset_tags"."changeset_id"
WHERE "public"."api_changeset_tags"."v" = 'Places Submit';

-- SELECT v, count(*) FROM "api_changeset_tags" where "api_changeset_tags"."k" = 'nps:source_system' GROUP BY v;
-- SELECT k, count(*) FROM "api_changeset_tags" /*where "api_changeset_tags"."k" = 'created_by'*/ GROUP BY k;
