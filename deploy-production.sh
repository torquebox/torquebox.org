#!/bin/sh

rm -Rf _site _tmp
../awestruct/bin/awestruct --url http://torquebox.org --force
rsync -rv --delete ./_site/ torquebox.org:/var/www/domains/torquebox.org/www/htdocs/
