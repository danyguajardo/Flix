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
@property (strong, nonatomic) NSArray *searchedMovies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.searchBar.delegate = self;
    self.searchedMovies = self.movies;
    
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
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];
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
            self.searchedMovies = self.movies;
        }
            
        [self.collectionView reloadData];
    }];
    
    [task resume];
}

//#pragma mark - Navigation

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.searchedMovies[indexPath.row];
    NSLog(@"%@", movie[@"title"]);
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL:posterURL];


    
//    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
//    [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
//        // imageResponse will be nil when the image is cached
//         if (imageResponse) {
//            NSLog(@"Image was NOT cached, fade in image");
//            cell.posterView.alpha = 0.0;
//            cell.posterView.image = image;
//
//            //Animate UIImageView back to alpha 1 over 0.3sec
//            [UIView animateWithDuration:0.3 animations:^{
//            cell.posterView.alpha = 1.0;
//    }];
//        }
//        else {
//            NSLog(@"Image was cached so just update the image");
//            cell.posterView.image = image;} }
//            failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
//    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchedMovies.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"title"] uppercaseString] containsString:[searchText uppercaseString]];
        }];
        self.searchedMovies = [self.movies filteredArrayUsingPredicate:predicate];
                
    }
    else {
        self.searchedMovies = self.movies;
    }
    
    [self.collectionView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.searchedMovies[indexPath.row];
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    
}
@end
