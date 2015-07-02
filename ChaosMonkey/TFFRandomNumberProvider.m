#import "TFFRandomNumberProvider.h"

#define precision 1000.0

@implementation TFFRandomNumberProvider

- (double)nextRandom {
    return arc4random_uniform(precision) / precision;
}

@end
