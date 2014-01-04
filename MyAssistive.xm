#import "MyAssistive.h"
#import "FSSwitchPanel.h"

%group AS

#define HNDController [%c(HNDEventManager) sharedManager]

@interface HNDDisplayManager (MyAssistive)
- (void)Inject:(int)num;
@end

static void MALoader()
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
	MyNumber = [dict objectForKey:@"myNumber"] ? [[dict objectForKey:@"myNumber"] integerValue] : 1;
	replaceEnabled = key(replaceEnabled, NO);
	lockPosEnabled = key(lockPosEnabled, NO);
	noLockPosEnabled = key(noLockPosEnabled, NO);
	blueIconEnabled = key(blueIconEnabled, NO);
	customTextColor = key(customTextColor, NO);
	noHideSSEnabled = key(noHideSSEnabled, NO);
	alwaysFade = key(alwaysFade, NO);
	noSetAlpha = key(noSetAlpha, NO);
	noWarn = key(noWarn, YES);
	bgAlpha = Float(@"bgAlpha", .95f);
	blurBG = Float(@"blurBG", 0.f);
	textColor = [dict objectForKey:@"textColor"] ? [[dict objectForKey:@"textColor"] floatValue] : 1.f;
	alpha = Color(@"alpha");
	R = Color(@"R"); G = Color(@"G"); B = Color(@"B");
}


%hook HNDDisplayManager

/*- (void)initializeDisplay
{
	%orig;
	UIView* contentView = MSHookIvar<UIView* >(self, "_ignoredContentView");
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,480)];
	view.userInteractionEnabled = NO;
	view.backgroundColor=[UIColor blackColor];
	view.alpha = [[[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.phoenix.dimmer.plist"] objectForKey:@"darkpt"] floatValue] - 0.1f;
	[contentView addSubview:view];
	[view release];
}*/

