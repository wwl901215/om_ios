//
//  MenuViewController.m
//  Wind
//
//  Created by syl on 2018/12/3.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "Router.h"
#import "PublicDefine.h"
#import "Persistent.h"
#import "AppSelectViewController.h"
#import "CollapsibleHeaderView.h"
#import "NormalHeaderFooterView.h"


@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSArray *menus;
@property (weak, nonatomic) IBOutlet UIView *menuTitle;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (nonatomic, strong) NSDictionary *pageParams;
@property (weak, nonatomic) IBOutlet UIView *changeAppView;
@property (weak, nonatomic) IBOutlet UIButton *goToSelectAppBtn;
@property (nonatomic, assign) int selectSection;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightIconLabel;

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorSubLabel;


@end

@implementation MenuViewController
- (instancetype)initWithRouterParams:(NSDictionary *) routerParams {
    self = [super init];
    if(self) {
        if(routerParams && [routerParams objectForKey:@"cur_menus"]) {
//            NSString *params = [routerParams objectForKey:@"cur_menus"];
//            NSString *menu = [params stringByRemovingPercentEncoding];
//            [[PublicDefine sharedInstance] setMenuSelect:menu];
        }
         //禁用自动根据navigationbar, statusbar 调整WebView的内容大小
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.menus = [[PublicDefine sharedInstance] getMenus];
//    [self.menuTableView reloadData];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuLabel.text = [[[PublicDefine sharedInstance] getAppSelect] objectForKey:@"name"];
    self.titleLabel.text = NSLocalizedString(@"MENU_TITLE", nil);
    NSMutableArray *menus = [NSMutableArray arrayWithArray:[[PublicDefine sharedInstance] getMenus]];
    if (menus && menus.count) {
        [self loadTableView:menus];
    }else{
        [self loadNoMenusView];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *apps = [[PublicDefine sharedInstance] getApps];
    if (apps && apps.count > 1) {
        [self.goToSelectAppBtn setTitle:NSLocalizedString(@"bnt_change_app", nil) forState:UIControlStateNormal];
        [self.goToSelectAppBtn addTarget:self action:@selector(goToSelectAppAction:) forControlEvents:UIControlEventTouchUpInside];
        self.rightIconLabel.font = [UIFont fontWithName:@"mapicon" size:15];
        self.rightIconLabel.text = @"\ue92a";
    }
    
    UIFont *font = [UIFont fontWithName:@"mapicon" size:20];
    self.settingBtn.titleLabel.font = font;
    [self.settingBtn setTitle:@"\ue931" forState:UIControlStateNormal];
    
    self.closeBtn.titleLabel.font = font;
    [self.closeBtn setTitle:@"\ue90b" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuChange:) name:@"menusChange" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSelectAppAction:)];
    [self.changeAppView addGestureRecognizer:tap];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)loadTableView:(NSArray *)menus {
    [self.view bringSubviewToFront:self.menuTableView];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MenuTableViewCell"];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"CollapsibleHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"CollapsibleHeaderView"];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"NormalHeaderFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"NormalHeaderFooterView"];
    self.menuLabel.font = [UIFont systemFontOfSize:18 weight:0.4];
    
    self.selectMenu = [[PublicDefine sharedInstance] getMenuSelect];
    
    self.menus = [self handleMenus:(NSMutableArray *)menus];
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    self.menuTableView.separatorStyle = UITableViewCellSelectionStyleGray;
    self.menuTableView.separatorColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:0.8];
    
}

- (void)loadNoMenusView {
    self.errorLabel.text = NSLocalizedString(@"no_permission", nil);
    self.errorSubLabel.text = NSLocalizedString(@"no_permission_desc", nil);
    [self.view bringSubviewToFront:self.errorView];
}

- (NSArray *)handleMenus:(NSMutableArray *)menus {
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *app in menus) {
        NSMutableDictionary *mutaApp = [NSMutableDictionary dictionaryWithDictionary:app];
        [mutaApp setValue:@(true) forKey:@"isOpen"];
        [result addObject:mutaApp];
    }
    return result;
}

