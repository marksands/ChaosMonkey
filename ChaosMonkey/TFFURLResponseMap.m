#import "TFFURLResponseMap.h"

@implementation TFFURLResponseMap

- (instancetype)initWithURL:(NSURL *)url error:(NSError *)error {
    self = [super init];
    _URL = url;
    _error = error;
    return self;
}

@end
