#!/bin/bash

base="data/congress/100/bills/hconres"

echo '<?xml version="1.0" encoding="UTF-8"?>' > output.xml
echo '<add allowDups="true">' >> output.xml

for dir in $(ls $base); do
    ./parse.pl "$base/$dir/data.json" >> output.xml
done

echo '</add>' >> output.xml
echo '<xml>' >> output.xml
