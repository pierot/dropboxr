Dropbox Photo Gallery

It pulls the albums (directories) from your Dropbox 'Photo' directory and generates a web-gallery.
All images are cached on Amazon S3.

Resque
------
Resque is used to speed up the building and caching of photo galleries. Resque requires Redis which you can install for yourself or use a hosted solution like redistogo.com. They offer a free pack which is perfect.
