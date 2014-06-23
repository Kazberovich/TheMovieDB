//
//  WebViewController.m
//  TheMovieDbClient
//
//  Created by mac-214 on 18.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "WebViewController.h"
#import "ApiLoadService.h"
#import "MainViewController.h"
#import "DownloadHelper.h"

@implementation WebViewController

@synthesize webView = _webView;
@synthesize indicator = _indicator;

- (void) dealloc
{
    NSLog(@"WebViewController dealloc");
    [_indicator release];
    [_webView release];
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Account";
    [_indicator startAnimating];
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* tmdbCookies = [cookies cookiesForURL:
                                [NSURL URLWithString:kAuthentificationURL]];
    
    for (NSHTTPCookie* cookie in tmdbCookies) {
        [cookies deleteCookie:cookie];
    }
    
    [ApiLoadService getResponseForURL:[NSURL URLWithString:kGetTokenRequestBody] callback:^(NSDictionary *dictionary, NSURL *url) {
        
        NSLog(@"%@", dictionary);
        NSString *newToken = nil;
        if(!dictionary)
        {
            NSLog(@"Smth wrong.");
        }
        else
        {
            newToken = (NSString*)[dictionary objectForKey:@"request_token"];
            NSLog(@"newToken: %@", newToken);
            [newToken retain];
            if(!newToken)
            {
                NSLog(@"incorrect  newToken");
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:@"token"];
                NSURLRequest *reqURL = [NSURLRequest requestWithURL:[NSURL URLWithString:[kAuthentificationURL stringByAppendingString:newToken]]];
                [_webView loadRequest:reqURL];
                [newToken release];
            }
        }
        
    }];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Start with URL");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    NSLog(@"header %@",[(NSHTTPURLResponse*)resp.response allHeaderFields]);
    
    NSString *authCallback = [[(NSHTTPURLResponse*)resp.response allHeaderFields] objectForKey:@"Authentication-Callback"];
    
    if(authCallback)
    {
        [ApiLoadService getResponseForURL:[NSURL URLWithString: authCallback] callback:^(NSDictionary *dictionary, NSURL *url) {
            NSLog(@"session %@", dictionary);
            
            if(!dictionary)
            {
                NSLog(@"session id was not created");
            }
            else if ([dictionary objectForKey:@"session_id"])
            {
                NSLog(@"session_id = %@", [dictionary objectForKey:@"session_id"]);
                [[NSUserDefaults standardUserDefaults] setObject:(NSString*)[dictionary objectForKey:@"session_id"] forKey:@"session_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Log in" message: @"Login is successful" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                
                [someError show];
                [someError release];
                
                // delete viewcontoller
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        [_indicator stopAnimating];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    [_indicator stopAnimating];
    
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Log in" message: @"Unable to load the page" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    
    [someError show];
    [someError release];
}


@end
