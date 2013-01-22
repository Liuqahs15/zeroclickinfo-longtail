#!/bin/bash

if [ ! -d data/congress ]; then
  mkdir -p data/congress
fi

govtrack="http://www.govtrack.us"
base="data/congress/"
resource="$govtrack/$base"

for congress in $(curl "$resource" 2>/dev/null \
                | sed -ne 's,.\+href="\([0-9]\+\)\/".*,\1,p'); do
  base="data/congress/$congress/bills/hconres/"
  for bill_type in $(curl "$govtrack/$base" 2>/dev/null \
                  | sed -ne 's,.\+href="\(hconres[0-9]\+\)\/".*,\1,p'); do
    mkdir -p "$base$bill_type"
    curl "$govtrack/$base$bill_type/data.json" > "$base/$bill_type/data.json"
  done;
done;

