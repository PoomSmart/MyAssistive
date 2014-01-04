#import <substrate.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication2.h>
#import <GraphicsServices/GSEvent.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CAFilter.h>
#import <AVFoundation/AVFoundation.h>
#import "AssistiveTouch/HNDEventManager.h"
#import "AssistiveTouch/HNDDisplayManager.h"
#import "AssistiveTouch/HNDHandManager.h"
#import "AssistiveTouch/HNDRocker.h"
#import "AssistiveTouch/HNDWindow.h"
#import <notify.h>

#define PREF_PATH @"/var/mobile/Library/Preferences/com.PS.MyAssistive.plist"
#define key(key, defaultValue) ([dict objectForKey:[NSString stringWithUTF8String:#key]] ? [[dict objectForKey:[NSString stringWithUTF8String:#key]] boolValue] : defaultValue)
#define Color(key) ([dict objectForKey:key] ? [[dict objectForKey:key] floatValue] : 1.f)
#define Float(key, defaultValue) ([dict objectForKey:key] ? [[dict objectForKey:key] floatValue] : defaultValue)
#define isiOS5 (kCFCoreFoundationVersionNumber >= 675.00 && kCFCoreFoundationVersionNumber < 793.00)
#define isiOS6 (kCFCoreFoundationVersionNumber == 793.00)
#define isiOS7 (kCFCoreFoundationVersionNumber > 793.00)

#define AddObserver(voidName, identifier) CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, voidName, CFSTR(identifier), NULL, CFNotificationSuspensionBehaviorCoalesce);
#define VOID(name) name(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)

static int MyNumber;
static BOOL replaceEnabled;
static BOOL lockPosEnabled;
static BOOL noLockPosEnabled;
static BOOL blueIconEnabled;
static BOOL customTextColor;
static BOOL noHideSSEnabled;
static BOOL alwaysFade;
static BOOL noWarn;
static BOOL noSetAlpha;
static float bgAlpha;
static float R, G, B;
static float alpha, blurBG;
static int textColor;

/*static BOOL rockerIsDragging = NO;
static BOOL rockerIsPressed;*/

@interface SpringBoard
- (void)reboot;
- (void)powerDown;
@end

@interface SBScreenFlash
+ (id)sharedInstance;
- (void)flash;
@end

@interface SBWiFiManager
- (BOOL)wiFiEnabled;
- (void)setWiFiEnabled:(BOOL)enabled;
@end

@interface SBOrientationLockManager
- (BOOL)isLocked;
@end

@interface SBTelephonyManager
+ (id)sharedTelephonyManager;
- (BOOL)isInAirplaneMode;
- (void)setIsInAirplaneMode:(BOOL)air;
@end

@interface SBScreenShotter
+ (id)sharedInstance;
- (void)saveScreenshot:(BOOL)screenshot;
@end

@interface BluetoothManager
+ (id)sharedInstance;
- (BOOL)enabled;
- (BOOL)setPowered:(BOOL)arg1;
- (BOOL)setEnabled:(BOOL)arg1;
@end

@interface SBStatusBarDataManager
+ (id)sharedDataManager;
- (void)_updateBluetoothBatteryItem;
- (void)_updateBluetoothItem;
@end

@interface SBUIController : NSObject
- (BOOL)isSwitcherShowing;
- (void)programmaticSwitchAppGestureMoveToLeft;
- (void)programmaticSwitchAppGestureMoveToRight;
- (void)dismissSwitcherAnimated:(BOOL)animated;
- (void)dismissSwitcher;
- (void)_toggleSwitcher;
@end

@interface SBVoiceControlAlert : NSObject
+ (id)pendingOrActiveAlert;
+ (BOOL)shouldEnterVoiceControl;
- (id)initFromMenuButton;
- (void)_workspaceActivate;
- (void)cancel;
@end

@interface SBAssistantController
+ (BOOL)supportedAndEnabled;
@end

@interface VolumeControl
+ (id)sharedVolumeControl;
- (void)toggleMute;
@end

@interface UIApplication (MyAssistive)
- (void)activateAssistantWithOptions:(id)options withCompletion:(id)completion;
@end
