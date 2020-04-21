//
//  LeftMenuViewController.m
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/15.
//

#import "LeftMenuViewController.h"
#import "SlideMenu.h"
#import "UIViewController+SlideMenu.h"
#import "Router.h"
#import "Persistent.h"
#import "PublicDefine.h"


#define BACKGROUND_COLOR [UIColor colorWithRed:27/255.0 green:35/255.0 blue:56/255.0 alpha:1]
#define TABLE_LIST_WIDTH [UIScreen mainScreen].bounds.size.width * 0.8 - 64
#define MENU_HEIGTH [UIScreen mainScreen].bounds.size.height

@interface LeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * menuTable;
@property (nonatomic,strong) NSArray * menuList;
@property (nonatomic,strong) UIButton * settingBtn;

@end

@implementation LeftMenuViewController

-(NSArray *) menuList {
    if(!_menuList){
//        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"menu" ofType:@"json"];
//        NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        NSData *jsonData = [[NSData alloc]initWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
//        _menuList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *menusDic = [Persistent readFromFile:@"menus_info"];
//        _menuList = [menusDic objectForKey:@"menus"];
        _menuList = [[PublicDefine sharedInstance] getMenus];
    }
    return _menuList;
}

-(UITableView *) menuTable {
    if(!_menuTable){
        _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(32, 76, TABLE_LIST_WIDTH,MENU_HEIGTH) style:UITableViewStylePlain];
        _menuTable.separatorStyle = NO;
        _menuTable.backgroundColor = BACKGROUND_COLOR;
    }
    return  _menuTable;
}

-(UIButton *) settingBtn {
    if(!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.frame = CGRectMake(12, 12, 100, 60);
        _settingBtn.backgroundColor = [UIColor clearColor];
        [_settingBtn setImage:[UIImage imageNamed:@"setting.png"]forState:UIControlStateNormal];
        _settingBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 55);
        [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[UIColor colorWithRed:100/255.0 green:112/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
        _settingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        _settingBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    return _settingBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.menuList.count){
        [self.menuTable reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.menuTable];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    [self.settingBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingBtn];
}
-(void)settingAction{
    [self.env_slideMenu showRootViewControllerAnimated:true];
    [Router open:@"/setting"];
}


#pragma UITableViewDelagate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.env_slideMenu showRootViewControllerAnimated:true];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectRowAtIndexPath" object:@{@"section":@(indexPath.section), @"row":@(indexPath.row)}];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *url;
    for (NSDictionary *dic in self.menuList) {
        NSString *id = [dic objectForKey:@"id"];
        if (id.integerValue == section) {
            NSArray *children = [dic objectForKey:@"children"];
            NSDictionary *paramsDic = children[row];
            url = [paramsDic objectForKey:@"url"];
        }
    }
    [Router open:url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString * title = [self.menuList[section] objectForKey:@"title"];
    UILabel * label = [[UILabel alloc]init];
    label.textColor = [UIColor colorWithRed:100/255.0 green:112/255.0 blue:137/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    return label;
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * sectionArray = [self.menuList[section] objectForKey:@"children"];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"meunCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }
    NSArray *list = [_menuList[indexPath.section]objectForKey:@"children"];
    cell.textLabel.text =  [list[indexPath.row]objectForKey:@"title"];
    cell.textLabel.textColor = [UIColor colorWithRed:174/255.0 green:185/255.0 blue:200/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = BACKGROUND_COLOR;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = BACKGROUND_COLOR;
    cell.textLabel.highlightedTextColor= [UIColor colorWithRed:31/255.0 green:190/255.0 blue:255/255.0 alpha:1];
    if(indexPath.row == 0){
        UIView * separator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TABLE_LIST_WIDTH, 1)];
        separator.backgroundColor = [UIColor colorWithRed:39/255.0 green:47/255.0 blue:67/255.0 alpha:1];
        [cell addSubview:separator];
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
