#import "TFFPrioritizedFailingURL.h"

@implementation TFFPrioritizedFailingURL

- (instancetype)initWithURL:(NSURL *)url error:(NSError *)error priority:(TFFChaosInjectorFailingPriority)priority {
    self = [super init];
    _URL = url;
    _error = error;
    _priority = priority;
    return self;
}

@end
