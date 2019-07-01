//
//  MoviesViewController.m
//  Flix
//
//  Created by danyguajiba on 6/26/19.
//  Copyright © 2019 danyguajiba. All rights reserved.
//

#import "MoviesViewController.h"
#import "movieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *searchedMovies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating];
    self.tableView.rowHeight = UITableViewAutomaticDimension;


    self.searchBar.delegate = self;
    self.searchedMovies = self.movies;
    
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
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
            
// alert begins here
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No connection" preferredStyle:(UIAlertControllerStyleAlert)];
            // create a cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ignore"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle cancel response here. Doing nothing will dismiss the view.
                                                                 }];
            // add the cancel action to the alertController
            [alert addAction:cancelAction];
            
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            self.searchedMovies = self.movies;

        }
        [self.tableView reloadData];

        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];

    }];
    [task resume];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:
//    (NSInteger) section{
//    return 20;
//}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchedMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    movieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    
    NSDictionary *movie = self.searchedMovies[indexPath.row];
//    NSLog (@"%@", [NSString stringWithFormat: @"row: %d, section %d", indexPath.row, indexPath.section]);
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];

    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
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
    
    [self.tableView reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];


    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    
}

@end
