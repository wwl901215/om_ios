//
//  DownloadAppViewController.m
//  hybrid-demo
//
//  Created by syl on 2019/8/13.
//

#import "DownloadAppViewController.h"
#import "EnvIconFont.h"
#import "Strs.h"

@interface DownloadAppViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation DownloadAppViewController

- (instancetype)initWithRouterParams:(NSDictionary *)routerParams{
    self = [super initWithRouterParams:routerParams];
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupBackBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"download_title", nil);
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCurrentVersion"];
    if(!currentVersion) {
        currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString" ];
    }
    self.hintLabel.text = [NSString stringWithFormat:@"Version %@", currentVersion];
    NSString *image = [[NSBundle mainBundle] objectForInfoDictionaryKey:QR_IMAGE];
    self.imageView.image = [UIImage imageNamed:image];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupBackBtn {
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 42)];
    UIColor *textColor = [UIColor colorWithRed:34/255.0 green:42/255.0 blue:66/255.0 alpha:1.0];
    
    NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
    UIFont *font = [UIFont fontWithName:iconFontName size:16];
    headerButton.titleLabel.font=font;
    [headerButton setTitle:@"\ue929" forState:UIControlStateNormal];
    [headerButton setTitleColor:textColor forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:headerButton];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:NO];
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
