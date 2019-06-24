#!/bin/bash

echo 'Set proxy'
export http_proxy=http://127.0.0.1:1080/
export https_proxy=http://127.0.0.1:1080/

rm /Users/double/flutter/sdk/flutter/bin/cache/lockfile
echo 'OK'
