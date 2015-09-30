/* jshint camelcase: false */
var apiFunctions = require('./apiFunctions');

// These are all the calls we need to handle
module.exports = function(config) {
  var database = require('../database')('pgs', config);
  return [{
    'name': 'GET park',
    'description': 'Takes lat, lon, and a optional buffer and returns a park code or park codes.',
    'format': 'url',
    'method': 'GET',
    'path': 'park/:lon/:lat/:buffer',
    'process': function(req, res) {
      // lat: latitude of a point in WGS84
      // lon: longitude of a point in WGS84
      // buffer: buffer area in meters
      //
      req.params.buffer = req.params.buffer === '0' ? '1' : req.params.buffer;
      var queryArray = [
        'SELECT',
        '  LOWER(unit_code) AS unit_code,',
        '  short_name AS short_name,',
        '  long_name',
        'FROM',
        '  render_park_polys',
        'WHERE',
        '  ST_Intersects(ST_Buffer(ST_Transform(ST_SetSrid(ST_MakePoint(\'{{lon}}\',\'{{lat}}\'),4326),3857),\'{{buffer}}\'), poly_geom)',
        'ORDER BY',
        '  minzoompoly DESC,',
        '  area DESC'
      ];

      //TODO: Convert query params into normal params

      var query = queryArray.join(' ');
      database(req, res).query(query, 'park', function(expressRes, dbResult) {
        console.log(dbResult);
        if (dbResult && dbResult.data && dbResult.data.park && dbResult.data.park[0]) {
          // Remove the 'park' layer so the result is uniform with all the other results
          dbResult.data = apiFunctions.deleteEmptyTags(dbResult.data.park[0]);

          apiFunctions.respond(expressRes, dbResult, req);
        } else {
          apiFunctions.respond(res, {
            'error': {
              'code': 404,
              'description': 'Not Found'
            }
          }, req);
        }
      });

    }
  }, {
    'name': 'GET points',
    'description': 'Queries the map.',
    'format': 'url',
    'method': 'GET',
    'path': 'points',
    'process': function(req, res) {
      // https://github.com/nationalparkservice/places/issues/34

      //   bbox: (minLon, minLat, maxLon, maxLat)
      //   center (lon,lat)
      //   distance (in meters)
      //   case_sensitive: T/F (defaults to F)
      //   name: (comma separated list)
      //   name_like: (comma separated list of similar names)
      //   name_regex: (allows full control of the regular express to get names)
      //   type: (comma separated list)
      //   unit_code: (comma separated list)
      //
      //
      var queryArray = [
        'SELECT json_agg(to_json(pgs_current_nodes)) as node FROM',
        'pgs_current_nodes JOIN (',
        'SELECT DISTINCT nodes.id as node_id FROM',
        '( SELECT nodes.id, nodes.tags FROM nodes WHERE',
        'array_length(hstore_to_array(delete(tags, \'nps:places_id\')),1)/2 > 0 AND'
      ];


      // Convert the query items to parameters
      if (req.query.bbox) {
        req.params.minLon = parseFloat(req.query.bbox.split(',')[0], 10); //'-75.5419922';
        req.params.minLat = parseFloat(req.query.bbox.split(',')[1], 10); //'39.7832127';
        req.params.maxLon = parseFloat(req.query.bbox.split(',')[2], 10); //'-75.5364990';
        req.params.maxLat = parseFloat(req.query.bbox.split(',')[3], 10); //'39.7874339';
        queryArray.push('nodes.geom && ST_MakeEnvelope(\'{{minLon}}\',\'{{minLat}}\',\'{{maxLon}}\',\'{{maxLat}}\', 4326) AND');
      }

      if (req.query.center && req.query.center.split(',').length === 2 && req.query.distance) {
        req.params.distance = parseFloat(req.query.distance, 10);
        req.params.centerLon = parseFloat(req.query.center.split(',')[0], 10);
        req.params.centerLat = parseFloat(req.query.center.split(',')[1], 10);
        queryArray.push('nodes.geom && ST_Buffer(Geography(ST_MakePoint(\'{{centerLon}}\',\'{{centerLat}}\')), \'{{distance}}\') AND');
        queryArray.push('ST_DWithin (Geography(nodes.geom), Geography(ST_MakePoint(\'{{centerLon}}\',\'{{centerLat}}\')), \'{{distance}}\') AND');
      }

      queryArray.push('TRUE');
      queryArray.push(') nodes');
      if (req.query.type) {
        req.params.type = '^' + req.query.type.split(',').join('$|^') + '$';
        // queryArray.push('o2p_get_name(tags, \'N\', true) ~* \'{{type}}\' AND');
        queryArray.push('JOIN planet_osm_point ON nodes.id = planet_osm_point.osm_id AND planet_osm_point.fcat ~* \'{{type}}\'');
      }
      queryArray.push('WHERE');

      var comparison = req.query.case_sensitive && req.query.case_sensitive !== 'false' ? '~' : '~*';

      var nameQueries = [];
      if (req.query.name) {
        req.params.name = '^' + req.query.name.split(',').join('$|^') + '$';
        nameQueries.push('nodes.tags -> \'name\' ' + comparison + ' \'{{name}}\'');
      }

      if (req.query.name_like) {
        req.params.name_like = req.query.name_like.split(',').join('|');
        nameQueries.push('nodes.tags -> \'name\' ' + comparison + '  \'{{name_like}}\'');
      }

      if (req.query.name_regex) {
        req.params.name_regex = req.query.name_regex;
        nameQueries.push('nodes.tags -> \'name\' ' + comparison + ' \'{{name_regex}}\'');
      }

      if (nameQueries.length) queryArray.push('(' + nameQueries.join(' OR ') + ') AND');

      if (req.query.unit_code) {
        req.params.unit_code = '^' + req.query.unit_code.split(',').join('$|^') + '$';
        queryArray.push('nodes.tags -> \'nps:unit_code\' ~* \'{{unit_code}}\' AND');
      }

      queryArray.push('TRUE');
      queryArray.push(') nodes_in_query ON pgs_current_nodes.id = nodes_in_query.node_id');
      var query = queryArray.join(' ');

      if (true) { //TODO: eliminate invalid queries
        database(req, res).query(query, 'point', function(expressRes, dbResult) {
          if (dbResult && dbResult.data && dbResult.data.point && dbResult.data.point[0]) {
            // Remove the 'point' layer so the result is uniform with all the other results
            dbResult.data = apiFunctions.deleteEmptyTags(dbResult.data.point[0]);
          }
          // TODO: limits need to be added to the point query
          apiFunctions.respond(expressRes, dbResult, req);
        });
      } else {
        res.status({
          'statusCode': 501
        });
      }

    }
  }, {
    'name': 'GET source/:id(\\d+)',
    'description': 'Gets source id for all elements in a changeset.',
    'format': 'url',
    'method': 'GET',
    'path': 'source/:id(\\d+)',
    'process': function (req, res) {
      var query = "" +
          "SELECT n.changeset_id, u.name AS \"user\", 'create' AS action, 'node' AS element, n.id AS places_id, n.tags->'nps:source_system_key_value' AS gis_id, n.version, n.tstamp AT TIME ZONE 'UTC' " +
          "FROM nodes AS n JOIN users AS u ON u.id = n.user_id WHERE n.tags ? 'nps:source_system_key_value' AND n.changeset_id = '{{id}}' " +
          "UNION ALL " +
          "SELECT w.changeset_id, u.name AS \"user\", 'create' AS action, 'way' AS element, w.id AS places_id, w.tags->'nps:source_system_key_value' AS gis_id, w.version, w.tstamp AT TIME ZONE 'UTC' " +
          "FROM ways AS w JOIN users AS u ON u.id = w.user_id WHERE w.tags ? 'nps:source_system_key_value' AND w.changeset_id = '{{id}}' " +
          "UNION ALL " +
          "SELECT r.changeset_id, u.name AS \"user\", 'create' AS action, 'relation' AS element, r.id AS places_id, r.tags->'nps:source_system_key_value' AS gis_id, r.version, r.tstamp AT TIME ZONE 'UTC' " +
          "FROM relations AS r JOIN users AS u ON u.id = r.user_id WHERE r.tags ? 'nps:source_system_key_value' AND r.changeset_id = '{{id}}'";
      console.log(query);
      database(req, res).query(query, 'source', apiFunctions.respond);
    }
  }];
};
