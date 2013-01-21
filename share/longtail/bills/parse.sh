#!/bin/bash

base="data/congress"

echo '<?xml version="1.0" encoding="UTF-8"?>' > output.xml
echo '<add allowDups="true">' >> output.xml

for f in $(find -name data.json); do
  ./parse.pl "$f" >> output.xml
done

echo '</add>' >> output.xml
echo '</xml>' >> output.xml
