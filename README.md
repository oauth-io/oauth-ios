OAuth.io iOS SDK
=======================

This is the iOS SDK for [OAuth.io](https://oauth.io). OAuth.io allows you to integrate **100+ providers** really easily in your web app, without worrying about each provider's OAuth specific implementation.

You can learn about how to integrate this framework in your project by following the easy steps of our github-based tutorial: [Start here :)](https://github.com/oauth-io/sdk-ios-tutorial)

Installation
============

Getting the SDK
---------------

To install this SDK in your iOS app, you can either:

- Get the framework from Cocoapods
- Install the framework by hand in XCode

Both options are pretty simple.

**Installing via Cocoapods**

To install the SDK via Cocoapods, just add this entry to your Podfile:

```ruby
pod "OAuth.io"
```

Then run the following command:

```sh
$ pod update
```

This will get the framework for you and install it as a project dependency. Once that's done you can get on with the code.

**Installing the framework manually**

The framework is available in this repository as the `Dist/OAuthiOS.framework` file. To add it as a dependency in your projet in XCode, follow this procedure:
- click on the project name in the Documents explorer
- go to **Build phases**
- open the **Link Binary with Libraries** section
- click on the **+** button
- click on **Add other...**
- Select the `OAuthiOS.framework`
- Click on **Add**

Then you can get on with the code.

Usage
=====

This SDK allows you to show a popup to let the user log in for a given OAuth provider.

Before you start, make sure you have an account on [OAuth.io](https://oauth.io), and that you have created an app configured with the provider you need in your dashboard. To use this SDK, you'll need that app's public key.

Includes
--------

There is only one header file you need to include to use this SDK:

`#import <OAuthiOS/OAuthiOS.h>`

This header contains references to all the classes you will need to use it.

Authentication process
------------------------------------------------

To initialize the SDK, you need to create an `OAuthIOModal` instance, and initialize it with your app public key and a delegate, which must implement the `OAuthIODelegate` protocol. This delegate will let you handle the results of the authentication process in the form of a request object, that will also allow you to perform API calls.

This protocol requires that your delegate implements the following methods:

```Objective-C
// Handles the results of a successful authentication
- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request;

// Handle errors in the case of an unsuccessful authentication
- (void)didFailWithOAuthIOError:(NSError *)error;
```

If you are using a `UIViewController` as delegate, its header file will look  like this:

```Objective-C
#import <UIKit/UIKit.h>
#import <OAUthiOS/OAuthiOS.h>
@interface MyViewController : UIViewController<OAuthIODelegate>
//[...]
@end
```

In that view controller, when you need to show the popup, you can initialize the `OAuthIOModal` object with your public key like this:

```Objective-C
OAuthIOModal *oauthioModal = [[OAuthIOModal alloc] initWithKey:@"your_app_public_key" delegate:self];
```

Then you can show the popup for the needed provider like this:

```Objective-C
[oauthioModal showWithProvider:@"facebook"];
```

Once the user has logged in to the provider and accepted the permissions you asked in your [OAuth.io Dashboard](https://oauth.io/dashboard), the `didReceiveOAuthIOResponse` method is called, and you can use the `request` object to either retrieve the access token with the `getCredentials` method and work with it on your own, or perform API calls with the `get|post|put|patch|del|me` methods.

**Using the cache**

It is possible to cache the results of the authentication step to prevent the popup from showing everytime the user relaunches the app. To do that, you need to pass the cache option to the modal like this:

```Objective-C
NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
[options setObject:@"true" forKey:@"cache"];
[oauthioModal showWithProvider:@"facebook" options:options];
```

**Getting the user credentials**

Once you got the `request` object from the authentication process, you can retrieve the user credentials (access_token for OAuth 2, oauth_token and oauth_token_secret for OAuth 1) like this:

```
NSDictionary *credentials = [request getCredentials];
```

Performing API calls
--------------------

The `request` object allows you to perform API calls using the standard HTTP methods `GET`, `POST`, `PUT`, `PATCH`, `DELETE`. You can also retrieve a unified object containing the user's information (name, email, etc.) by using the `me` method.

**GET Request**

Let's say that the provider exposes an endpoint on the `/blogpost/:id` URL, that returns the title and the content of a blogpost:

```Objective-C
[_request get:@"/blogpost/1" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
     NSLog(@"%@", [output objectForKey: @"title"]);
     NSLog(@"%@", [output objectForKey: @"content"]);
 }];
```

**POST Request**

Let's say that the provider exposes an endpoint on the `/comment` URL, that waits for a POST request containing the field `content` with the content of a comment, and returns the field `id`, containing the id of the new comment:

```Objective-C
NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
[fields setObject: @"Nice blogpost" forKey:@"content"];

[_request post:@"/blogpost/1" withParams:fields success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
     NSLog(@"%@", [output objectForKey: @"id"]);
 }];
```

**PUT Request**

Let's say that the provider exposes an endpoint on the `/comment/:id` URL, that waits for a PUT request containing the field `content` with the content to edit a comment, and returns `true` if the edition worked:

```Objective-C
NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
[fields setObject: @"Nice blogpost" forKey:@"content"];

[_request put:@"/blogpost/1" withParams:fields success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
    //Should print "true"
     NSLog(@"%@", body);
 }];
```

**PATCH Request**

Let's say that the provider exposes an endpoint on the `/comment/:id` URL, that waits for a PATCH request containing the field `content` with the content to edit a comment, and returns `true` if the edition worked:

```Objective-C
NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
[fields setObject: @"Nice blogpost" forKey:@"content"];

[_request patch:@"/blogpost/1" withParams:fields success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
    //Should print "true"
     NSLog(@"%@", body);
 }];
```

**DELETE Request**

Let's say that the provider exposes an endpoint on the `/blogpost/:id` URL, that waits for a `DELETE` request to remove the blogpost, and returns `true` if the deletion worked:

```Objective-C
[_request del:@"/blogpost/1" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
     //Should print "true"
     NSLog(@"%@", body);
 }];
```

**Getting the user's information**

If you need to get a dictionary containing unified fields with the user's information, regardless of the provider's implementation (e.g. get a `firstname` field, wether the provider returns `first-name`, `first_name` or `firstName`), you can call the `me` method like this:

```Objective-C
[_request me:nil success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
     NSLog(@"name: %@", [output objectForKey:@"name"]);
 }];
```

The fields that are not mapped into unified fields are still available in the one called `raw`.

You can filter the fields returned by this method by passing a `NSArray` containing a list of fields:

```Objective-C
 NSMutableArray *filter = [[NSMutableArray alloc] init];
[filter addObject:@"name"];
[filter addObject:@"email"];
[_request me:filter success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
 {
    NSLog(@"name: %@", [output objectForKey:@"name"]);
 }];
```

Notes on the server-side flow
=============================

If you're planning to use OAuth.io from your back-end thanks to one of our server-side SDKs, the usage of this SDK is a bit different.

First, a little reminder of the server-side flow, in which all API calls are performed server-side, as well as authentication (thanks to a code retrieved in the front-end). The server-side flow involves the following steps:

- Retrieving of a state token from your back-end in your front-end
- Launching the authentication popup in the front-end, with the state token, gives back a code
- Sending the code back to the back-end
- Authenticating in the back-end thanks to the code
- Performing API calls in the back-end

Thus, in your back-end, you need two endpoints:

- one for the state token (GET)
- one for the authentication (POST with the code as parameter)

In the iOS SDK, the calls to these endpoints are performed automatically. All you need to do is give their URLs to the `showWithProvider` method like this:

```Objective-C
[_oauthioModal showWithProvider:@"facebook" options:options stateTokenUrl:@"http://example/state/url" authUrl:@"http://example/auth/url"];
```

This will first call the state URL, then show the authentication popup to the user, get the code, and finally send the code to the authentication URL.

To know when the process is done, you need to add the following methods to your OAuthIODelegate class:

```Objective-C
- (void)didAuthenticateServerSide:(NSString *)body andResponse:(NSURLResponse *) response;
- (void)didFailAuthenticationServerSide:(NSString *)body andResponse:(NSURLResponse *)response andError:(NSError *)error;
```

The first one will catches a successfull authentication (which usually means the authentication URL returned "200 OK") and give you the body and response objects it got from that URL. The second one will catch errors (state token not found, unsucessfull authentication).


Contributing
============

**Issues**

Feel free to post issues if you have problems while using this SDK.

**Pull requests**

You are welcome to fork and make pull requests. We appreciate the time you spend working on this project and we will be happy to review your code and merge it if it brings nice improvements :)

If you want to do a pull request, please mind these simple rules :

- *One feature per pull request*
- *Write lear commit messages*
- *Unit test your feature* : if it's a bug fix for example, write a test that proves the bug exists and that your fix resolves it.
- *Write a clear description of the pull request*

If you do so, we'll be able to merge your pull request more quickly :)

License
=======

This SDK is published under the Apache2 License.


---------------------

More information is available in [oauth.io documentation](http://oauth.io/#/docs)
