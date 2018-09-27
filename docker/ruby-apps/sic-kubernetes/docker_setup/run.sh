#!/bin/bash
# Ininciar o passenger
/bin/bash -l -c "cd /home/AppCode/APPNAME/ && bundle exec passenger start -p 3000 -e AMBIENTE"