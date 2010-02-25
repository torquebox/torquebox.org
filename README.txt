
To deploy to staging
  rsync -rv ./_site/ torquebox.org:/var/www/domains/torquebox.org/staging/htdocs/

To deploy to production
  rsync -rv ./_site/ torquebox.org:/var/www/domains/torquebox.org/www/htdocs/
