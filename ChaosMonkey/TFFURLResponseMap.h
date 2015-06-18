#import <Foundation/Foundation.h>
#import "TFFChaosMonkey.h"

@interface TFFURLResponseMap : NSObject

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) TFFChaosMonkeyPriority priority;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithURL:(NSURL *)url error:(NSError *)error priority:(TFFChaosMonkeyPriority)priority;

@end
