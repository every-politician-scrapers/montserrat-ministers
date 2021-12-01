#!/bin/bash

rm -rf mirror
mkdir mirror
cd mirror

CURLOPTS='-L -c /tmp/cookies -A eps/1.2'

curl $CURLOPTS -o ministries.index $(jq -r .source.url ../meta.json)

for url in $(nokogiri -e "puts @doc.css('h2 a/@href').map(&:text)" ministries.index); do
  echo $url
  curl $CURLOPTS -o $(basename $url).html $url
done

cd -
