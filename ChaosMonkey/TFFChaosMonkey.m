#import "TFFChaosMonkey.h"
#import "TFFChaosMonkeyURLMapper.h"

@interface TFFChaosMonkey () <NSURLConnectionDelegate>

@property (nonatomic, readonly) NSURLConnection *URLConnection;

@end

@implementation TFFChaosMonkey

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority {
	[NSURLProtocol registerClass:self];

    return [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url withError:error priority:priority];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFChaosMonkeyURLMapper sharedInstance] canInitializeRequest:request];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)requestOne toRequest:(NSURLRequest *)requestTwo {
    return requestOne.cachePolicy == requestTwo.cachePolicy;
}

- (void)startLoading {
    NSError *error = [[TFFChaosMonkeyURLMapper sharedInstance] errorMappingForURL:self.request.URL];
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)stopLoading {
    
}

@end
