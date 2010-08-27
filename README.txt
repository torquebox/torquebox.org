
To deploy to staging
  rsync -rvi ./_site/ torquebox.org:/var/www/domains/torquebox.org/staging/htdocs/

To deploy to production
  rsync -rvi ./_site/ torquebox.org:/var/www/domains/torquebox.org/www/htdocs/
