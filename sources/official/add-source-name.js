// wb ar add-source-name.js Q97131330-4C4A7FD7-C10F-4D38-B5FD-03F6EADF409A "Vassilios Demetriades" "Deputy Minister of Shipping"

const fs = require('fs');

let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (guid, name, position, url) => ({
    guid,
    snaks: {
      P854: url,
      P813: new Date().toISOString().split('T')[0],
      P407: meta.source.lang.wikidata,
      P1810: name, // named as (Person)
      P1932: position, //stated as (Position)
    }
})
