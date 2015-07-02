#import <Foundation/Foundation.h>
#import "TFFRandomNumberProvider.h"

@interface TFFChaosMonkey : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithRandomNumberProvider:(TFFRandomNumberProvider *)randomNumberProvider;

- (void)stubURL:(NSURL *)url returningError:(NSError *)error;

@end
