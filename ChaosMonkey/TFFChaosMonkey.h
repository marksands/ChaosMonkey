#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TFFChaosInjectorFailingPriority) {
	TFFChaosInjectorFailingPriorityAlways,
	TFFChaosInjectorFailingPriorityHigh,
	TFFChaosInjectorFailingPriorityMedium,
	TFFChaosInjectorFailingPriorityLow
};

@interface TFFChaosMonkey : NSURLProtocol

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosInjectorFailingPriority)priority;

@end
