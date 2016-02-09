package SonyCameraRemote;
# Sony Camera Remote API - Perl Implementation
# Version 0.1
# Copyright (c) 2016 Patrick Clinger
# Released under the MIT License
#
# https://github.com/pclinger
# http://patrickclinger.com
use strict;
use SonyCameraRemote::Request;
use SonyCameraRemote::Config;
use LWP::UserAgent;
use JSON;
use Data::Dumper;
use Time::HiRes qw(usleep gettimeofday tv_interval);

# Print debug output?
my $DEBUG = 0;

# Create SonyCameraRemote object
#
# @see             #init
# @param \%params  (optional) camera_url, connect_timeout
# @return          SonyCameraRemote object
sub new {
	my $class = shift;
	my $self = {'params' => $_[0] // {}};
	bless($self, ref($class) || $class);

	$self->init;

	return $self;
}

# Called by new when SonyCameraRemote object is created
#
# @exception  Dies if connect timeout (seconds) is reached
# @return     SonyCameraRemote object
sub init {
	my $self   = shift;

	if($self->{'params'}->{'debug'}) {
		$DEBUG = 1;
	}

	debug("Init params are:",$self->{'params'});

	# If a custom camera URL has been passed in, use that
	# Otherwise use our default camera URL
	$self->{'camera_url'} = $self->{'params'}->{'camera_url'}
		// $SonyCameraRemote::Config::DEFAULT_CAMERA_URL;

	# Create JSON and LWP objects for re-using
	$self->{'json'} = new JSON;
	$self->{'ua'}   = new LWP::UserAgent;

	debug("Attempting to connect to camera");
	local $SIG{'ALRM'} = sub { die "Camera connect failed"; };
	my $connect_timeout = $self->{'params'}->{'connect_timeout'}
		// $SonyCameraRemote::Config::CONNECT_TIMEOUT;
	alarm $connect_timeout;
	$self->{'methodTypes'} = $self->getMethodTypes;
	alarm 0;
	debug("Connected!");

	# Get ready to take photos
	$self->request('setCameraFunction',['Remote Shooting']);
	$self->request('startRecMode');

	# Wait until the camera is able to take photos or video
	cameraInit: while(1) {
		foreach my $event ($self->getAvailable('ApiList')) {
			last cameraInit if($event eq 'actTakePicture'
				|| $event eq 'startMovieRec');
		}
		debug("Waiting for camera to be ready");
		usleep(100_000);
	}
}

# Identifies the methods supported by this camera
#
# Also sets $self->{'getEventVersion'} variable to the highest version
# of getEvent supported
#
# @return  \%hash of supported methods as {$endPoint}->{$apiVersion}->{$method}
#         e.g. {'camera'}->{'1.3'}->{'getVersion'} = 1
sub getMethodTypes {
	my $self = shift;

	my $types = {};
	foreach my $endPoint ('camera','avContent') {
		my $req = SonyCameraRemote::Request->new({
			'method'  => 'getMethodTypes',
			'params'  => [''],
			'version' => '1.0',
			'id'      => 1,
		}, $self->getRequestParams($endPoint));
		if($req->fail) {
			die 'Failed call on getMethodTypes: '.$req->errorMessage
				.' (are you connected to the camera\'s wifi?)';
		}
		# endPoint => methodVersion => methodName
		$types->{$endPoint} = {};
		foreach my $result (@{$req->results}) {
			my($method,$param_types,$response_types,$version) = @$result;
			$types->{$endPoint}->{$version} //= {};
			$types->{$endPoint}->{$version}->{$method} = 1;
			# Check for highest supported version of getEvent
			if($method eq 'getEvent' && (!defined $self->{'getEventVersion'}
				|| $self->{'getEventVersion'} < $version)) {
				$self->{'getEventVersion'} = $version;
			}
		}
	}
	return $types;
}

# This is a generic handler for the start of actions that allows for
# changing settings, then waits for the camera to be ready, then performs
# the desired action.
#
# @see     #settings
# @param   \%cameraSettings Settings for the camera to change
# @param   $methodName      API method to call
# @return  SonyCameraRemote::Request object
sub cameraAction {
	my $self     = shift;
	my $settings = (scalar(@_) == 1) ? {} : shift;
	my $methodName   = shift;

	# Set camera settings
	$self->settings($settings);

	# Wait until ready to shoot
	$self->awaitCameraIdle;

	# Perform the action!
	return $self->request($methodName);
}

# Take a picture
#
# @see #cameraAction
sub takePicture {
	return cameraAction(@_,'actTakePicture');
}

# Start continuous shooting
#
# @see #cameraAction
sub startContinuousShooting {
	return cameraAction('startContShooting');
}

# Stop continuous shooting
sub stopContinuousShooting {
	my $self = shift;
	return $self->request('stopContShooting');
}

# Start taking pictures at an interval
#
# @see #cameraAction
sub startIntervalPictures {
	my $self = shift;
	$self->shootMode('intervalstill');
	return cameraAction($self, @_, 'startStillIntervalRec');
}

# Stop taking interval pictures
sub stopIntervalPictures {
	my $self = shift;
	return $self->request('stopStillIntervalRec');
}

# Record a movie
#
# @see #cameraAction
sub startMovie {
	my $self = shift;
	$self->shootMode('movie');
	return cameraAction($self, @_, 'startMovieRec');
}

# Stop recording a movie
sub stopMovie {
	my $self = shift;
	return $self->request('stopMovieRec');
}

# Start recording audio
#
# @see #cameraAction
sub startAudioRecording {
	my $self = shift;
	$self->shootMode('audio');
	return cameraAction($self, @_, 'startAudioRec');
}

# Stop recording audio
sub stopAudioRecording {
	my $self = shift;
	return $self->request('stopAudioRec');
}

# Start loop recording
#
# @see #cameraAction
sub startLoopRecording {
	my $self = shift;
	$self->shootMode('looprec');
	return cameraAction($self, @_, 'startLoopRec');
}

# Stop loop recording
sub stopLoopRecording {
	my $self = shift;
	return $self->request('stopLoopRec');
}

# Wait for the camera to finish taking a photo
sub awaitTakePicture {
	my $self = shift;
	return $self->request('awaitTakePicture');
}

# Takes many different params to change the camera's settings
#
# @param \%settings  key/values to change. Keys allowed are are iso, fNumber,
# shutterSpeed, focusMode, exposureMode, shootMode
sub settings {
	my $self   = shift;
	my $params = shift;

	$self->iso($params->{'iso'}) if(defined $params->{'iso'});

	$self->fNumber($params->{'fNumber'}) if(defined $params->{'fNumber'});

  $self->shutterSpeed($params->{'shutterSpeed'}) if(
		defined $params->{'shutterSpeed'}
	);

	$self->focusMode($params->{'focusMode'}) if(defined $params->{'focusMode'});

	$self->exposureMode($params->{'exposureMode'}) if(
		defined $params->{'exposureMode'}
	);

	$self->shootMode($params->{'shootMode'}) if(defined $params->{'shootMode'});
}

# Wait until the camera is in idle mode
#
# @param $timeout  Number of seconds to wait
# @return          true of camera is idle, false if timed out
sub awaitCameraIdle {
	my $self = shift;
	my $timeout = shift // 0;
	my $time = [gettimeofday];
	while(!$self->cameraIdle) {
		if(tv_interval($time,[gettimeofday]) < $timeout) {
			usleep(50_000);
		}
		last;
	}
	return 1;
}

# Call the getEvent API method and return requested data
#
# No parameter sent will return the full getEvent result
# One parameter will return the \%hash of data from getEvent you request
# Two parameters will return a specific value from the \%hash
#
# @param $configKey  (optional) Corresponds to key found in
# $SonyCameraRemote::Config::getEvent hashref
# @param $getKey     (optional) Corresponds to the key name found in
# the Sony API for the hash related to $configKey
# @return            depending on parameters:
# -The entire getEvent result
# -A single hash from getEvent
# -A single value from a specific hash in getEvent
sub getEvent {
	my $self  = shift;

	my $request = $self->request('getEvent', [JSON::false],
		$self->{'getEventVersion'});

	# No parameter = return all event results
	if(!scalar(@_)) {
		return $request->result;
	}

	# Specific event data wanted
	my $event = $request->result->[$SonyCameraRemote::Config::getEvent{shift()}];

	# Return either a specific value from the event
	# or all values from the event
	return (scalar(@_))
	 	? $event->{$_[0]}
		: $event;
}

# Check if the cameraStatus from getEvent is set to 'IDLE'
#
# @return  true if idle, false if not
sub cameraIdle {
	my $self = shift;
	return ($self->getEvent('cameraStatus','cameraStatus') eq 'IDLE')
		? 1
		: 0;
}

# Acts like pressing the shutter button half way down
#
# @return  SonyCameraRemote::Request object
sub startHalfPressShutter {
	my $self = shift;
	return $self->request('actHalfPressShutter');
}

# Call this to stop 'pressing down' the shutter button half way
#
# @return  SonyCameraRemote::Request object
sub stopHalfPressShutter {
	my $self = shift;
	return $self->request('cancelHalfPressShutter');
}

# get and/or set ISO
#
# @see           #getSetAvailable
# @param $value  (optional)
# @return        current value
sub iso {
	my $self = shift;
	return $self->getSetAvailable('IsoSpeedRate',@_);
}

# get and/or set fNumber
#
# @see           #getSetAvailable
# @param $value  (optional)
# @return        current value
sub fNumber {
	my $self = shift;
	return $self->getSetAvailable('FNumber',@_);
}

# get and/or set shutter speed
#
# @see           #getSetAvailable
# @param $value  (optional)
# @return        current value
sub shutterSpeed {
	my $self = shift;
	return $self->getSetAvailable('ShutterSpeed',@_);
}

# get and/or set focus mode
#
# @see           #getSetAvailable
# @param $value  (optional)
# @return        current value
sub focusMode {
	my $self = shift;
	return $self->getSetAvailable('FocusMode',@_);
}

# get or set exposure mode
#
# only available to cameras that set this digitally
#
# @param $value  (optional)
# @return        current value
sub exposureMode {
	my $self = shift;
	return $self->getSetAvailable('ExposureMode',@_);
}

# get or set the shoot mode
#
# @see           #getSetAvailable
# @param $value  (optional)
# @return        current value
sub shootMode {
	my $self = shift;
	return $self->getSetAvailable('ShootMode',@_);
}

# get or set the continous shooting mode
#
# @see           #getSetAvailable
# @param $value  (optional)
# @return        current value
sub continuousShootingMode {
	my $self = shift;
	return $self->getSetAvailable('ContShootMode',@_);
}

# get or set the self-timer for photos
#
# @see             #getSetAvailable
# @param   $value  (optional)
# @return          current value
sub timer {
	my $self = shift;
	return $self->getSetAvailable('SelfTimer',@_);
}

# Checks "getAvailable[method]" function, sets new value,
# and returns current value
#
# @param   $methodExtension  which method to get/set
# @param   $value            (optional) value to set
# @return                    current value of $methodExtension
sub getSetAvailable {
	my $self = shift;
	my $methodExtension = ucfirst(shift);

	my $request = $self->request('getAvailable' . $methodExtension);
	my $current = $request->result->[0];
	my %available = map { $_ => 1 } @{$request->result->[1]};

	# If we pass in a parameter, it is to change the current value
	if(scalar(@_) && $_[0] ne $current) {
		if(defined $available{$_[0]}
			&& $self->request('set' . $methodExtension,["$_[0]"])->success) {
				$current = $_[0];
		} else {
			return 0;
		}
	}

	return $current;
}

# Get currently available values for different methods
#
# @param   $methodExtension  which method to get
# @return                    array of available values for $methodExtension
sub getAvailable {
	my $self = shift;
	my $methodExtension = ucfirst(shift);

	my $request = $self->request('getAvailable' . $methodExtension);
	if($request->fail) {
		die $request->errorMessage;
	}
	return (defined $request->result->[1])
		? @{$request->result->[1]}
		: @{$request->result->[0]};
}

# Get supported values for different methods (may not be available currently)
#
# @param   $methodExtension  which method to get
# @return                    array of supported values for $methodExtension
sub getSupported {
	my $self = shift;
	my $methodExtension = ucfirst(shift);

	my $request = $self->request('getSupported' . $methodExtension);
	return $request->result->[0];
}

# Send a request to the camera
#
# @see                SonyCameraRemote::Request::new
# @param   $method    The API call to make
# @param   \@params   Params to send to the camera
# @param   $version   Which version of $method to call
# @param   $id        Numeric identifier that the camera will return back after
# @param   $endPoint  Camera API end point (camera, system, or avContent)
# @return             SonyCameraRemote::Request object
sub request {
	my $self = shift;

	# Data to send to the camera
	my $request = {
		'method'  => shift,
		'params'  => shift // [],
		'version' => shift // '1.0',
		'id'      => shift // 1
	};

	# Things the request object will want to have access to
	# but are not part of the JSON request data
	my $params = $self->getRequestParams(@_);

	if(!$self->isMethodSupported($params->{'endPoint'}
		,$request->{'method'}, $request->{'version'})) {
		die 'The called method is not supported by this camera.';
		return $self;
	}

	return SonyCameraRemote::Request->new($request, $params);
}

# Get params needed to be sent to SonyCameraRemote::Request object
#
# @param   $endPoint  Camera API end point (camera, system, or avContent)
# @return             \%hash for SonyCameraRemote::Request::new
sub getRequestParams {
	my $self = shift;
	return {
		'json'        => $self->{'json'},
		'ua'          => $self->{'ua'},
		'methodTypes' => $self->{'methodTypes'},
		'endPoint'    => shift // 'camera',
		'camera_url'  => $self->{'camera_url'}
	};
}

# Check if a method is supported by this camera
#
# At startup we check all available camera/avContent methods
# That this camera supports.  If we are attempting to use
# a function that is not available throw an error
#
# @param   $endPoint  Camera API end point (camera, system, or avContent)
# @param   $method    The API call we want
# @param   $version   Which version of $method we want
sub isMethodSupported {
	my $self     = shift;
	my $endPoint = shift;
	my $method   = shift;
	my $version  = shift;
	# We must allow getMethodTypes requests for populating our known methods
	if(!defined $self->{'methodTypes'}->{$endPoint}->{$version}->{$method}) {
			return 0;
	}
	return 1;
}

# Debug logging
#
# @param  Any object or string
sub debug {
	if($DEBUG) {
		foreach (@_) {
			if(ref($_)){
				print Dumper($_);
			} else {
				print $_,$/;
			}
		}
		print $/;
	}
}

1;
