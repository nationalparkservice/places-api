SELECT display_name, count(*), array_agg(distinct unit_code) FROM (
SELECT
  'node' as type,
  tags->'nps:unit_code' as unit_code,
  user_id
FROM
  nodes
UNION ALL
SELECT
  'way' as type,
  tags->'nps:unit_code' as unit_code,
  user_id
FROM
  ways
UNION ALL
SELECT
  'relation' as type,
  tags->'nps:unit_code' as unit_code,
  user_id
FROM
  relations) datarz JOIN api_users on datarz.user_id = api_users.id
WHERE unit_code IN ('arch', 'cany', 'lyjo')
group by display_name;
