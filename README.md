# SonyCameraRemote
Sony Camera Remote API - Perl Implementation

Connect and control Sony cameras using the [Sony Camera Remote API](https://developer.sony.com/downloads/camera-file/sony-camera-remote-api-beta-sdk/).  Includes numerous helper functions to make interacting with the API easier.

# Synopsis

```perl
use SonyCameraRemote;
my $camera = new SonyCameraRemote;

# Take a picture
$camera->takePicture;

# Change some camera settings, then take a picture
$camera->takePicture({
  iso          => 3200,
  fNumber      => 2.8,
  shutterSpeed => '1/100'
});

# Record a movie
$camera->startMovie;
sleep(5);
$camera->stopMovie;

# Get / Set values
print $camera->iso, "\n";
print $camera->iso(6400), "\n";

print $camera->fNumber, "\n";
print $camera->fNumber(2.8), "\n";

# Grab result from getEvent API call
my $result = $camera->getEvent;

# Grab specific event from getEvent
my $event = $camera->getEvent('focusMode');

# Grab a value from a specific event from getEvent
my $event = $camera->getEvent('focusMode','currentFocusMode');

# Send an API call to the camera instead of using helper functions
my $request = $camera->request('getAvailableIsoSpeedRate');
if(!$request->success) {
  die $request->errorMessage;
}
printf "Available ISO: %s\n", join(', ',@{$request->result->[1]});
```

# Requirements

__Perl Modules__

LWP::UserAgent

Time::HiRes

__Smart Remote Control__

Install the latest version of the Sony "Smart Remote Control" app on your camera.  You might need to update your camera's firmware first.

# Getting Started

Open the Smart Remote Control application on your camera, after which your camera will create a wifi network.  Connect your computer to the camera's wifi network, after which you can use this library to issue commands to the camera.

# Functions

The functions are fairly well documented in SonyCameraRemote.pm and SonyCameraRemote/Request.pm, and there are some examples in the "examples" folder.

# License

MIT License.  Enjoy!
