#/bin/bash

REGION=GB
ESURL=http://localhost:9200
ESVERSION=6.4.2
PYTHONEXE=python3

echo "Starting Docker container and data volume..."
docker run --name es-geonames -d -p 9200:9200 -v $PWD/geonames_index/:/usr/share/elasticsearch/data elasticsearch:$ESVERSION

#echo "Downloading Geonames gazetteer..."
wget http://download.geonames.org/export/dump/$REGION.zip
echo "Unpacking Geonames gazetteer..."
unzip -o $REGION.zip

until $(curl -sSf -XGET  'http://localhost:9200/_cluster/health?wait_for_status=yellow' > /dev/null); do
	    printf 'not ready, trying again in 10 seconds \n'
	        sleep 10
done

echo "Creating mappings for the fields in the Geonames index..."
curl -XPUT "${ESURL}/geonames" -H 'Content-Type: application/json' -d @geonames_mapping.json

#echo "Loading gazetteer into Elasticsearch..."
#$PYTHONEXE geonames_elasticsearch_loader.py

echo "Done"
