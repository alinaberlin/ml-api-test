#!/bin/bash

docker stop symfony4test database-ml

docker rm symfony4test database-ml

rm -rf ml-api
