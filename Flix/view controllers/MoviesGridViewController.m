//
//  MoviesGridViewController.m
//  Flix
//
//  Created by danyguajiba on 6/26/19.
//  Copyright © 2019 danyguajiba. All rights reserved.
//


#import "DetailsViewController.h"
#import "MoviesGridViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.searchBar.delegate = self;
    self.filteredMovies = self.movies;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchMovies {
    
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
        // error
        // runs when network request comes back
        if (error != nil)
            NSLog(@"%@", [error localizedDescription]);
        
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.movies = dataDictionary[@"results"];
            self.filteredMovies = self.movies;
        }
            
        [self.collectionView reloadData];
    }];
    
    [task resume];
}

//#pragma mark - Navigation

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    NSLog(@"%@", movie[@"title"]);
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];

    
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil when the image is cached
         if (imageResponse) {
            NSLog(@"Image was NOT cached, fade in image");
            cell.posterView.alpha = 0.0;
            cell.posterView.image = image;
                                            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
            cell.posterView.alpha = 1.0;
    }];
        }
        else {
            NSLog(@"Image was cached so just update the image");
            cell.posterView.image = image;} }
            failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"title"] uppercaseString] containsString:[searchText uppercaseString]];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
                
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.collectionView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


@end


//#import "MoviesGridViewController.h"
//#import "MovieCollectionViewCell.h"
//#import "UIImageView+AFNetworking.h"
//#import "DetailsViewController.h"
//
//
//@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
//
//@property (nonatomic, strong) NSArray *movies;
//
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) NSArray *filteredMovies;
//
//@end
//
//
//@implementation MoviesGridViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
//
//    self.searchBar.delegate = self;
//    self.filteredMovies = self.movies;
//
//    [self fetchMovies];
//
//
//    // Do any additional setup after loading the view.
//
////    decide how many movies per row
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
//    CGFloat width = self.collectionView.frame.size.width / 3;
//    CGFloat height = width * 1.5;
//    layout.itemSize = CGSizeMake(width, height);
//}
//
//-(void) fetchMovies {
//    // Do any additional setup after loading the view.
//    //    netwroking code
//    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error != nil) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        else {
//            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//            self.movies = dataDictionary[@"results"];
//
//            [self.collectionView reloadData];
//
//
////            [self.tableView reloadData];
//
//            // TODO: Get the array of movies
//            // TODO: Store the movies in a property to use elsewhere
//            // TODO: Reload your table view data
//        }
////        [self.activityIndicator stopAnimating];
////        [self.refreshControl endRefreshing];
//    }];
//    [task resume];
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(@"MovieCollectionViewCell") forIndexPath:indexPath];
//
//    NSDictionary *movie = self.movies[indexPath.item];
//
//    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
//    NSString *posterURLString = movie[@"poster_path"];
//    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
//
//
//    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
//
//    [cell.posterView setImageWithURL:posterURL];
//
//
//    return cell;
//}
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.filteredMovies.count;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//    if (searchText.length != 0) {
//
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
//            return [[evaluatedObject[@"title"] uppercaseString] containsString:[searchText uppercaseString]];
//        }];
//        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
//
//        //        NSLog(@"%@", self.filteredMovies);
//
//    }
//    else {
//        self.filteredMovies = self.movies;
//    }
//
//    [self.collectionView reloadData];
//
//}
//
////-(NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
////    return self.movies.count;
////}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    UITableViewCell *tappedCell = sender;
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
//    NSDictionary *movie = self.movies[indexPath.row];
//
//
//    DetailsViewController *detailsViewController = [segue destinationViewController];
//    detailsViewController.movie = movie;
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.searchBar.showsCancelButton = YES;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    self.searchBar.showsCancelButton = NO;
//    self.searchBar.text = @"";
//    [self.searchBar resignFirstResponder];
//}
//
//@end
