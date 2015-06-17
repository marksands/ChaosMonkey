#import <Foundation/Foundation.h>

@interface TFFChaosMonkeyURLMapper : NSObject

@property (nonatomic, readonly) NSMutableArray *responseMapping;

+ (instancetype)sharedInstance;

- (void)mapURL:(NSURL *)url withError:(NSError *)error;
- (NSError *)errorMappingForURL:(NSURL *)url;
- (BOOL)canInitializeRequest:(NSURLRequest *)request;

@end
