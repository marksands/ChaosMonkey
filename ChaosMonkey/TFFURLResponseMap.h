#import <Foundation/Foundation.h>

@interface TFFURLResponseMap : NSObject

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSError *error;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithURL:(NSURL *)url error:(NSError *)error;

@end
