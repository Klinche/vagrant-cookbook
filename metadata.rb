maintainer       'Klinche, Inc.'
maintainer_email 'dbrooks@klinche.com'
name             'Vagrant'
license          'All rights reserved'
description      'Installs/Configures Klinche in a Vagrant Environment.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

recipe 'Vagrant::ruby', 'Sets up ruby for vagrant'
recipe 'Vagrant::mysql', 'Sets up mysql for vagrant.'
recipe 'Vagrant::codeception', 'Sets up codeception for vagrant'

depends 'swap'
depends 'supervisor'
depends 'php'
depends 'apt'
