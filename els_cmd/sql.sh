curl -XGET "127.0.0.1:9200/_sql?format=txt" -d '
{"query": "DESCRIBE movies"}'