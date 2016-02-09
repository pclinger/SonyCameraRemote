#!/usr/bin/perl
# This example shows how to take a picture,
# change settings and take a picture with one functio call,
# or change settings individually and then take a picture
use strict;
use lib '../lib';
use SonyCameraRemote;

my $camera = new SonyCameraRemote;

# Take a picture
$camera->takePicture;

# Take a picture but change a few settings first
# See 'sub settings' in SonyCameraRemote.pm for a full list
# of what settings we can change with this function
$camera->takePicture({
  'fNumber'      => 2.8,
  'shutterSpeed' => '1/100',
  'iso'          => 6400,
});

# Or change settings one by one
$camera->fNumber('2.8');
$camera->iso(3200);
$camera->shutterSpeed('1/100');
$camera->takePicture;
