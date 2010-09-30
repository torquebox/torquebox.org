## Now using shared skin!

Requires Awestruct >= 0.1.2

Checkout alongside torquebox.org/ the site-skin/ project:

	git://github.com/projectodd/site-skin.git

Resulting in

	torquebox.org/_ext/...
	site-skin/_ext/...

Then build from within torquebox.org/ as typical.

## To Deploy to Staging

* `rm -rf _site`
* `awestruct -P staging`
* `awestruct -P staging --deploy`

## To Deploy to Production

* `rm -rf _site`
* `awestruct -P production`
* `awestruct -P production --deploy`
