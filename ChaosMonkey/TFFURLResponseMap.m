#import "TFFURLResponseMap.h"

@implementation TFFURLResponseMap

- (instancetype)initWithURL:(NSURL *)url error:(NSError *)error priority:(TFFChaosMonkeyPriority)priority {
    self = [super init];
    _URL = url;
    _error = error;
    _priority = priority;
    return self;
}

@end
