#import "TFFChaosMonkeyURLMapper.h"
#import "TFFURLResponseMap.h"

@implementation TFFChaosMonkeyURLMapper

+ (instancetype)sharedInstance {
    static TFFChaosMonkeyURLMapper *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFFChaosMonkeyURLMapper alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    _responseMapping = [NSMutableArray array];
    return self;
}

- (void)mapURL:(NSURL *)url withError:(NSError *)error {
    TFFURLResponseMap *map = [[TFFURLResponseMap alloc] initWithURL:url error:error];
    [self.responseMapping addObject:map];
}

- (NSError *)errorMappingForURL:(NSURL *)url {
    for (TFFURLResponseMap *mapping in self.responseMapping) {
        if ([url isEqual:mapping.URL]) {
            return mapping.error;
        }
    }
    return nil;
}

- (BOOL)canInitializeRequest:(NSURLRequest *)request {
    for (TFFURLResponseMap *mapping in self.responseMapping) {
        if ([request.URL isEqual:mapping.URL]) {
            return YES;
        }
    }
    return NO;
}

@end
