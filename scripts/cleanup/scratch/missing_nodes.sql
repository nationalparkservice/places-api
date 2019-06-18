SELECT
  distinct a.id as WAY
FROM (
SELECT
  changeset_id as id,
  unnest(nodes) AS node
FROM
  ways
) a LEFT JOIN nodes on a.node = nodes.id
WHERE nodes.id IS NULL;
/*
SELECT * FROM close_changeset(1600);
SELECT * FROM close_changeset(2004);
SELECT * FROM close_changeset(5041);
SELECT * FROM close_changeset(1839);
SELECT * FROM close_changeset(1743);
SELECT * FROM close_changeset(2491);
SELECT * FROM close_changeset(1251);
SELECT * FROM close_changeset(2199);
SELECT * FROM close_changeset(2087);
SELECT * FROM close_changeset(3160);
SELECT * FROM close_changeset(2544);
SELECT * FROM close_changeset(3186);
SELECT * FROM close_changeset(5040);
SELECT * FROM close_changeset(4993);
SELECT * FROM close_changeset(972);
SELECT * FROM close_changeset(1199);
SELECT * FROM close_changeset(5167);
*/
