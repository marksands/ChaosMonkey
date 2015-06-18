#import <Foundation/Foundation.h>
#import "TFFURLResponseMap.h"

#define EPSILON 5.0

@interface TFFStreakBreaker : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithMapping:(TFFURLResponseMap *)mapping;

- (BOOL)nextRandomBool;

@end
