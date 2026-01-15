#!/bin/bash

# Check the endpoint returns 200 status code and
# throw an error if it does not.
WEB_SERVER=some-test-serv-in-the-middle-of-nowhere.org
node -e "require('http').get('http://${WEB_SERVER}/', (res) => { if (res.statusCode !== 200) throw new Error(res.statusCode) })"