%new(v@:i)
- (void)Inject:(int)num
{
	HNDRocker *rocker = MSHookIvar<HNDRocker *>(self, "_rocker");
	CGPoint rockerPoint = [rocker onScreenLocation];
	switch (num) {
		case 1 :
			break;
		case 2 : // Toggle Switcher
			if (isiOS5)
				notify_post("com.PS.MyAssistive.toggleSwitcher");
			else
				[HNDController _toggleAppSwitcher];
			break;
		case 3 : // Toggle Siri
			if (isiOS5)
				notify_post("com.apple.MyAssistive.siri");
			else
				[HNDController _toggleSiri];
			break;
		case 4 : // Toggle Voice Control
			if (isiOS5)
				notify_post("com.apple.MyAssistive.voiceControl");
			else
				[HNDController _toggleVoiceControl];
			break;
		case 5 : // Take Screenshot
			notify_post("com.PS.MyAssistive.takeScreenshot");
			break;
		case 6 : // Triple Click
			if (isiOS5) {
				[rocker _homeButton:1]; [rocker _homeButton:0];
				[rocker _homeButton:1]; [rocker _homeButton:0];
				[rocker _homeButton:1]; [rocker _homeButton:0];
			} else
				[HNDController _tripleClick];
			break;
		case 7:
		{
			if (rockerPoint.x < 160.0f) {
				if (noWarn) {
					[HNDController performHardwareButton:4 state:2];
					[HNDController performHardwareButton:4 state:3];
				}
				else {
					[rocker _volumeDown:1];
					[rocker _volumeDown:0];
				}
			} else {
				if (noWarn) {
					[HNDController performHardwareButton:3 state:2];
					[HNDController performHardwareButton:3 state:3];
				}
				else {
					[rocker _volumeUp:1];
					[rocker _volumeUp:0];
				}
			}
			break;
		}
		case 8 : // Mute or Unmute
		{
			notify_post("com.PS.MyAssistive.toggleMute");
			break;
		}
		case 9 : // Restart SpringBoard
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.respring"];
			break;
		case 10 : // Restart backboardd
			system("killall backboardd");
			break;
		case 11 : // Reboot
			notify_post("com.PS.MyAssistive.reboot");
			break;
		case 12 : // Power Off
			notify_post("com.PS.MyAssistive.powerOff");
			break;
		case 13 : // Lock Button
		{
			if (noWarn) {
				[HNDController performHardwareButton:2 state:2];
				[HNDController performHardwareButton:2 state:3];
			}
			else {
				[rocker _lockButton:1];
				[rocker _lockButton:0];
			}
			break;
		}
		case 14 : // Home Button
		{
			if (noWarn) {
				[HNDController performHardwareButton:1 state:2];
				[HNDController performHardwareButton:1 state:3];
			}
			else {
				[rocker _homeButton:1];
				[rocker _homeButton:0];
			}
			break;
		}
		case 15 : // Quit Top Application
			GSEventQuitTopApplication();
			break;
		case 16 : // Lock Device
			GSEventLockDevice();
			break;
		case 17 : // Rotate Screen
		{
			int orientation = MSHookIvar<int>(self, "_orientation");
			if (rockerPoint.x < 160.0f) {
				// CCW (1 - 4 - 2 - 3)
				if (orientation == 1)
					[HNDController _sendDeviceOrientationChange:4];
				else if (orientation == 4)
					[HNDController _sendDeviceOrientationChange:2];
				else if (orientation == 2)
					[HNDController _sendDeviceOrientationChange:3];
				else if (orientation == 3)
					[HNDController _sendDeviceOrientationChange:1];
			} else {
				// CW (1 - 3 - 2 - 4)
				if (orientation == 1)
					[HNDController _sendDeviceOrientationChange:3];
				else if (orientation == 3)
					[HNDController _sendDeviceOrientationChange:2];
				else if (orientation == 2)
					[HNDController _sendDeviceOrientationChange:4];
				else if (orientation == 4)
					[HNDController _sendDeviceOrientationChange:1];
			}
			break;
		}
		case 18 : // Toggle Torch
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.flashlight"];
			break;
		case 19 : // Safe mode
			system("killall -SEGV SpringBoard");
			break;
		case 20 : // Shake Device
			[rocker _shakePressed];
			break;
		case 21 : // Flash Screen
			notify_post("com.PS.MyAssistive.flashScreen");
			break;
		case 22 : // Toggle Lock or Unlock Orientation
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.rotation"];
			break;
		case 23 : // Switch between Apps
		{
			if (rockerPoint.x < 160.0f)
				notify_post("com.PS.MyAssistive.switchAppGestureMoveToLeft");
			else
				notify_post("com.PS.MyAssistive.switchAppGestureMoveToRight");
			break;
		}
		case 24 : // Toggle Wi-Fi
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.wifi"];
			break;
		case 25 : // Toggle Airplane Mode
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.airplane-mode"];
			break;
		case 26 : // Toggle Bluetooth
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.bluetooth"];
			break;
		case 27 : // Temporary Adjust Brightness
		{
			if (rockerPoint.x < 160.0f) {
				GSEventSetBacklightLevel([UIScreen mainScreen].brightness - 0.05);
				[[UIApplication sharedApplication] setBacklightLevel:[UIScreen mainScreen].brightness - 0.05];
			} else {
				GSEventSetBacklightLevel([UIScreen mainScreen].brightness + 0.05);
				[[UIApplication sharedApplication] setBacklightLevel:[UIScreen mainScreen].brightness + 0.05];
			}
			break;
		}
		case 28 : // Toggle Auto Brightness
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.auto-brightness"];
   			break;
   		case 29 : // Toggle Do Not Disturb
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];
   			break;
   		case 30 : // Toggle Personal Hotspot
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.hotspot"];
   			break;
   		case 31 : // Toggle 3G
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.3g"];
   			break;
   		case 32 : // Toggle Data
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.cellular-data"];
   			break;
   		case 33 : // Toggle Auto Lock
			[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.autolock"];
   			break;
	}
}

