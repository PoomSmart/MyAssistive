#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface MyAssistivePreferenceController : PSListController
- (id)specifiers;
@end

@implementation MyAssistivePreferenceController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"MyAssistive" target:self] retain];
  }
	return _specifiers;
}

- (void)restartAS:(id)param
{
	system("killall assistivetouchd");
}

@end
