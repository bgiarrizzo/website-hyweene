#!/bin/bash

BIN_FOLDER=$(pwd)/bin/smolweb-validator
REPORTS_FOLDER=$(pwd)/reports/smolweb
FIND_CMD=$(command -v gfind || command -v find)
PAGES_TO_VALIDATE=$($FIND_CMD build -type f -name "index.html" | sed "s#build/##g" |sed "s#/index.html##g" | sed "s/index.html/homepage/g")

rm -rf ${REPORTS_FOLDER}

echo "Running smolweb-validator on local server..."
echo "Reports will be saved in ${REPORTS_FOLDER}"

cd ${BIN_FOLDER}

for PAGE in $PAGES_TO_VALIDATE; do
    echo -e "\n -> Validating page: http://localhost:8000/${PAGE} ..."
    if [ "${PAGE}" == "homepage" ]; then
        PAGE=""
    fi
    mkdir -p ${REPORTS_FOLDER}/${PAGE}
    echo "report" > ${REPORTS_FOLDER}/${PAGE}/report.txt
    ./smolweb-validate http://localhost:8000/${PAGE} > ${REPORTS_FOLDER}/${PAGE}/report.txt
done