- (void)handleMenuChange:(NSNotification *)nofi {
    self.menus = [[PublicDefine sharedInstance] getMenus];
    [self.menuTableView reloadData];
}


- (void)goToSelectAppAction:(UITapGestureRecognizer *)sender {
//    AppSelectViewController *appVC = [[AppSelectViewController alloc] initWithNibName:@"AppSelectViewController" bundle:[NSBundle mainBundle]];
//    [self presentViewController:appVC animated:YES completion:nil];
    [Router open:@"/apps"];
}



- (NSString *)getLocalLanguage{
    NSString *languageName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
    if([languageName hasPrefix:@"en"]){
        return @"EN";
    }else if ([languageName hasPrefix:@"zh"]){
        return @"CH";
    }
    return @"EN";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissAciton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //如果是push出来的，那就pop回去
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menus.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *sectionMenu = self.menus[section];
    BOOL isOpen = [[sectionMenu objectForKey:@"isOpen"] boolValue];
    NSArray *menuArr = [sectionMenu objectForKey:@"children"];
    if (isOpen) {
        return menuArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.menus[section] objectForKey:@"name" ];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil] firstObject];
    }
    
    NSDictionary *section = self.menus[indexPath.section];
    NSArray *menuArr = [section objectForKey:@"children"];
    BOOL isOpen = [[section objectForKey:@"isOpen"] boolValue];
    if (isOpen) {
        NSDictionary *menu = menuArr[indexPath.row];
        cell.titleLabel.text = [menu objectForKey:@"name"];
        if([self.selectMenu isEqualToString:[menu objectForKey:@"url"]]){
            UIImageView *preselect = cell.checkBox.subviews[0];
            [preselect setImage:[UIImage imageNamed:@"preselect.png"]];
            cell.titleLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:21/255.0 alpha:1.0];
        }else{
            NSArray *subviews = cell.checkBox.subviews;
            if (subviews.count) {
                UIImageView *preselect = cell.checkBox.subviews[0];
                [preselect setImage:[UIImage new]];
                 cell.titleLabel.textColor = [UIColor colorWithRed:95/255.0 green:95/255.0 blue:107/255.0 alpha:1.0];
                cell.checkBox.backgroundColor = [UIColor clearColor];
            }
        };
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        return cell;
    }else{
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 40, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkBox.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *section = self.menus[indexPath.section];
    NSArray *menuArr = [section objectForKey:@"children"];
    NSDictionary *menu = menuArr[indexPath.row];
    NSString *url = [menu objectForKey:@"url"];
    [[PublicDefine sharedInstance] setMenuSelect:url];
    [[PublicDefine sharedInstance] setMenuSelectSection:indexPath.section];

    @try {
         [Router open:[menu objectForKey:@"url"]];
    } @catch (NSException *exception) {
         [Router open:ERROR_ROUTE];
    } @finally {
        
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkBox.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 根据section的 data是否有url和children来显示不同的header
    NSDictionary *sectionData  = self.menus[section];
    NSString *url = [sectionData objectForKey:@"url"];
    NSString *selectMenu = [[PublicDefine sharedInstance] getMenuSelect];
    // 如果没有url，那么显示可收缩的样式
    if (!url.length) {
        CollapsibleHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CollapsibleHeaderView"];
        if (!headerView) {
            headerView = [[NSBundle mainBundle] loadNibNamed:@"CollapsibleHeaderView" owner:self options:nil][0];
        }
        headerView.titleLabel.text = [sectionData objectForKey:@"name"];
        // 判断当前url所在的section
        NSUInteger sec = [[PublicDefine sharedInstance] getMenuSelectSection];
        if (sec == section) {
            headerView.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:132/255.0 blue:255/255.0 alpha:1.0];
        }else{
             headerView.titleLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:21/255.0 alpha:1.0];
        }
        if (section == 0) {
            headerView.topLine.backgroundColor = [UIColor whiteColor];
        }
        
        headerView.isOpen = [[sectionData objectForKey:@"isOpen"] boolValue];
        UIFont *font = [UIFont fontWithName:@"mapicon" size:17];
        headerView.arrowBtn.titleLabel.font = font;
        [headerView.arrowBtn setTintColor:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:107/255.0 alpha:1.0]];
        if (headerView.isOpen) {
            [headerView.arrowBtn setTitle:@"\ue906" forState:UIControlStateNormal];
        }else{
            [headerView.arrowBtn setTitle:@"\ue903" forState:UIControlStateNormal];
            headerView.downLine.backgroundColor = [UIColor whiteColor];
        }
        headerView.titleLabel.text =  [sectionData objectForKey:@"name"];
        headerView.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
        headerView.section = section;
        headerView.openblock = ^(NSUInteger section) {
            [self openSection: section];
        };
        headerView.closeblock = ^(NSUInteger section) {
            [self closeSection: section];
        };
        return headerView;
    }
    else{ // 如果有url，且没有children 那么显示普通的可点击样式
        NormalHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NormalHeaderFooterView"];
        if (!header) {
            header = [[NSBundle mainBundle] loadNibNamed:@"NormalHeaderFooterView" owner:self options:nil][0];
        }
        header.contentView.backgroundColor = [UIColor whiteColor];
        if ([selectMenu isEqualToString:url]) {
            UIImageView *preselect = header.checkView.subviews[0];
            [preselect setImage:[UIImage imageNamed:@"preselect.png"]];
        }else {
            UIImageView *preselect = header.checkView.subviews[0];
            [preselect setImage:[UIImage new]];
        }
        header.titleLabel.text =  [sectionData objectForKey:@"name"];
        header.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
        header.url = url;
        header.clickblock = ^(NSString *url) {
            if (url) {
                [[PublicDefine sharedInstance] setMenuSelect:url];
                [Router open:url];
            }
        };
        
        return header;
    }
    
    return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"";
