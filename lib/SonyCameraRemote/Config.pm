package SonyCameraRemote::Config;
use strict;

our $CAMERA_IDLE_TIMEOUT = 10;
our $CONNECT_TIMEOUT     = 10;
our $DEFAULT_CAMERA_URL  = 'http://192.168.122.1:8080/sony/';

our %shootMode = (
  'still' => 'Still image shoot mode',
  'movie' => 'Movie shoot mode',
  'audio' => 'Audio shoot mode',
  'intervalstill' => 'Interval still shoot mode',
  'looprec' => 'Loop recording shoot mode',
);

our %liveviewSize = (
  'L' => 'XGA size scale (the size varies depending on the camera models, and some camera models change the liveview quality instead of making the size larger.)',
  'M' => 'VGA size scale (the size varies depending on the camera models)',
);

our %zoomDirection = (
  'in' => 'Zoom-In',
  'out' => 'Zoom-Out',
);

our %zoomMovement = (
  'start' => 'Long push',
  'stop' => 'Stop',
  '1shot' => 'Short push',
);

our %zoomSetting = (
  'Optical Zoom Only' => 'Optical zoom only',
  'Smart Zoom Only' => 'Smart zoom only',
  'On:Clear Image Zoom' => 'On:Clear Image Zoom',
);

our %touchAfPosition = (
  'Touch' => 'Focus on around touch area',
  'Wide' => 'Focus on over a wide range including touch area',
);

our %trackingFocusSetting = (
  'Off' => 'Does not track a subject to be focused on',
  'On' => 'Tracks a subject to be focused on',
);

our %trackingFocusStatus = (
  'Tracking' => 'Tracking a subject',
  'Not Tracking' => 'Not tracking a subject',
);

our %continuousShootingMode = (
  'Single' => 'Single shooting',
  'Continuous' => 'Continuous shooting',
  'Spd Priority Cont.' => 'Speed priority continuous shooing',
  'Burst' => 'Burst shooting',
  'MotionShot' => 'MotionShot',
);

our %continuousShootingSpeed = (
  'Hi' => 'Hi',
  'Low' => 'Low',
  '10fps 1sec' => '10 frames in 1 second',
  '8fps 1sec' => '10 frames in 1.25 seconds',
  '5fps 2sec' => '10 frames in 2 seconds',
  '2fps 5sec' => '10 frames in 5 seconds',
);

our %exposureMode = (
  'Program Auto' => 'Program Auto',
  'Aperture' => 'Aperture Priority',
  'Shutter' => 'Shutter Priority',
  'Manual' => 'Manual Exposure',
  'Intelligent Auto' => 'Intelligent Auto',
  'Superior Auto' => 'Superior Auto',
);

our %focusMode = (
  'AF-S' => 'Single AF',
  'AF-C' => 'Continuous AF',
  'DMF' => 'Direct Manual Focus',
  'MF' => 'Manual Focus',
);

our %whiteBalanceMode = (
  'Auto WB' => 'Auto WB',
  'Daylight' => 'Daylight',
  'Shade' => 'Shade',
  'Cloudy' => 'Cloudy',
  'Incandescent' => 'Incandescent',
  'Fluorescent: Warm White (-1)' => 'Fluorescent: Warm White (-1)',
  'Fluorescent: Cool White (0)' => 'Fluorescent: Cool White (0)',
  'Fluorescent: Day White (+1)' => 'Fluorescent: Day White (+1)',
  'Fluorescent: Daylight (+2)' => 'Fluorescent: Daylight (+2)',
  'Flash' => 'Flash',
  'Color Temperature' => 'Color Temperature',
  'Custom' => 'Custom',
  'Custom 1' => 'Custom 1',
  'Custom 2' => 'Custom 2',
  'Custom 3' => 'Custom 3',
);

our %flashMode = (
  'off' => 'OFF',
  'auto' => 'Auto flash',
  'on' => 'Forced flash',
  'slowSync' => 'Slow synchro',
  'rearSync' => 'Rear synchro',
  'wireless' => 'Wireless',
);

our %stillAspect = (
  '16:9' => '16:9',
  '4:3' => '4:3',
  '3:2' => '3:2',
  '1:1' => '1:1',
);

our %stillSize = (
  '20M' => '20M pixels',
  '18M' => '18M pixels',
  '17M' => '17M pixels',
  '13M' => '13M pixels',
  '7.5M' => '7.5M pixels',
  '5M' => '5M pixels',
  '4.2M' => '4.2M pixels',
  '3.7M' => '3.7M pixels',
);

