//
//  MoviesGridViewController.m
//  Flix
//
//  Created by danyguajiba on 6/26/19.
//  Copyright © 2019 danyguajiba. All rights reserved.
//

#import "MoviesGridViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionViewCell *collectionView;

@end


@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
    // Do any additional setup after loading the view.
}

-(void) fetchMovies {
    // Do any additional setup after loading the view.
    //    netwroking code
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog (@"%@", dataDictionary);
            self.movies = dataDictionary[@"results"];
            
            for(NSDictionary *movie in self.movies){
                NSLog(@"%@", movie[@"title"]);
            }
            
//            [self.tableView reloadData];
            
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
//        [self.activityIndicator stopAnimating];
//        [self.refreshControl endRefreshing];
    }];
    [task resume];
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
