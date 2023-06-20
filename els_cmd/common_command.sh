curl -XGET 127.0.0.1:9200

curl -XPUT 127.0.0.1:9200/movies -d '{"mappings": {"properties": {"year": {"type": "date"}}}'


curl -XPUT 127.0.0.1:9200/movies/_doc/109487?pretty  -d '{"genre": ["IMAX", "Sci-Fi"], "title": "Intersellar", "year": 2014}'

 curl -XPUT 127.0.0.1:9200/movies -d '
 {
    "mappings": {
        "properties": {
            "year": {"type": "date"}
        }
    }
}'

curl -XGET 127.0.0.1:9200/movies/_mapping
curl -XGET 127.0.0.1:9200/movies/_search?pretty

# Index data to Elasticsearch
curl -H "Content-Type: application/json" -XPUT '127.0.0.1:9200/shakespeare/_bulk' --data-binary @shakespeare_8.0.json

curl -XPUT 127.0.0.1:9200/movies/_doc/109487?pretty -d '{"genre" : ["IMAX", "Sci-Fi"], "title": "interstellar foo", "year": 2014 }'

curl -XPUT 127.0.0.1:9200/movies/_doc/109487?pretty -d '{"doc": {"title": "interstellar"}}'
curl -XGET 127.0.0.1:9200/movies/_search?q=Dark

#optimistic concurrency retry. retry on conflict to _seq_no and _primary_term
#how to update

curl -XPUT "127.0.0.1:9200/movies/_doc/109487?if_seq_no=7&if_primary_term" -d '{"genre" : ["IMAX", "Sci-Fi"], "title": "interstellar foo", "year": 2014 }'
curl -XPOST "127.0.0.1:9200/movies/_update/109487?retry_on_conflict=5" -d '{"genre" : ["IMAX", "Sci-Fi"], "title": "interstellar foo", "year": 2014 }'


curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '{ "query": {"match": {"title": "Star Trek"} }}'

curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '{ "query": {"match_phrase": {"genre": "sci"} }}'


curl -XPUT 127.0.0.1:9200/movies -d '
{
    "mappings": {
        "properties": {
            "id": {"type": "integer"},
            "year": {"type": "date"},
            "genre": {"type": "keyword"},
            "title": {"type": "text", "analyzer": "english"}
        }
    }
}'

/usr/bin/curl -H "Content-Type: application/json" -XPUT '127.0.0.1:9200/_bulk?pretty' --data-binary @movies.json


#parent - child relationships
#example franchise and movies
curl -XPUT 127.0.0.1:9200/series -d '
{
    "mappings": {
        "properties": {
            "film_to_franchise": {
                "type": "join",
                "relations": {"franchise": "film"}
            }
        }
    }
}'


curl -XGET 127.0.0.1:9200/series/_search?pretty -d '
{   
    "query": {
        "has_parent": {
            "parent_type": "franchise",
            "query": {
                "match": {
                    "title": "star wars"
                }
            }
        }
    }
}'


curl -XGET 127.0.0.1:9200/series/_search?pretty -d '
{   
    "query": {
        "has_child": {
            "type": "film",
            "query": {
                "match": {
                    "title": "The Force Awakens"
                }
            }
        }
    }
}'