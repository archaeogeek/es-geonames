#/bin/bash

REGION=GB
CONTAINER=elasticsearch
ESVERSION=6.4.2

echo "Starting Docker container and data volume..."
sudo docker run -d -p 9200:9200 -v $PWD/geonames_index/:/usr/share/elasticsearch/data elasticsearch:$ESVERSION

echo "Downloading Geonames gazetteer..."
wget http://download.geonames.org/export/dump/$REGION.zip
echo "Unpacking Geonames gazetteer..."
unzip $REGION.zip

echo "Creating mappings for the fields in the Geonames index..."
curl -XPUT '${CONTAINER}:9200/geonames' -H 'Content-Type: application/json' -d @geonames_mapping.json

echo "Loading gazetteer into Elasticsearch..."
python geonames_elasticsearch_loader.py

echo "Done"
