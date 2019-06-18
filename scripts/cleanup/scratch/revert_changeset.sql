DO $$
    DECLARE bad_changeset BIGINT = 5521;
BEGIN

  -- *********
  -- * NODES *
  -- *********

  -- Add the fields from the previous version of this node to the "changeset" version of the node
  UPDATE nodes AS bad_nodes
  SET
      latitude = COALESCE((SELECT latitude FROM nodes AS prev_nodes WHERE prev_nodes.node_id = bad_nodes.node_id AND prev_nodes.version = bad_nodes.version - 1), latitude),
      longitude = COALESCE((SELECT longitude FROM nodes AS prev_nodes WHERE prev_nodes.node_id = bad_nodes.node_id AND prev_nodes.version = bad_nodes.version - 1), longitude),
      visible = COALESCE((SELECT visible FROM nodes AS prev_nodes WHERE prev_nodes.node_id = bad_nodes.node_id AND prev_nodes.version = bad_nodes.version - 1), false)
  WHERE
    changeset_id = bad_changeset;


  -- Delete any tags added in this changeset
  DELETE FROM
    node_tags
  USING
    nodes
  WHERE
    node_tags.node_id = nodes.node_id AND
    node_tags.version = nodes.version AND
    nodes.changeset_id = bad_changeset;

  -- Copy back the tags from the previous changeset
  INSERT INTO
    node_tags
  (
    node_id,
    version,
    k,
    v
  )
    SELECT
      node_tags.node_id,
      node_tags.version + 1,
      node_tags.k,
      node_tags.v
    FROM
      node_tags JOIN nodes ON
        node_tags.node_id = nodes.node_id AND
        node_tags.version = nodes.version - 1 AND
        nodes.version > 0
    WHERE
      nodes.changeset_id = bad_changeset;

  -- ********
  -- * WAYS *
  -- ********

  -- Add the visible field from the previous version of this way to the "changeset" version of the way
  UPDATE ways AS bad_ways
  SET
      visible = COALESCE((SELECT visible FROM ways AS prev_ways WHERE prev_ways.way_id = bad_ways.way_id AND prev_ways.version = bad_ways.version - 1), false)
  WHERE
    changeset_id = bad_changeset;

  -- Delete any tags added in this changeset
  DELETE FROM
    way_tags
  USING
    ways
  WHERE
    way_tags.way_id = ways.way_id AND
    way_tags.version = ways.version AND
    ways.changeset_id = bad_changeset;

  -- Copy back the tags from the previous changeset
  INSERT INTO
    way_tags
  (
    way_id,
    version,
    k,
    v
  )
    SELECT
      way_tags.way_id,
      way_tags.version + 1,
      way_tags.k,
      way_tags.v
    FROM
      way_tags JOIN ways ON
        way_tags.way_id = ways.way_id AND
        way_tags.version = ways.version - 1 AND
        ways.version > 0
    WHERE
      ways.changeset_id = bad_changeset;

  -- Delete any way_nodes added in this changeset
  DELETE FROM
    way_nodes
  USING
    ways
  WHERE
    way_nodes.way_id = ways.way_id AND
    way_nodes.version = ways.version AND
    ways.changeset_id = bad_changeset;

  -- Copy back the tags from the previous changeset
  INSERT INTO
    way_nodes
  (
    way_id,
    node_id,
    version,
    sequence_id
  )
    SELECT
      way_nodes.way_id,
      way_nodes.node_id,
      way_nodes.version + 1,
      way_nodes.sequence_id
    FROM
      way_nodes JOIN ways ON
        way_nodes.way_id = ways.way_id AND
        way_nodes.version = ways.version - 1 AND
        ways.version > 0
    WHERE
      ways.changeset_id = bad_changeset;

  -- *************
  -- * RELATIONS *
  -- *************

  -- Add the visible field from the previous version of this way to the "changeset" version of the way
  UPDATE relations AS bad_relations
  SET
      visible = COALESCE((SELECT visible FROM relations AS prev_relations WHERE prev_relations.relation_id = bad_relations.relation_id AND prev_relations.version = bad_relations.version - 1), false)
  WHERE
    changeset_id = bad_changeset;

  -- Delete any tags added in this changeset
  DELETE FROM
    relation_tags
  USING
    relations
  WHERE
    relation_tags.relation_id = relations.relation_id AND
    relation_tags.version = relations.version AND
    relations.changeset_id = bad_changeset;

  -- Copy back the tags from the previous changeset
  INSERT INTO
    relation_tags
  (
    relation_id,
    version,
    k,
    v
  )
    SELECT
      relation_tags.relation_id,
      relation_tags.version + 1,
      relation_tags.k,
      relation_tags.v
    FROM
      relation_tags JOIN relations ON
        relation_tags.relation_id = relations.relation_id AND
        relation_tags.version = relations.version - 1 AND
        relations.version > 0
    WHERE
      relations.changeset_id = bad_changeset;

  -- Delete any relation_members added in this changeset
  DELETE FROM
    relation_members
  USING
    relations
  WHERE
    relation_members.relation_id = relations.relation_id AND
    relation_members.version = relations.version AND
    relations.changeset_id = bad_changeset;

  -- Copy back the tags from the previous changeset
  INSERT INTO
    relation_members
  (
    relation_id,
    member_type,
    member_id,
    member_role,
    version,
    sequence_id
  )
    SELECT
      relation_members.relation_id,
      relation_members.member_type,
      relation_members.member_id,
      relation_members.member_role,
      relation_members.version + 1,
      relation_members.sequence_id
    FROM
      relation_members JOIN relations ON
        relation_members.relation_id = relations.relation_id AND
        relation_members.version = relations.version - 1 AND
        relations.version > 0
    WHERE
      relations.changeset_id = bad_changeset;

  PERFORM close_changeset(bad_changeset);
END $$;

