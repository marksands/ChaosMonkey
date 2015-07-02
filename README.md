# ChaosMonkey
Stub a URL with a corresponding NSError and watch your requests randomly fail.

# Demo

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	TFFRandomNumberProvider *randomNumberProvider = [[TFFRandomNumberProvider alloc] init];
	self.chaosMonkey = [[TFFChaosMonkey alloc] initWithRandomNumberProvider:randomNumberProvider];
	
	NSError *paymentError = [NSError errorWithDomain:@"PaymentError" code:500 userInfo:nil];
	NSURL *paymentAPI = [NSURL urlWithString:@"https://api.payment.com/charge/my/creditCard"];
	[self.chaosMonkey stubURL:paymentAPI returningError:paymentError]; // POSTS to payment API will randomly fail
	
	return YES;
}
```
