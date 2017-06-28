//
//  ZFNavigtionViewController.m
//  ZFNavigationContoller
//
//  Created by xinshiyun on 2017/6/28.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFNavigtionViewController.h"

@interface ZFNavigtionViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ZFNavigtionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"interactivePopGestureRecognizer.delegate = %@",self.interactivePopGestureRecognizer.delegate);
    NSLog(@"interactivePopGestureRecognizer = %@",self.interactivePopGestureRecognizer);
    
//    self.interactivePopGestureRecognizer.delegate = self;
    /*
    UIScreenEdgePanGestureRecognizer *edgePan = (UIScreenEdgePanGestureRecognizer *)self.interactivePopGestureRecognizer;
    
    edgePan.edges = UIRectEdgeLeft;
    edgePan.delegate = self;
     */
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
//    pan.delegate = self;
    
    //禁用系统手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
}



/*
 self.interactivePopGestureRecognizer.delegate 打印地址
 
 <_UINavigationInteractiveTransition: 0x7fadd7d2aa90>
 
 self.interactivePopGestureRecognizer打印地址
 
 <UIScreenEdgePanGestureRecognizer: 0x7fa377691300; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fa3774330a0>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fa377690b00>)>>
 
 */
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.viewControllers.count > 1;

}


/*
 统一修改返回按钮后 返回收拾失效
 */

//修改返回按钮
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = CGRectMake(0, 0, 70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    }
    [super pushViewController:viewController animated:animated];
    
}

- (void)back{
    [self popViewControllerAnimated:YES];
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
