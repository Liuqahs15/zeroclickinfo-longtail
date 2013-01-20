#!/bin/bash

govtrack="http://www.govtrack.us"
base="data/congress/100/bills/hconres/"
resource="$govtrack/$base"

for congress in $(curl "$resource" 2>/dev/null \
                | sed -ne 's,.\+href="\(hconres[0-9]\+\)\/".*,\1,p'); do
  mkdir "$base$congress"
  curl "$resource$congress""/data.json" > "$base/$congress""/data.json"
done;
