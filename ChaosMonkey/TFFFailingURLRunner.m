#import "TFFFailingURLRunner.h"
#import "TFFPrioritizedFailingURL.h"
#import "TFFFixedEffectRandomizer.h"

#define EPSILON 5.0f

#define TFFChaosMonkeyException @"TFFChaosMonkeyException"
#define TFFChaosMonkeyUnsupportedPriority @"Unsupported failing priority. Use Always, High, Medium, or Low"

@interface TFFFailingURLRunner()

@property (nonatomic) NSMutableDictionary *URLStringToStreakDictionary;

@end

@implementation TFFFailingURLRunner

+ (instancetype)sharedInstance {
    static TFFFailingURLRunner *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFFFailingURLRunner alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    _prioritizedFailingURLs = [NSMutableArray array];
    _URLStringToStreakDictionary = [NSMutableDictionary dictionary];
    return self;
}

- (void)mapURL:(NSURL *)url withError:(NSError *)error priority:(TFFChaosInjectorFailingPriority)priority {
    TFFPrioritizedFailingURL *map = [[TFFPrioritizedFailingURL alloc] initWithURL:url error:error priority:priority];
    [self.prioritizedFailingURLs addObject:map];
}

- (NSError *)errorResponseForURL:(NSURL *)url {
    for (TFFPrioritizedFailingURL *mapping in self.prioritizedFailingURLs) {
        if ([url isEqual:mapping.URL]) {
            return mapping.error;
        }
    }
    return nil;
}

- (BOOL)respondToRequestRespectingPriority:(NSURLRequest *)request {
    for (TFFPrioritizedFailingURL *mapping in self.prioritizedFailingURLs) {
        if ([request.URL isEqual:mapping.URL]) {
			if (!self.URLStringToStreakDictionary[mapping.URL.absoluteString]) {
				self.URLStringToStreakDictionary[mapping.URL.absoluteString] = [[TFFFixedEffectRandomizer alloc] init];
			}
			TFFFixedEffectRandomizer *streakBreaker = self.URLStringToStreakDictionary[mapping.URL.absoluteString];
			return [streakBreaker nextRandomBoolWithFixedPercentage:[self percentageWithPriority:mapping.priority]];
        }
    }
    return NO;
}

- (float)percentageWithPriority:(TFFChaosInjectorFailingPriority)priority {
	float randomDelta = arc4random_uniform((uint32_t)(EPSILON * 2 + 1)) - EPSILON;
	randomDelta /= 100.0;

	switch (priority) {
		case TFFChaosInjectorFailingPriorityAlways: return 1.0;
		case TFFChaosInjectorFailingPriorityHigh: return 0.75f + randomDelta;
		case TFFChaosInjectorFailingPriorityMedium: return 0.50f + randomDelta;
		case TFFChaosInjectorFailingPriorityLow: return 0.25f + randomDelta;
		default: [NSException raise:TFFChaosMonkeyException format:TFFChaosMonkeyUnsupportedPriority];
	}
}

@end
