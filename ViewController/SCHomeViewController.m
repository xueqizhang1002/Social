//
//  SCHomeViewController.m
//  SocialApp
//
//  Created by Michelle on 12/27/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import "SCHomeViewController.h"
#import "SCPost.h"
#import "SCHomeTableViewCell.h"
#import "SCSignInViewController.h"
#import "SCUserManager.h"
#import <CoreLocation/CoreLocation.h>
#import "SCPostManager.h"
#import "SCLocationManager.h"
#import <MapKit/MapKit.h>
#import "SCCreatePostViewController.h"
#import "SCPostDetailViewController.h"
#import "SCSpinnerView.h"

static NSString * const SCHomeCellIdentifier = @"homeCellIdentifier";

@interface SCHomeViewController () <UITableViewDelegate, UITableViewDataSource, SCSignInViewControllerDelegate, SCCreatePostViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<SCPost *> *posts;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL resultMode;
@end

@implementation SCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupTableView];
    
    // load data
    //[self loadPosts];
    
    // show post list for SCExploreViewController
    if (self.resultMode) {
        [self setupTableView];
        return;
    }
    // load UI
    [self setupUI];
    
    // request location access
    [self updateLocation];
    
    // add observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosts) name:SCLocationUpdateNotification object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- public
- (void)loadResultPageWithPosts:(NSArray <SCPost *>*)posts {
    self.posts = posts;
    self.resultMode = YES;
    [self.tableView reloadData];
}

#pragma mark -- private
- (void)updateLocation {
    if (![SCLocationManager isLocationServicesEnabled]) {
        NSLog(@"notenabled");
    }
    if (![SCLocationManager isLocationServicesEnabled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location is required", nil) message:NSLocalizedString(@"Location is required for this app", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"OK");
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        SCLocationManager *locationManager = [SCLocationManager sharedManager];
        [locationManager startLoadUserLocation];
    }
}

- (void)updateUserLocation {
    [self loadPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    // check user login or not
    [self userLoginIfRequire];
}

#pragma mark -- setup UI
- (void)setupUI {
    [self setupTableView];
    [self setupNavigationBar];
    [self setupRefreshControlUI];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCHomeTableViewCell class]) bundle:nil] forCellReuseIdentifier:SCHomeCellIdentifier];
}

- (void)setupNavigationBar
{
    self.title = NSLocalizedString(@"Home", nil);
    self.navigationController.navigationBar.tintColor = [UIColor darkTextColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Addnew"] style:UIBarButtonItemStylePlain target:self action:@selector(showCreatePostPage)];
}

- (void)setupRefreshControlUI
{
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark -- Action
- (void)showCreatePostPage {
    SCCreatePostViewController *createPostViewController = [[SCCreatePostViewController alloc] initWithNibName:NSStringFromClass([SCCreatePostViewController class]) bundle:nil];
    createPostViewController.delegate = self;
    [self.navigationController pushViewController:createPostViewController animated:YES];

}

#pragma mark -- private
- (void)userLoginIfRequire {
    if (![[SCUserManager sharedUserManager] isUserLogin]) {
        SCSignInViewController *signInViewController = [[SCSignInViewController alloc] initWithNibName:NSStringFromClass([SCSignInViewController class]) bundle:nil];
        [self presentViewController:signInViewController animated:YES completion:nil];
    } else {
        [self loadPosts];
    }
}

#pragma mark -- API
- (void)loadPosts
{
    /*
    SCPost *post1 = [SCPost new];
    post1.name = @"Jonathan";//if your SCPost property "name", you need to update to post1.name =
    post1.message = @"Hi, my name is Jonathan.";
    SCPost *post2 = [SCPost new];
    post2.name = @"Steve";
    post2.message = @"Hi, nice to meet you!";
    SCPost *post3 = [SCPost new];
    post3.name = @"Jorge";
    post3.message = @"Do we have class today?";
    self.posts = @[post1, post2, post3];
    [self.tableView reloadData];
     */
    
    if (_resultMode) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SCSpinnerView presentSpinnerInView:self.view];
    CLLocation *location = [[SCLocationManager sharedManager] getUserCurrentLocation];
    NSInteger range = 5000;
    [SCPostManager getPostsWithLocation:location range:range andCompletion:^(NSArray<SCPost *> *posts, NSError *error) {
        [SCSpinnerView removeSpinner];
        if (posts) {
            weakSelf.posts = posts;
            [weakSelf.tableView reloadData];
            NSLog(@"get posts count:%ld", (long)posts.count);
        } else {
            NSLog(@"error: %@", error);
        }
    }];
    [self.refreshControl endRefreshing];
}

#pragma mark -- SCSignInViewControllerDelegate
- (void)loginSuccess
{
    [self loadPosts];
}

#pragma mark - SCCreatePostViewControllerDelegate
- (void)didCreatePost
{
    [self loadPosts];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCHomeCellIdentifier forIndexPath:indexPath];
    [cell loadCellWithPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SCHomeTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.posts.count > indexPath.row) {
        SCPost *post = [self.posts objectAtIndex:indexPath.row];
        SCPostDetailViewController *detailViewController = [[SCPostDetailViewController alloc] initWithNibName:NSStringFromClass([SCPostDetailViewController class]) bundle:nil];
        [detailViewController loadDetailViewWithPost:post];
        [self.navigationController pushViewController:detailViewController animated:YES];        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