//}

- (void)openSection:(NSUInteger)section {
    
    NSMutableDictionary *sectionData = [NSMutableDictionary dictionaryWithDictionary:self.menus[section]];
    [sectionData setValue:@(true) forKey:@"isOpen"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.menus];
    [mutableArr replaceObjectAtIndex:section withObject:sectionData];
    self.menus = mutableArr;
    [UIView animateWithDuration:0.15 animations:^{
        CollapsibleHeaderView *headerView = (CollapsibleHeaderView *)[self.menuTableView headerViewForSection:section];
        headerView.arrowBtn.titleLabel.transform = CGAffineTransformMakeRotation(M_PI-0.001);
//        [headerView.arrowBtn setTitle:@"\ue903" forState:UIControlStateNormal];
    }];
  [self.menuTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.menuTableView) {
        CGFloat sectionHeaderHeight = 44;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }else if (scrollView.contentOffset.y >= sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
}

- (void)closeSection:(NSUInteger)section {
    NSMutableDictionary *sectionData = [NSMutableDictionary dictionaryWithDictionary:self.menus[section]];
    [sectionData setValue:@(false) forKey:@"isOpen"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.menus];
    [mutableArr replaceObjectAtIndex:section withObject:sectionData];
    self.menus = mutableArr;
    [UIView animateWithDuration:0.15 animations:^{
        CollapsibleHeaderView *headerView = (CollapsibleHeaderView *)[self.menuTableView headerViewForSection:section];
        headerView.arrowBtn.titleLabel.transform = CGAffineTransformMakeRotation(M_PI-0.001);
//        [headerView.arrowBtn setTitle:@"\ue906" forState:UIControlStateNormal];

    }];
    [self.menuTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}
- (IBAction)goToSettingPage:(UIButton *)sender {
    [Router open:@"/setting/index.html"];
}







@end