/*
static CGPoint rockerUpPoint;
static CGPoint rockerDownPoint;

- (BOOL)handleRealEvent:(GSEventRef)event
{
	HNDRocker *rocker = MSHookIvar<HNDRocker *>(self, "_rocker");
	CGPoint rockerPoint = [rocker onScreenLocation];
		if (GSEventGetType(event) == kGSEventLeftMouseUp) {
			NSLog(@"FDF up");
			CGPoint upPoint = GSEventGetLocationInWindow(event);
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				rockerIsDragging = NO;
			});
			rockerUpPoint = upPoint;
			id viewAtUpPoint = [self viewAtPoint:upPoint];
			if ([viewAtUpPoint isKindOfClass:objc_getClass("HNDRocker")]) {
				if (((HNDRocker *)viewAtUpPoint).frame.size.width < 100.0f) {
					rockerIsPressed = NO;
					if (rockerIsDragging == NO && rockerIsPressed == NO) {
						switch (MyNumber) {
							case 13 : // Lock Button
							{
								if (noWarn)
									[HNDController performHardwareButton:2 state:3];
								else
									[rocker _lockButton:0];
								break;
							}
							case 14 : // Home Button
							{
							NSLog(@"Home up");
								if (noWarn)
									[HNDController performHardwareButton:1 state:3];
								else
									[rocker _homeButton:0];
								break;
							}
						}
					}
				}
				//end cases
			}
		}
	else if (GSEventGetType(event) == kGSEventLeftMouseDown) {
		NSLog(@"FDF down");
		CGPoint downPoint = GSEventGetLocationInWindow(event);
		rockerDownPoint = downPoint;
		id viewAtDownPoint = [self viewAtPoint:downPoint];
		if ([viewAtDownPoint isKindOfClass:objc_getClass("HNDRocker")]) {
			if (((HNDRocker *)viewAtDownPoint).frame.size.width < 100.0f) {
				rockerIsPressed = YES;
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
				if (rockerIsDragging == NO && rockerIsPressed == YES) {
					switch (MyNumber) {
						case 13 : // Lock Button
						{
							if (noWarn)
								[HNDController performHardwareButton:2 state:2];
							else
								[rocker _lockButton:1];
							break;
						}
						case 14 : // Home Button
						{
						NSLog(@"Home down");
							if (noWarn)
								[HNDController performHardwareButton:1 state:2];
							else
								[rocker _homeButton:1];
							break;
						}
					}
					//end cases
				}
			});
		}
	}
	}
	else if (GSEventGetType(event) == kGSEventLeftMouseDragged) {
		NSLog(@"FDF drag");
		CGPoint dragPoint = GSEventGetLocationInWindow(event);
		id viewAtDragPoint = [self viewAtPoint:dragPoint];
		if ([viewAtDragPoint isKindOfClass:objc_getClass("HNDRocker")]) {
			if (((HNDRocker *)viewAtDragPoint).frame.size.width < 100.0f) {
				NSLog(@"Down %@ : Drag %@", NSStringFromCGPoint(rockerDownPoint), NSStringFromCGPoint(dragPoint));
				rockerIsDragging = !(abs(rockerDownPoint.x - dragPoint.x) < 70.0f && abs(rockerDownPoint.y - dragPoint.y) < 70.0f);
				rockerIsPressed = NO;
			}
		}
	}
	if (GSEventGetType(event) == kGSEventLeftMouseUp) {
		NSLog(@"Up");
		id viewAtUpPoint = [self viewAtPoint:GSEventGetLocationInWindow(event)];
		NSLog(@"%@", viewAtUpPoint);
		//if ([viewAtUpPoint class"UIButton")])
			//NSLog(@"Hmmm");
	}
	else if (GSEventGetType(event) == kGSEventLeftMouseDown)
		NSLog(@"Down");
	else if (GSEventGetType(event) == kGSEventLeftMouseDragged)
		NSLog(@"Dragged");
	return %orig;
}*/

- (void)_handleNubbitMove:(CGPoint)move
{
	/*NSLog(@"rocker Pressed: %i", rockerIsPressed);
	NSLog(@"rocker Dragging: %i", rockerIsDragging);*/
	if (lockPosEnabled) return;
	%orig;
}

- (void)_moveNubbitToPosition:(CGPoint)point
{
	if (noLockPosEnabled) return;
	%orig;
}

- (void)viewPressed:(id)pressed
{
	if (replaceEnabled && [pressed isKindOfClass:objc_getClass("HNDRocker")]) {
		//if (MyNumber != 7 && MyNumber != 13 && MyNumber != 14)
			[self Inject:MyNumber];
		if (MyNumber == 1)
			%orig;
		else {
			HNDRocker *rocker = [[%c(HNDRocker) alloc] init];
			if ([rocker respondsToSelector:@selector(transitionMenuToNubbit:changeAlpha:animate:)])
				[rocker transitionMenuToNubbit:[rocker onScreenLocation] changeAlpha:0 animate:0];
			if ([HNDController respondsToSelector:@selector(manipulateDimTimer:)])
				[HNDController manipulateDimTimer:NO];
		}
	} else %orig;
}

%end

%hook HNDHandManager

- (void)screenshotWillFire
{
	if (noHideSSEnabled) return;
	%orig;
}

%end

%hook HNDRocker

- (void)_setBackgroundWithType:(int)type
{
	%orig;
	UIImageView *background;
	if (isiOS7)
		background = MSHookIvar<UIImageView *>(self, "_nubbitForeground");
	else
		background = MSHookIvar<UIImageView *>(self, "_background");
	CAFilter *filter = [CAFilter filterWithName:@"gaussianBlur"];
	[filter setValue:[NSNumber numberWithFloat:blurBG] forKey:@"inputRadius"];
	background.layer.shouldRasterize = YES;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
		[UIView animateWithDuration:.5 delay:.0 options:0
    	animations:^{
    		background.layer.filters = [NSArray arrayWithObject:filter];
    		if (!noSetAlpha)
				[background setAlpha:bgAlpha];
		} completion:nil];
	});
}

