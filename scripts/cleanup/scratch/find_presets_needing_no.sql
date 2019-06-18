SELECT
  name,
  (SELECT array_agg(unnest) FROM unnest(fields) WHERE unnest like 'nps/%' and unnest != 'nps/unitcode') as problematic_fields
FROM
  nps_presets
WHERE
  (SELECT count(*) FROM unnest(fields) WHERE unnest like 'nps/%' and unnest != 'nps/unitcode') > 0
LIMIT
  12;

"motor_vehicle":"no", "motorcycle":"no", "foot":"no", "bicycle":"no", "atv":"no", "4wd_only":"no", "snowmobile":"no", "horse":"no"
