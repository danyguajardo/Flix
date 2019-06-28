//
//  webViewController.m
//  Flix
//
//  Created by danyguajiba on 6/28/19.
//  Copyright © 2019 danyguajiba. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "webViewController.h"
#import "DetailsViewController.h"

@interface webViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webKitView;
@property (strong, nonatomic) NSString *trailerURL;


@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchTrailer];
}

-(void) fetchTrailer {
    NSString *gettrailerURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1", self.movieUnique];
    
    NSURL *apiURL = [NSURL URLWithString:gettrailerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
           {
               if (error != nil)
               NSLog(@"%@", [error localizedDescription]);
             
              else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *trailer = dataDictionary[@"results"][0];
                self.trailerURL = [@"https://www.youtube.com/watch?v=" stringByAppendingString: trailer[@"key"]];
                NSURL *url = [NSURL URLWithString:self.trailerURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
                [self.webKitView loadRequest:request];
                }
        }];
    [task resume];
}

@end
