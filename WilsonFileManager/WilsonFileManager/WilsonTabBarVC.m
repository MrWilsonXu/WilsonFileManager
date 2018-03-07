//
//  WilsonTabBarVC.m
//  WilsonFileManager
//
//  Created by Wilson on 07/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WilsonTabBarVC.h"
#import "FileManagerVC.h"

@interface WilsonTabBarVC ()

@end

@implementation WilsonTabBarVC

- (void)loadView {
    [super loadView];
    [self customRootVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTabbarItem];
}

- (void)customRootVC {
    
    FileManagerVC *fileVC = [[FileManagerVC alloc] init];
    UINavigationController *nvaFile = [[UINavigationController alloc] initWithRootViewController:fileVC];
    
    self.viewControllers = nil;
    self.viewControllers = [NSArray arrayWithObjects:nvaFile, nil];
    
    [self setTabBarItem:nvaFile.tabBarItem normalImage:@"ico_tabFile_nor" selectedImage:@"ico_tabFile_sel" title:@"File"];
   
    [self.viewControllers makeObjectsPerformSelector:@selector(view)];
    self.selectedIndex = 0;
}

#pragma mark - Helper

- (void)customTabbarItem {
    UITabBarItem *tabItem = [UITabBarItem appearance];
    [tabItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [tabItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[UIColor ColorWithHex:@"#ED4836"]} forState:UIControlStateSelected];
}

- (void)setTabBarItem:(UITabBarItem *)item normalImage:(NSString *)normalName selectedImage:(NSString *)selectedName title:(NSString *)title {
    UIImage *normalImg = [[UIImage imageNamed:normalName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImg = [[UIImage imageNamed:selectedName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.image = nil;
    item.image = normalImg;
    item.selectedImage = nil;
    item.selectedImage  = selectedImg;
    item.title = title;
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
