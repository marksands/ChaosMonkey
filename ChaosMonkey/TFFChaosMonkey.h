#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TFFChaosMonkeyPriority) {
	TFFChaosMonkeyPriorityAlways
};

@interface TFFChaosMonkey : NSObject

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority;

@end
