#!/usr/bin/perl
# These examples are for interacting with the camera directly instead of
# through any helper functions from this library
use strict;
use lib '../lib';
use SonyCameraRemote;
use Data::Dumper;

# Create camera object
my $camera = new SonyCameraRemote;

# Send the request to the camera, returns SonyCameraRemote::Request object
my $request = $camera->request('getAvailableApiList');

# Check if the request failed
if($request->fail) {
  die $request->errorMessage;
}

# Print the response data from the camera
print Dumper($request->response);

# Other examples:
# Set ISO
$request = $camera->request('setIsoSpeedRate',['400']);
print Dumper($request->response);

# method (getEvent), params, API version of getEvent
$request = $camera->request('getEvent',[JSON::false],'1.3');
print Dumper($request->response);
