#import "TFFChaosMonkey.h"
#import "TFFFailingURLRunner.h"

@interface TFFChaosMonkey() <NSURLConnectionDelegate>
@end

@implementation TFFChaosMonkey

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosInjectorFailingPriority)priority {
	[NSURLProtocol registerClass:self];
    return [[TFFFailingURLRunner sharedInstance] mapURL:url withError:error priority:priority];
}

// This method may be called multiple times per request
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFFailingURLRunner sharedInstance] respondToRequestRespectingPriority:request];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)requestOne toRequest:(NSURLRequest *)requestTwo {
    return requestOne.cachePolicy == requestTwo.cachePolicy;
}

- (void)startLoading {
    NSError *error = [[TFFFailingURLRunner sharedInstance] errorResponseForURL:self.request.URL];
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)stopLoading {
}

@end
