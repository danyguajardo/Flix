//
//  DetailsViewController.m
//  Flix
//
//  Created by danyguajiba on 6/26/19.
//  Copyright © 2019 danyguajiba. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "posterViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    [self.backdropView setImageWithURL:backdropURL];

    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie [@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
//    [__NSCFString absoluteURL]
    
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIButton *tappedButton = sender;
//    NSIndexPath *indexPath = [self.posterView indexPathForCell:tappedButton];
//    NSDictionary *movie = self.movies[indexPath.row];
    
    
    posterViewController *posterViewController = [segue destinationViewController];
    posterViewController.moviePoster = self.posterView;
}




@end
