#!/bin/bash

# Search for "some.example.org" inside /etc/hosts, swallow errors
# print results to the output and save to /tmp/hosts-results.txt

# Swallowing the errors and output - "> /dev/null 2>&1" first redirects
# stdout to /dev/null and then redirects stderr there as well.
# This effectively silences all output (regular or error) from the wget command.
grep some.example.org /etc/hosts 2>&1 | tee /tmp/hosts-results.txt
if [ "${PIPESTATUS[0]}" -ne "0" ]; then
  # The grep command failed to find "some.example.org" in /etc/hosts file
  echo "I don't see the IP address of some.example.org in /etc/hosts"
  exit 2
fi

WEB_SERVER=some-test-serv-in-the-middle-of-nowhere.org
curl -# -f -u ${USERNAME}:${PASSWORD} http://${WEB_SERVER}/ | grep "TestMessage"
RESULTS=( "${PIPESTATUS[@]}" )
if [ "${RESULTS[0]}" -eq "22" ]; then
  # curl returned 22, indicating some error above 400,
  # for example: 404 Not Found, 401 Unauthorized, etc.
  echo "Invalid credentials"
  exit 1
fi

# PIPESTATUS was overwritten, but we can still inspect RESULTS
if [ "${RESULTS[1]}" -eq "0" ]; then
  echo "Grep succeeded"
  echo "Web server reported TestMessage"
else
  echo "Web server didn't report TestMessage"
fi
