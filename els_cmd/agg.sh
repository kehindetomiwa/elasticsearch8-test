curl -XGET "127.0.0.1:9200/ratings/_search?size=0&pretty" -d '
{
    "aggs": {
        "ratings": {
            "terms": {
                "field": "rating"
            }
        }
    }
}'


curl -XGET "127.0.0.1:9200/ratings/_search?size=0&pretty" -d '
{
    "query": {
        "match": {
            "rating": 5.0
        }
    },
    "aggs": {
        "ratings": {
            "terms": {
                "field": "rating"
            }
        }
    }
}'


curl -XGET "127.0.0.1:9200/ratings/_search?size=0&pretty" -d '
{
    "aggs": {
        "ratings": {
            "terms": {
                "field": "rating"
            }
        }
    },
    "query": {
        "match": {
            "rating": 5.0
        }
    }
}'


curl -XGET "127.0.0.1:9200/ratings/_search?size=0&pretty" -d '
{
    "query": {
        "match_phrase": {
            "title": "Star Wars Episode IV"
        }
    },
    "aggs": {
        "avg_rating": {
            "avg": {
                "field": "rating"
            }
        }
    }
}'


curl -XGET "127.0.0.1:9200/ratings/_search?size=0&pretty" -d '
{
    "aggs": {
        "name_of_agg": {
            "histogram": {
                "field": "rating",
                "interval": 1.0
            }
        }
    }
}'


curl -XGET "127.0.0.1:9200/movies/_search?size=0&pretty" -d '
{
    "aggs": {
        "histogram_by_year": {
            "histogram": {
                "field": "year",
                "interval": 10
            }
        }
    }
}'