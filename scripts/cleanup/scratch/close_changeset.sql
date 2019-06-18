
  UPDATE
    "changesets"
  SET
    "closed_at" = NOW()::timestamp without time zone,
    "num_changes" = (
      SELECT sum(counts.count) FROM (
        SELECT count(*) FROM nodes WHERE changeset_id = changesets.id
        UNION ALL
        SELECT count(*) FROM ways WHERE changeset_id = changesets.id
        UNION ALL
        SELECT count(*) FROM relations WHERE changeset_id = changesets.id
      ) counts),
      min_lat = (SELECT MIN(latitude) FROM nodes WHERE changeset_id = changesets.id),
      max_lat = (SELECT MAX(latitude) FROM nodes WHERE changeset_id = changesets.id),
      min_lon = (SELECT MIN(longitude) FROM nodes WHERE changeset_id = changesets.id),
      max_lon = (SELECT MAX(longitude) FROM nodes WHERE changeset_id = changesets.id)
  WHERE
    "id" = 11726;
