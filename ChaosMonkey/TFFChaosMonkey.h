#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TFFChaosMonkeyPriority) {
	TFFChaosMonkeyPriorityAlways,
    TFFChaosMonkeyPriorityHigh,
    TFFChaosMonkeyPriorityMedium,
    TFFChaosMonkeyPriorityLow
};

@interface TFFChaosMonkey : NSURLProtocol

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority;

@end