- (void)_resetVisibility:(BOOL)visibility
{
	%orig(alwaysFade ? NO : visibility);
	UIImageView *background;
	if (isiOS7)
		background = MSHookIvar<UIImageView *>(self, "_nubbitForeground");
	else
		background = MSHookIvar<UIImageView *>(self, "_background");
	CAFilter *filter = [CAFilter filterWithType:@"gaussianBlur"];
	[filter setValue:[NSNumber numberWithFloat:blurBG] forKey:@"inputRadius"];
	background.layer.shouldRasterize = YES;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
		[UIView animateWithDuration:.7 delay:.0 options:0
    	animations:^{
    		background.layer.filters = [NSArray arrayWithObject:filter];
    		if (!noSetAlpha)
				[background setAlpha:bgAlpha];
		} completion:nil];
	});
}

%end

%hook HNDRockerButton

- (BOOL)selected
{
	return blueIconEnabled ? YES : %orig;
}		

- (void)updateTextColor
{
	if (customTextColor && textColor != 1) {
		[MSHookIvar<UILabel *>(self, "_label") setTextColor:[UIColor colorWithRed:R green:G blue:B alpha:alpha]];
		[MSHookIvar<UILabel *>(self, "_label") setAlpha:alpha];
	}
	else %orig;
}

%end

%end

%group SpringBoard

static void VOID(TakeScreenShot)
{
	[[%c(SBScreenShotter) sharedInstance] saveScreenshot:YES];
}

static void VOID(FlashScreen)
{
	[[%c(SBScreenFlash) sharedInstance] flash];
}

static void VOID(switchAppGestureMoveToRight)
{
	[[%c(SBUIController) sharedInstance] programmaticSwitchAppGestureMoveToRight];
}

static void VOID(switchAppGestureMoveToLeft)
{
	[[%c(SBUIController) sharedInstance] programmaticSwitchAppGestureMoveToLeft];
}

static void VOID(VoiceControl)
{
	SBVoiceControlAlert *alert = [%c(SBVoiceControlAlert) pendingOrActiveAlert];
	if (alert)
		[alert cancel];
	if ([%c(SBVoiceControlAlert) shouldEnterVoiceControl]) {
		alert = [[%c(SBVoiceControlAlert) alloc] initFromMenuButton];
		[alert _workspaceActivate];
		[alert release];
	}
}

static void VOID(Siri)
{
	if ([%c(SBAssistantController) supportedAndEnabled])
		[[UIApplication sharedApplication] activateAssistantWithOptions:nil withCompletion:nil];
}

static void VOID(ToggleSwitcher)
{
	SBUIController *sharedController = [%c(SBUIController) sharedInstance];
	if ([sharedController isSwitcherShowing]) {
		if ([sharedController respondsToSelector:@selector(dismissSwitcherAnimated:)])
			[sharedController dismissSwitcherAnimated:YES];
		else
			[sharedController dismissSwitcher];
		return;
	}
	[sharedController _toggleSwitcher];
}

static void VOID(Reboot)
{
	[(SpringBoard *)[UIApplication sharedApplication] reboot];
}

static void VOID(PowerOff)
{
	[(SpringBoard *)[UIApplication sharedApplication] powerDown];
}

static void VOID(ToggleMute)
{
	[[%c(VolumeControl) sharedVolumeControl] toggleMute];
}

%end

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	MALoader();
}

%ctor {
   	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	MALoader();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("com.PS.MyAssistive.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	NSString *ident = [[NSBundle mainBundle] bundleIdentifier];
	if ([ident isEqualToString:@"com.apple.springboard"]) {
		%init(SpringBoard);
		AddObserver(TakeScreenShot, "com.PS.MyAssistive.takeScreenshot")
		AddObserver(FlashScreen, "com.PS.MyAssistive.flashScreen")
		AddObserver(switchAppGestureMoveToRight, "com.PS.MyAssistive.switchAppGestureMoveToRight")
		AddObserver(switchAppGestureMoveToLeft, "com.PS.MyAssistive.switchAppGestureMoveToLeft")
		AddObserver(Siri, "com.PS.MyAssistive.siri")
		AddObserver(VoiceControl, "com.PS.MyAssistive.voiceControl")
		AddObserver(ToggleSwitcher, "com.PS.MyAssistive.toggleSwitcher")
		AddObserver(Reboot, "com.PS.MyAssistive.reboot")
		AddObserver(PowerOff, "com.PS.MyAssistive.powerOff")
		AddObserver(ToggleMute, "com.PS.MyAssistive.toggleMute")
	}
	else if ([ident isEqualToString:@"com.apple.assistivetouchd"] || [ident isEqualToString:@"com.apple.HandTool"])
		%init(AS);
	[pool drain];
}