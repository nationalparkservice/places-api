CREATE SERVER places_api FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname '{{api}}', host 'localhost', port '5432');
CREATE USER MAPPING FOR PUBLIC SERVER places_api;


CREATE FOREIGN TABLE api_changeset_tags (
  changeset_id  bigint,
  k             text,
  v             text
) SERVER places_api OPTIONS ( table_name 'changeset_tags' );

CREATE FOREIGN TABLE api_changesets (
  id           bigint,
  closed_at    timestamp without time zone,
  num_changes  integer
) SERVER places_api OPTIONS ( table_name 'changesets' );

CREATE FOREIGN TABLE api_nodes (
  id           bigint,
  visible      boolean,
  version      bigint,
  changeset    bigint,
  "timestamp"  timestamp without time zone,
  "user"       text,
  uid          bigint,
  lat          double precision,
  lon          double precision,
  tag          json
) SERVER places_api OPTIONS ( table_name 'pgs_current_nodes' );

CREATE FOREIGN TABLE api_relations (
  id           bigint,
  visible      boolean,
  version      bigint,
  changeset    bigint,
  "timestamp"  timestamp without time zone,
  "user"       text,
  uid          bigint,
  member       json,
  tag          json
) SERVER places_api OPTIONS ( table_name 'pgs_current_relations' );

CREATE FOREIGN TABLE api_users (
  email         character varying(255),
  id            bigint,
  display_name  character varying(255)
) SERVER places_api OPTIONS ( table_name 'users' );

CREATE FOREIGN TABLE api_ways (
  id           bigint,
  visible      boolean,
  version      bigint,
  changeset    bigint,
  "timestamp"  timestamp without time zone,
  "user"       text,
  uid          bigint,
  nd           json,
  tag          json
) SERVER places_api OPTIONS ( table_name 'pgs_current_ways' );
