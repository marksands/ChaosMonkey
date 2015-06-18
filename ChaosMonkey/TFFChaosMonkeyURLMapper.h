#import <Foundation/Foundation.h>
#import "TFFChaosMonkey.h"

@interface TFFChaosMonkeyURLMapper : NSObject

@property (nonatomic, readonly) NSMutableArray *responseMapping;

+ (instancetype)sharedInstance;

- (void)mapURL:(NSURL *)url withError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority;
- (NSError *)errorMappingForURL:(NSURL *)url;
- (BOOL)canInitializeRequest:(NSURLRequest *)request;

@end
