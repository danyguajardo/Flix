//
//  posterViewController.m
//  Flix
//
//  Created by danyguajiba on 6/27/19.
//  Copyright © 2019 danyguajiba. All rights reserved.
//

#import "posterViewController.h"
#import "UIImageView+AFNetworking.h"

@interface posterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation posterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.posterView = self.moviePoster;

//    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
//    NSString *posterURLString = self.posterView[@"poster_path"];
//    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
//    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
//    [self.posterView setImageWithURL:posterURL];

    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
