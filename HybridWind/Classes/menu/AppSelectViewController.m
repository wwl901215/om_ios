//
//  AppSelectViewController.m
//  HybridWind
//
//  Created by syl on 2019/11/20.
//

#import "AppSelectViewController.h"
#import "Strs.h"
#import "Router.h"
#import "MenuTableViewCell.h"
#import "PublicDefine.h"
#import "MenuService.h"
#import "ReuseCollectionViewCell.h"
#import "EnvIconFont.h"
#import "UIImage+SVG.h"

@interface AppSelectViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *appCollectionView;

@end

@implementation AppSelectViewController

- (void)viewDidLoad {
    
//    UIFont *font1 = [UIFont fontWithName:@"mapicon" size:20];
    UIFont *font2 = [UIFont fontWithName:@"mapicon" size:20];

//    self.closeBtn.titleLabel.font = font1;
    self.backBtn.titleLabel.font = font2;
//    [self.closeBtn setTitle:@"\ue90b" forState:UIControlStateNormal];
    [self.backBtn setTitle:@"\ue901" forState:UIControlStateNormal];

//    [self.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = NSLocalizedString(@"title_change_app", nil);
    
    self.appCollectionView.delegate = self;
    self.appCollectionView.dataSource = self;
    self.appCollectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 42)/2, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.appCollectionView setCollectionViewLayout:layout];
    [self.appCollectionView registerNib:[UINib nibWithNibName:@"ReuseCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ReuseCollectionViewCell"];
    
    self.apps = [[PublicDefine sharedInstance] getApps];
    // Do any additional setup after loading the view from its nib.
}

- (void)closeAction:(UIButton *)btn {
    // 直接点击close，回到原来的home页面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction:(UIButton *)btn {
    // 返回菜单页
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 保存选中的app
    NSDictionary *app = self.apps[indexPath.row];
    // 判断是否是当前已选中app
    NSDictionary *currentApp = [[PublicDefine sharedInstance] getAppSelect];
    NSString *currentAppId = [currentApp objectForKey:@"id"];
    NSString *selectAppId = [app objectForKey:@"id"];
    if ([currentAppId isEqualToString:selectAppId]) {
        return;
    }else{
        [[PublicDefine sharedInstance] setAppSelect:app];
        // 请求该app下的menu菜单
        [[MenuService sharedService] getMenuListAndOpenDefaultMenu:[app objectForKey:@"id"]];
    }
}


#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.apps.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *app = self.apps[indexPath.row];
    NSString *selectApp = [[PublicDefine sharedInstance] getAppSelect][@"id"];
    ReuseCollectionViewCell *cell = (ReuseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ReuseCollectionViewCell" owner:self options:nil].firstObject;
    }
    NSArray *subviews = cell.bgView.layer.sublayers;
    CALayer *gradiLayer = [self getGradientLayer:subviews];
    if (gradiLayer) {
        [gradiLayer removeFromSuperlayer];
    }
    
    if ([selectApp isEqualToString:[app objectForKey:@"id"] ]) {
        cell.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];

        // 渐变色
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = cell.bounds;
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:9/255.0 green:157/255.0 blue:255.0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:132/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.locations = @[@0,@1];
        [cell.bgView.layer addSublayer:gradientLayer];
    }else{
        cell.titleLabel.textColor = [UIColor colorWithRed:4/255.0 green:142/255.0 blue:255/255.0 alpha:1.0];
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = cell.bounds;
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:9/255.0 green:157/255.0 blue:255.0/255.0 alpha:0.08].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:132/255.0 blue:255/255.0 alpha:0.08].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.locations = @[@0,@1];
        [cell.bgView.layer addSublayer:gradientLayer];
    }
    [cell.bgView bringSubviewToFront:cell.titleLabel];
    cell.titleLabel.text = [app objectForKey:@"name"];

    return cell;
    
}

- (CALayer *)getGradientLayer:(NSArray *)subviews {
    for (CALayer *layer in subviews) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            return layer;
        }
    }
    return nil;
    
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
