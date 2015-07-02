#import "TFFMockRandomNumberProvider.h"

@interface TFFMockRandomNumberProvider ()

@property (nonatomic, readonly) NSArray *randomNumbers;
@property (nonatomic) int nextRandomIndex;

@end

@implementation TFFMockRandomNumberProvider

- (instancetype)initWithGeneratedRandomNumbers:(NSArray *)randomNumbers {
    self = [super init];
    _randomNumbers = randomNumbers;
    return self;
}

- (double)nextRandom {
	double random = [self.randomNumbers[self.nextRandomIndex] doubleValue];
	self.nextRandomIndex = self.nextRandomIndex + 1 < self.randomNumbers.count ? self.nextRandomIndex + 1 : 0;
	return random;
}

@end
