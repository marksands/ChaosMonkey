#import "TFFFixedEffectRandomizer.h"

@interface TFFFixedEffectRandomizer()
@property (nonatomic) int responses;
@property (nonatomic) int yesResponses;
@end

@implementation TFFFixedEffectRandomizer

- (instancetype)init {
    self = [super init];
    _responses = 1;
    _yesResponses = 1;
    return self;
}

- (BOOL)nextRandomBoolWithFixedPercentage:(float)percentage {
    ++self.responses;

    if (((float)self.yesResponses / (float)self.responses) < percentage) {
        self.yesResponses++;
        return YES;
    }
    return NO;
}

@end
