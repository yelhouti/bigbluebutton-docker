#!/usr/bin/env bash
# replace "(\$\{.*?):-.*?(\})" with "$1$2" as long as this is not fixed: https://github.com/kubernetes/kompose/issues/1314
export $(cat .env | sed 's/#.*//g' | grep -v "WELCOME_FOOTER" | grep -v "WELCOME_MESSAGE" | xargs)
mkdir -p charts/bigbluebutton/templates/
cd charts/bigbluebutton/templates/
ls ../../../docker-compose.* | xargs -I {} kompose -f {} convert
