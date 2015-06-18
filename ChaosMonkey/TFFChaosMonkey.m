#import "TFFChaosMonkey.h"
#import "TFFChaosMonkeyURLMapper.h"

@interface TFFChaosMonkey () <NSURLConnectionDelegate>

@end

@implementation TFFChaosMonkey

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority {
	[NSURLProtocol registerClass:self];

    return [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url withError:error priority:priority];
}

// This method may be called multiple times per request
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFChaosMonkeyURLMapper sharedInstance] respondToRequestRespectingPriority:request];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)requestOne toRequest:(NSURLRequest *)requestTwo {
    return requestOne.cachePolicy == requestTwo.cachePolicy;
}

- (void)startLoading {
    NSError *error = [[TFFChaosMonkeyURLMapper sharedInstance] errorResponseForURL:self.request.URL];
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)stopLoading {
    
}

@end
