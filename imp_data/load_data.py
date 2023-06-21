import csv
import re
csv_file = open("data/ml-latest-small/movies.csv", "r")
reader = csv.DictReader(csv_file)

for movie in reader:
    print(movie)