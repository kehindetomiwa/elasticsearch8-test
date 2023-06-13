curl -XGET 127.0.0.1:9200

curl -XPUT 127.0.0.1:9200/movies -d '{"mappings": {"properties": {"year": {"type": "date"}}}'


curl -XPUT 127.0.0.1:9200/movies/_doc/109487 -d '{"genre": ["IMAX", "Sci-Fi"], "title": "Intersellar", "year": 2014}'

