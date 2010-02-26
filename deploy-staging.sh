#!/bin/sh

rsync -rv --delete ./_site/ torquebox.org:/var/www/domains/torquebox.org/staging/htdocs/
