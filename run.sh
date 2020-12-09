#!/bin/sh
docker run --rm --name clinithink -ti -v clinithink:/home/clinithink/.wine -p 49120:49120/tcp clinithink
