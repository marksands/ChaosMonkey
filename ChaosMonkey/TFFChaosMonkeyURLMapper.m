#import "TFFChaosMonkeyURLMapper.h"
#import "TFFURLResponseMap.h"
#import "TFFStreakBreaker.h"

#define TFFChaosMonkeyException @"TFFChaosMonkeyException"
#define TFFChaosMonkeyUnsupportedPriority @"TFFChaosMonkeyPriority unsupported priority. Try Always, High, Medium, or Low"

@interface TFFChaosMonkeyURLMapper ()
@property (nonatomic) NSMutableDictionary *URLToRandomHitsAndMissesDictionary;
@end

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
    _URLToRandomHitsAndMissesDictionary = [NSMutableDictionary dictionary];
    return self;
}

- (void)mapURL:(NSURL *)url withError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority {
    TFFURLResponseMap *map = [[TFFURLResponseMap alloc] initWithURL:url error:error priority:priority];
    [self.responseMapping addObject:map];
}

- (NSError *)errorResponseForURL:(NSURL *)url {
    for (TFFURLResponseMap *mapping in self.responseMapping) {
        if ([url isEqual:mapping.URL]) {
            return mapping.error;
        }
    }
    return nil;
}

- (BOOL)respondToRequestRespectingPriority:(NSURLRequest *)request {
    for (TFFURLResponseMap *mapping in self.responseMapping) {
        if ([request.URL isEqual:mapping.URL]) {
            return [self randomResponseForMapping:mapping];
        }
    }
    return NO;
}

- (BOOL)randomResponseForMapping:(TFFURLResponseMap *)map {
    if (!self.URLToRandomHitsAndMissesDictionary[map.URL.absoluteString]) {
        self.URLToRandomHitsAndMissesDictionary[map.URL.absoluteString] = [[TFFStreakBreaker alloc] initWithMapping:map];
    }
    TFFStreakBreaker *streakBreaker = self.URLToRandomHitsAndMissesDictionary[map.URL.absoluteString];
    return [streakBreaker nextRandomBool];
}

@end
