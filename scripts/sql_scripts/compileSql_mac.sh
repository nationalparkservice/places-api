inputFiles=('sequence' 'type' 'func' 'view')

find . -type d -print0 | while IFS= read -r -d '' dir
do
  if [ "$dir" != "." ];
  then
    outputFile=$dir"_compiled.sql"
    echo "outputFile: "$outputFile

    echo "-- Compiled on "`date`  > $outputFile
    echo "" >> $outputFile

    for i in "${inputFiles[@]}"
    do
      echo "-- "$i"s --" >> $outputFile
      query=$dir/$i*.sql
      echo "  query: "$query
        for file in `ls $query`; do
          echo "-- "$file" --" >> $outputFile
          echo "    file: "$file
          sed -e 's/OWNER TO postgres/OWNER TO {{owner}}/g' \
          -e 's/OWNER TO osm/OWNER TO {{owner}}/g' \
          -e 's/dbname=poi_pgs user=postgres/dbname={{snapshot}} user={{owner}}/g' < $file >> $outputFile
        done
    done
  fi
done
