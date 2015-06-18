#import "TFFStreakBreaker.h"
#import <libkern/OSAtomic.h>

@interface TFFStreakBreaker ()
@property (nonatomic, readonly) TFFURLResponseMap *responseMap;
@property (nonatomic) int responses;
@property (nonatomic) int yesResponses;
// @property (nonatomic) int streaks; // TODO: change randomness to only force a smaller stdev for streaks of #
@end

@implementation TFFStreakBreaker

- (instancetype)initWithMapping:(TFFURLResponseMap *)mapping {
    self = [super init];
    _responseMap = mapping;
    _responses = 1;
    _yesResponses = 1;
    return self;
}

- (BOOL)nextRandomBool {
    ++self.responses;
    
    if (((float)self.yesResponses / (float)self.responses) < [self priorityPercentage]) {
        self.yesResponses++;
        return YES;
    }
    
    return NO;
}

- (float)priorityPercentage {
    float randomDelta = arc4random_uniform(EPSILON * 2 + 1) - EPSILON;
    randomDelta /= 100.0;
    
    switch (self.responseMap.priority) {
        case TFFChaosMonkeyPriorityAlways: return 1.0;
        case TFFChaosMonkeyPriorityHigh: return 0.75 + randomDelta;
        case TFFChaosMonkeyPriorityMedium: return 0.50 + randomDelta;
        case TFFChaosMonkeyPriorityLow: return 0.25 + randomDelta;
        default: return 0.0;
    }
}

@end