our %stillQuality = (
  'RAW+JPEG' => 'RAW+JPEG',
  'Fine' => 'JPEG (Fine)',
  'Standard' => 'JPEG (Standard)',
);

our %postviewImageSize = (
  'Original' => 'Original size',
  '2M' => '2M-pixel size (the actual size depends on camera models.)',
);

our %movieFileFormat = (
  'MP4' => 'MP4',
  'XAVC S' => 'XAVC S',
  'XAVC S 4K' => 'XAVC S (4K)',
);

our %movieQuality = (
  'PS' => 'MP4, 1920x1080 60p/50p',
  'HQ' => 'MP4, 1920x1080 30p/25p',
  'STD' => 'MP4, 1280x720 30p/25p',
  'VGA' => 'MP4, 640x480 30p/25p',
  'SLOW' => 'MP4, 1280x720 30p (Imaging frame rate: 60p)',
  'SSLOW' => 'MP4, 1280x720 30p/25p (Imaging frame rate: 120p/100p)',
  'HS120' => 'MP4, 1280x720 120p',
  'HS100' => 'MP4, 1280x720 100p',
  'HS240' => 'MP4, 800x480 240p',
  'HS200' => 'MP4, 800x480 200p',
  '50M 60p' => 'XAVC S, 1920x1080 60p 50Mbps',
  '50M 50p' => 'XAVC S, 1920x1080 50p 50Mbps',
  '50M 30p' => 'XAVC S, 1920x1080 30p 50Mbps',
  '50M 25p' => 'XAVC S, 1920x1080 25p 50Mbps',
  '50M 24p' => 'XAVC S, 1920x1080 24p 50Mbps',
  '100M 120p' => 'XAVC S, 1920x1080 120p 100Mbps',
  '100M 100p' => 'XAVC S, 1920x1080 100p 100Mbps',
  '60M 120p' => 'XAVC S, 1920x1080 120p 60Mbps',
  '60M 100p' => 'XAVC S, 1920x1080 100p 60Mbps',
  '100M 240p' => 'XAVC S, 1280x720 240p 100Mbps',
  '100M 200p' => 'XAVC S, 1280x720 200p 100Mbps',
  '60M 240p' => 'XAVC S, 1280x720 240p 60Mbps',
  '60M 200p' => 'XAVC S, 1280x720 200p 60Mbps',
  '100M 30p' => 'XAVC S, 3840x2160 30p 100Mbps',
  '100M 25p' => 'XAVC S, 3840x2160 25p 100Mbps',
  '100M 24p' => 'XAVC S, 3840x2160 24p 100Mbps',
  '60M 30p' => 'XAVC S, 3840x2160 30p 60Mbps',
  '60M 25p' => 'XAVC S, 3840x2160 25p 60Mbps',
  '60M 24p' => 'XAVC S, 3840x2160 24p 60Mbps',
);

our %steadyMode = (
  'off' => 'Off',
  'on' => 'On',
);

our %sceneSelection = (
  'Normal' => 'Normal',
  'Under Water' => 'Under Water',
);

our %colorSetting = (
  'Neutral' => 'Neutral color',
  'Vivid' => 'Vivid color',
);

our %intervalTime = (
  '1' => '1 second',
  '2' => '2 seconds',
  '5' => '5 seconds',
  '10' => '10 seconds',
  '30' => '30 seconds',
  '60' => '60 seconds',
);

our %loopRecordingTime = (
  '5' => '5 minutes',
  '20' => '20 minutes',
  '60' => '60 minutes',
  '120' => '120 minutes',
  'unlimited' => 'Does not set the limit of the loop recording time',
);

our %windNoiseReduction = (
  'On' => 'Reduces wind noise',
  'Off' => 'Does not reduce wind noise',
);

our %audioRecordingSetting = (
  'On' => 'Records sound when shooting a movie',
  'Off' => 'Does not record sound when shooting a movie',
);

our %flipSetting = (
  'On' => 'Flips the image vertically and swaps the left and right sound channels',
  'Off' => 'Does not flip the image',
);

our %irRemoteControlSetting = (
  'On' => 'Using IR remote controller',
  'Off' => 'Not using IR remote controller',
);

our %tvColorSystem = (
  'NTSC' => 'NTSC',
  'PAL' => 'PAL',
);

our %beepMode = (
  'Off' => 'Turns off the beep/shutter sound',
  'On' => 'Turns on the beep/shutter sound',
  'Shutter Only' => 'Turns on the shutter sound only',
  'Silent' => 'Beep sounds are emitted for the following operations only',
);

