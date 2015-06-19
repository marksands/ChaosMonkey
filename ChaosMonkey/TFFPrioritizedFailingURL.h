#import <Foundation/Foundation.h>
#import "TFFChaosMonkey.h"

@interface TFFPrioritizedFailingURL : NSObject

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) TFFChaosInjectorFailingPriority priority;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithURL:(NSURL *)url error:(NSError *)error priority:(TFFChaosInjectorFailingPriority)priority;

@end
