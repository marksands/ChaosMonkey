#import "TFFRandomNumberProvider.h"

@interface TFFMockRandomNumberProvider : TFFRandomNumberProvider

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGeneratedRandomNumbers:(NSArray *)randomNumbers;

@end
