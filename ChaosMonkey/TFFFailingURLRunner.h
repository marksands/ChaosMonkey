#import <Foundation/Foundation.h>
#import "TFFChaosMonkey.h"

@interface TFFFailingURLRunner : NSObject

@property (nonatomic, readonly) NSMutableArray *prioritizedFailingURLs;

+ (instancetype)sharedInstance;

- (void)mapURL:(NSURL *)url withError:(NSError *)error priority:(TFFChaosInjectorFailingPriority)priority;
- (NSError *)errorResponseForURL:(NSURL *)url;
- (BOOL)respondToRequestRespectingPriority:(NSURLRequest *)request;

@end
