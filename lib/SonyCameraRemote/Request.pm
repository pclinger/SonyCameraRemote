package SonyCameraRemote::Request;
use strict;

# Sends a request to the sony camera
#
# @param  \%request  method, params, version, id for API call
# @param  \%params   helper params from #getRequestParams
# @return            SonyCameraRemote::Request object
sub new {
	my $class = shift;
  my $self   = {
		'request' => shift(),
		'params'  => shift()
	};

	bless($self, ref($class) || $class);

	$self->{'response'}   = {'error' => 'Request not yet sent'};

  if(!defined $SonyCameraRemote::Config::endPoint{$self
		->{'params'}->{'endPoint'}}) {
    die 'Invalid endPoint. Expected: '
			.join ', ',keys %SonyCameraRemote::Config::endPoint;
  }

	return $self->send;
}

# Send the request to the camera
#
# @see     #new which calls this function
# @return  SonyCameraRemote::Request object
sub send {
  my $self   = shift;

	# Determine URL to camera for the request
  my $url = $self->{'params'}->{'camera_url'}
		. $self->{'params'}->{'endPoint'};

	eval {
		# Send the request
		debug("POST $url ($self->{request}->{method})");
		my $request = HTTP::Request->new('POST', $url);
		$request->content($self->{'params'}->{'json'}->utf8->encode($self->{'request'}));
		my $response = $self->{'params'}->{'ua'}->request($request);
		# JSON response from the camera

		$self->{'response'}
			= $self->{'params'}->{'json'}->utf8->decode($response->decoded_content);
	};
	if($@) {
		$self->error($@);
		debug("Error:",$@);
	} else {
		debug("Request succeeded");
	}

  return $self;
}

# Returns whether the request was successful or not
#
# @return  true/false
sub success {
  my $self = shift;
	return !$self->fail;
}

# Returns whether the request failed
#
# @return  true/false
sub fail {
	my $self = shift;
	return (defined $self->{'response'}->{'error'}) ? 1 : 0;
}

# Returns the error array ref [error code, error reason]
#
# @return  [$error_code, $error_reason]
sub error {
	my $self = shift;
	if(scalar(@_)) {
		$self->{'response'}->{'error'} = [1,shift()];
	}
	return $self->{'response'}->{'error'} // [0,'OK'];
}

# Get the error message if the request failed
#
# @return  $errorMessage  String with the reason the request failed
sub errorMessage {
	my $self = shift;
	return $self->error->[1];
}

# Returns the full JSON response from the camera
#
# @return  \%response
sub response {
	my $self = shift;
	return $self->{'response'} // {};
}

# Just get the result from the response
#
# @return  \@result
sub result {
	my $self = shift;
	return $self->{'response'}->{'result'};
}

# For methods that return results instead of result
#
# @return  \@results
sub results {
	my $self = shift;
	return $self->{'response'}->{'results'};
}

# Windows only: after taking a picture, display in browser
sub viewInBrowser {
	my $self = shift;
	my $url = $self->url;
	system("explorer \"$url\"");

}

# Helper function that returns a single URL from the result
# after taking a photo
#
# @return  $url  URL to the photo just taken from this request
sub url {
	my $self = shift;
	if($self->success) {
		return $self->result->[0]->[0];
	} else {
		return 0;
	}
}

# Send debug upstream
# @param  Any object or string
sub debug {
	SonyCameraRemote::debug(@_);
}

1;
