#!/usr/bin/perl
# Create a timelapse video from postview images,
# This example uses Time::HiRes, LWP::Simple, and ffmpeg for encoding
##########
# CONFIG #
##########
use strict;
# Where to save pictures
my $saveDir = '../timelapse-storage';
# How many pictures to take
my $numberOfPictures = 3;
# Delay between photos (seconds or portion of seconds)
my $delayBetweenPictures = 5;
# Any camera settings you want to use
my $cameraSettings = {
  'iso'          => 6400,
  'fNumber'      => 2.8,
  'shutterSpeed' => '1/100',
};
# Framerate for our timelapse video
my $fps = 30;
#################
# END OF CONFIG #
#################
mkdir($saveDir) if(!-d $saveDir);
use lib '../lib';
use SonyCameraRemote;
use Time::HiRes qw(usleep gettimeofday tv_interval);
use LWP::Simple qw(getstore);
my $camera = new SonyCameraRemote;

# Apply our settings
$camera->settings($cameraSettings);

# Track the URLs for photos to download after
my @photoUrls = ();
for(1 .. $numberOfPictures) {
  print "Taking photo $_/$numberOfPictures\n";
  my $time = [gettimeofday];
  $camera->takePicture;
  my $result = $camera->awaitTakePicture;

  push(@photoUrls, $result->url);

  # Sleep for any remaining time left (using Time::HiRes for accuracy)
  my $diff = $delayBetweenPictures - tv_interval($time,[gettimeofday]);
  if($diff > 0) {
    usleep($diff*1000000);
  }
}

print "Downloading photos for processing\n";
my $count = 1;
foreach my $url (@photoUrls) {
  print "$count/$numberOfPictures\n";
  my $filename = sprintf("photo-%05d.jpg", $count);
  getstore($url,"$saveDir/$filename");
  $count++;
}

print "Encoding video (this may take a while)\n";
system("ffmpeg -r $fps -i $saveDir/photo-%05d.jpg -vcodec libx264 -pix_fmt yuv420p $saveDir/timelapse.mp4");
print "Video encoded to: $saveDir/timelapse.mp4\n";

foreach my $count (1 .. $numberOfPictures) {
  my $filename = sprintf("photo-%05d.jpg", $count);
  unlink("$saveDir/$filename");
}
