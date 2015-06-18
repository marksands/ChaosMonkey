#import "TFFChaosMonkeyURLMapper.h"
#import "TFFURLResponseMap.h"

#define TFFChaosMonkeyException @"TFFChaosMonkeyException"
#define TFFChaosMonkeyUnsupportedPriority @"TFFChaosMonkeyPriority unsupported priority. Try Always, High, Medium, or Low"

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

- (void)mapURL:(NSURL *)url withError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority {
    TFFURLResponseMap *map = [[TFFURLResponseMap alloc] initWithURL:url error:error priority:priority];
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
            switch (mapping.priority) {
                case TFFChaosMonkeyPriorityAlways: return YES;
                case TFFChaosMonkeyPriorityHigh: return arc4random_uniform(1000) > 250;
                case TFFChaosMonkeyPriorityMedium: return arc4random_uniform(1000) > 500;
                case TFFChaosMonkeyPriorityLow: return arc4random_uniform(1000) > 750;
                default: [NSException raise:TFFChaosMonkeyException format:TFFChaosMonkeyUnsupportedPriority];
            }
        }
    }
    return NO;
}

@end