our %storage = (
  'Memory Card 1' => 'Memory Card 1 (The card is inserted in the camera.)',
  'No Media' => 'No Media',
);

our %cameraFunction = (
  'Remote Shooting' => 'Shooting function',
  'Contents Transfer' => 'Transferring images function',
);

our %batteryId = (
  'externalBattery1' => 'External battery 1 (The battery is inserted in the camera.)',
  'noBattery' => 'No battery',
);

our %batteryStatus = (
  'active' => 'The battery is in use',
  'inactive' => 'The battery is not in use',
  'unknown' => 'The status is unknown',
);

our %additionalBatteryStatus = (
  'batteryNearEnd' => 'The battery power will be discharged soon',
  'charging' => 'The battery is charging',
  '' => 'Not set additional status',
);

our %cameraStatus = (
  'Error' => 'Error at the server (ex. high temperature, no memory card)',
  'NotReady' => 'The server cannot start recording (ex. during initialization, mode transitioning)',
  'IDLE' => 'Ready to record',
  'StillCapturing' => 'Capturing still images',
  'StillSaving' => 'Saving still images',
  'MovieWaitRecStart' => 'Preparing to start recording movie',
  'MovieRecording' => 'Recording movie',
  'MovieWaitRecStop' => 'Stopping the movie recording',
  'MovieSaving' => 'Saving movie',
  'AudioWaitRecStart' => 'Preparing to start recording audio',
  'AudioRecording' => 'Recording audio',
  'AudioWaitRecStop' => 'Stopping the audio recording',
  'AudioSaving' => 'Saving audio',
  'IntervalWaitRecStart' => 'Preparing to capture interval still images',
  'IntervalRecording' => 'Capturing interval still images',
  'IntervalWaitRecStop' => 'Stopping interval still images',
  'LoopWaitRecStart' => 'Preparing to start loop recording',
  'LoopRecording' => 'Running loop recording',
  'LoopWaitRecStop' => 'Stopping loop recording',
  'LoopSaving' => 'Saving loop recording movie',
  'WhiteBalanceOnePushCapturing' => 'Capturing the image for white balance custom setup',
  'ContentsTransfer' => 'The status ready to transferring images',
  'Streaming' => 'Streaming the movie',
  'Deleting' => 'Deleting the content',
);

our %liveviewOrientation = (
  '0' => 'Not rotated',
  '90' => 'Rotated 90 degrees clockwise',
  '180' => 'Rotated 180 degrees clockwise',
  '270' => 'Rotated 270 degrees clockwise',
);

our %focusStatus = (
  'Not Focusing' => 'The focus is not working',
  'Focusing' => 'The focus is in progress',
  'Focused' => 'The focus is locked',
  'Failed' => 'The focus has failed',
);

our %getEvent = (
  'availableApiList' => 0,
  'cameraStatus' => 1,
  'zoomInformation' => 2,
  'liveviewStatus' => 3,
  'liveviewOrientation' => 4,
  'takePicture' => 5,
  'storageInformation' => 10,
  'beepMode' => 11,
  'cameraFunction' => 12,
  'movieQuality' => 13,
  'stillSize' => 14,
  'cameraFunctionResult' => 15,
  'steadyMode' => 16,
  'viewAngle' => 17,
  'exposureMode' => 18,
  'postviewImageSize' => 19,
  'selfTimer' => 20,
  'shootMode' => 21,
  'exposureCompensation' => 25,
  'flashMode' => 26,
  'fNumber' => 27,
  'focusMode' => 28,
  'isoSpeedRate' => 29,
  'programShift' => 31,
  'shutterSpeed' => 32,
  'whiteBalance' => 33,
  'touchAFPosition' => 34,
  'focusStatus' => 35,
  'zoomSetting' => 36,
  'stillQuality' => 37,
  'contShootingMode' => 38,
  'contShootingSpeed' => 39,
  'contShooting' => 40,
  'flipSetting' => 41,
  'sceneSelection' => 42,
  'intervalTime' => 43,
  'colorSetting' => 44,
  'movieFileFormat' => 45,
  'infraredRemoteControl' => 52,
  'tvColorSystem' => 53,
  'trackingFocusStatus' => 54,
  'trackingFocus' => 55,
  'batteryInfo' => 56,
  'recordingTime' => 57,
  'numberOfShots' => 58,
  'autoPowerOff' => 59,
  'loopRecTime' => 60,
  'audioRecording' => 61,
  'windNoiseReduction' => 62
);

our %endPoint = map { $_ => 1 } qw(camera system avContent);
