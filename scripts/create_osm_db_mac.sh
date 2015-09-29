#!/usr/bin/env bash
# written by regan_sarwas@nps.gov on 2015-09-28 for Mac OSX 10.10.5
# It is based on the super simple to install Postgress.app (v9.4.4 & postgis2.1.7) at http://postgresapp.com
# It assumes you already have Postgress.app installed and running as the user that runs this script.
# This script also assumes that you have a working version of the Java VM running.
# By 2015-09-29, this script will be out of date.  It is better used as documentation than single click solution.

# The following database names are based on the places-website/environment.json and places-website/secrets/database.json
# edit the config files if they are changed here; leave any pair blank if you do not want that set
dbname_api_prod=places_api
dbname_pgs_prod=places_pgs

dbname_api_test=dev_places_api
dbname_pgs_test=dev_places_pgs

dbname_api_dev=test_places_api
dbname_pgs_dev=test_places_pgs

dbuser=osm
dbpass=$1

script_dir=`dirname "$BASH_SOURCE"`
includes_dir=$script_dir/../includes

# build the a seed file by exporting from osm, or downloading an XML file from geofabrik
# leave this blank, or point to a non-existant file to skip the seed file
seedfile=$includes_dir/anchorage.osm

if [[ $dbpass == "" ]]; then
  echo ""
  read -p "  What is the database password for '$dbuser': " dbpass
  if [[ $dbpass == "" ]]; then
    print "No password provided"
    echo "Usage: $0 PASSWORD"
    exit 1
  fi
fi

# get default schemas and get/build support function
includes_dir=../includes
if [ -d $includes_dir/db/ ]; then
  rm -rf $includes_dir/db/
fi
mkdir -p $includes_dir/db/functions/quad_tile
mkdir -p $includes_dir/db/sql
cd $includes_dir/db/sql
echo -e "\nDownload and fix default schemas\n================================\n"
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/db/structure.sql
curl -O https://raw.githubusercontent.com/openstreetmap/osmosis/master/package/script/pgsnapshot_schema_0.6.sql
sed -i ".bak" "s:/srv/www/master.osm.compton.nu:$(pwd)/../..:g" structure.sql
cd -

echo -e "\nDownload code for quad tile function\n================================\n"
cd $includes_dir/db/functions
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/db/functions/maptile.c
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/db/functions/quadtile.c
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/db/functions/xid_to_int4.c
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/db/functions/Makefile
cd -

cd $includes_dir/db/functions/quad_tile
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/lib/quad_tile/extconf.rb
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/lib/quad_tile/quad_tile.c
curl -O https://raw.githubusercontent.com/openstreetmap/openstreetmap-website/master/lib/quad_tile/quad_tile.h
cd -

echo -e "\nBuild the quad_tile function\n================================\n"
# Clean up the makefile
cd $includes_dir/db/functions
sed -i '.bak' 's/\.\.\/\.\.\/lib\/quad_tile/quad_tile/g' Makefile
make
cd -


# Postgres stuff
# Set up the OSM user and the default databases
# do not add custom code until after seed data is loaded
echo -e "\nCreate '$dbuser' database account\n================================\n"
psql -c "CREATE USER $dbuser WITH PASSWORD '$dbpass'"
psql -c "ALTER USER $dbuser WITH SUPERUSER;"

for api in $dbname_api_prod $dbname_api_test $dbname_api_dev;
do
echo -e "\nCreate the '$api' database\n================================\n"
    dropdb --if-exists $api
    createdb -O $dbuser  -E UTF8 $api
    # psql -d $api -U $dbuser -c "CREATE EXTENSION plpgsql;" #installed by default in 9.x
    psql -d $api -U $dbuser -f $includes_dir/db/sql/structure.sql
    psql -d $api -U $dbuser -c "CREATE EXTENSION dblink;"
    psql -d $api -U $dbuser -c "CREATE EXTENSION hstore;"
done

for snapshot in $dbname_pgs_prod $dbname_pgs_test $dbname_pgs_dev;
do
echo -e "\nCreate the '$snapshot' database\n================================\n"
    dropdb --if-exists $snapshot
    createdb -O $dbuser -E UTF8 $snapshot
    # psql -d $snapshot -U $dbuser -c "CREATE EXTENSION plpgsql;"  #installed by default in 9.x
    psql -d $snapshot -U $dbuser -c "CREATE EXTENSION postgis;"
    psql -d $snapshot -U $dbuser -c "CREATE EXTENSION postgis_topology;"
    psql -d $snapshot -U $dbuser -c "CREATE EXTENSION hstore;"
    psql -d $snapshot -U $dbuser -c "CREATE EXTENSION postgres_fdw;"
    psql -d $snapshot -U $dbuser -f $includes_dir/db/sql/pgsnapshot_schema_0.6.sql
done


# Install Osmosis and load sample data; must be done before adding custom code
if [ -f $seedfile ]; then
    echo -e "\nDownload and unpack Osmosis\n================================\n"
    if [ -d "$includes_dir/osmosis" ]; then
      rm -rf "$includes_dir/osmosis"
    fi
    mkdir -p $includes_dir/osmosis
    cd $includes_dir/osmosis
    curl -O http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.zip
    unzip osmosis-latest.zip
    cd -

    # Load the file into the database
    for api in $dbname_api_prod $dbname_api_test $dbname_api_dev;
    do
        echo -e "\nAdd '$seedfile' to '$api'\n================================\n"
        $includes_dir/osmosis/bin/osmosis --read-xml file="$seedfile" --write-apidb  database="$api" user="$dbuser" password="$dbpass" validateSchemaVersion=no
    done
    for snapshot in $dbname_pgs_prod $dbname_pgs_test $dbname_pgs_dev;
    do
        echo -e "\nAdd '$seedfile' to '$snapshot'\n================================\n"
        $includes_dir/osmosis/bin/osmosis --read-xml file="$seedfile" --write-pgsql  database="$snapshot" user="$dbuser" password="$dbpass"
    done
fi


# Postgres stuff
# build install SQL from custom code
echo -e "\nCompile custom SQL into single file\n================================\n"
cd $script_dir/sql_scripts
./compileSql_mac.sh
for db in "$dbname_api_prod|$dbname_pgs_prod" "$dbname_api_test|$dbname_pgs_test" "$dbname_api_dev|$dbname_pgs_dev";
do
    echo -e "\nCompile custom SQL into single file\n================================\n"
    IFS="|" && dbs=($db)
    api=${dbs[0]}
    snapshot=${dbs[1]}
    echo -e "\nAdd custom SQL to '$api'\n================================\n"
    sed -e "s/{{owner}}/$dbuser/g" -e "s/{{snapshot}}/$snapshot/g" api_compiled.sql | psql -d $api -U $dbuser -f -
    echo -e "\nAdd custom SQL to '$snapshot'\n================================\n"
     sed -e "s/{{owner}}/$dbuser/g" -e "s/{{api}}/$api/g"  pgs_compiled.sql | psql -d $snapshot -U $dbuser -f -
done

rm *_compiled.sql
echo -e "\nDone!\n================================\n"
