curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query":{
        "bool": {
            "must": {"term": {"title": "trek"}},
            "filter": {"range": {"year": {"gte": 2010}}}
        }
    }
}'

curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query":{
        "match": {
            "title": "star wars"
        }
    }
}'


curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query":{
        "match_phrase": {
            "title": "star wars"
        }
    }
}'

curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query":{
        "match_phrase": {
            "title": {"query": "star beyond", "slop": 1}
        }
    }
}'

#search for "Star Wars" movies released after 1980 
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query":{
        "bool": {
            "must": {"match_phrase": {"title": "Star Wars"}},
            "filter": {"range": {"year": {"gt": 1980}}}
        }
    }
}'

#pagination
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "from": 2,
    "size": 2,
    "query": {"match": {"genre": "Sci-Fi"}}
}'

curl -XGET "127.0.0.1:9200/movies/_search?size=2&from=3&pretty"

#sorting
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "from": 2,
    "size": 2,
    "query": {"match": {"genre": "Sci-Fi"}}
}'
#walk around for sorting text fields
# create mapping of the text filed and text (to be analysed by ELS) as a raw field of the text field as keyword type
Example:
curl -XPUT 127.0.0.1:9200/movies/ -d '
{
    "mappings": {
        "properties" : {
            "title": {
                "type": "text",
                "fields": {
                    "raw": {
                        "type": "keyword"
                    }
                }
            }
        }
    }
}'

curl -XPUT  '127.0.0.1:9200/_bulk' --data-binary @movies.json

#filter
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
    "query": {
        "bool": {
            "must": {"match": {"genre": "Sci-Fi"}},
            "must_not": {"match": {"title": "trek"}},
            "filter": {"range": {"year": {"gte": 2010, "lt": 2015}}}
        }
    }
}'

#search fopr science fiction movies before 1960, sorted by title
curl -XGET "127.0.0.1:9200/movies/_search?sort=title.raw&pretty" -d '
{
    "query": {
        "bool": {
            "must": {"match": {"genre": "Sci-Fi"}},
            "filter": {"range": {"year": {"lt": 1960}}}
        }
    }
}'

#fuzzy query
curl -XGET "127.0.0.1:9200/movies/_search?pretty" -d '
{
    "query": {
        "fuzzy": {
            "title": {"value": "intersteller", "fuzziness": 1}
        }
    }
}'


#prefix query
curl -XGET "127.0.0.1:9200/movies/_search?pretty" -d '
{
    "query": {
        "prefix": {
            "year": "201"
        }
    }
}'

#wildcard query 
curl -XGET "127.0.0.1:9200/movies/_search?pretty" -d '
{
    "query": {
        "wildcard": {
            "year": "1*"
        }
    }
}'



curl -XPUT 127.0.0.1:9200/movies/ -d '
{
    "mappings": {
        "properties" : {
            "year": {"type": "text"}
        }
    }
}'

#Edge Ngram 
curl -XPUT 127.0.0.1:9200/movies/ -d '
{
    "settings": {
        "analysis": {
            "filter": {
                "autocomplete_filter": {
                    "type": "edge_ngram",
                    "min_gram": 1,
                    "max_gram": 20
                }
            }
        },
        "analyzer": {
            "autocomplete": {
                "type": "custom",
                "tokenizer": "standard",
                "filter": {
                    "lowercase", 
                    "autocomplete_filter"
                }
            }
        }
    }
}'