# Navigationbar

项目中通常会遇到要修改统一的返回按钮下面给出修改方法<br>

```
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

```

很多时候我们修改同意返回按钮之后 返回手势就不能使用了!(代理方法导致的问题)导航控制器给出了返回的手势<br>

```
@property(nullable, nonatomic, readonly) UIGestureRecognizer *interactivePopGestureRecognizer NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
```

在这里我们设置代理先为nil<br>

```
self.interactivePopGestureRecognizer.delegate = nil;
```

设置代理后发现手势可以使用了,但是又出现了一个新的问题,当对根控制器使用手势后,在点击控制器上面的控件就不能再点击出现"假死"状态即App是激活状态但是界面控制器不能点击,所以我们设置手势代理方法为self <br>

```
self.interactivePopGestureRecognizer.delegate = self;

#pragma mark - UIGestureRecognizerDelegate
//接收到手势的时候会调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
      return self.viewControllers.count > 1;
}

```

通过前面的修改处理就不会产生假死的问题并且处理好了手势问题但是有时间项目需求需要使用全局手势下面我们来给出这么处理全局手势问题<br>


##### 1.全局手势

###### <1>.首先看看导航控制器手势

```
NSLog(@"interactivePopGestureRecognizer = %@",self.interactivePopGestureRecognizer);
<UIScreenEdgePanGestureRecognizer: 0x7f993ec6feb0; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f993ed07980>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f993ec6f690>)>>

```

从打印数据可以看出来导航控制器的手势是UIScreenEdgePanGestureRecognizer<br>

```
    /*! This subclass of UIPanGestureRecognizer only recognizes if the user slides their finger
in from the bezel on the specified edge. */
NS_CLASS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED @interface UIScreenEdgePanGestureRecognizer : UIPanGestureRecognizer
@property (readwrite, nonatomic, assign) UIRectEdge edges; //< The edges on which this gesture recognizes, relative to the current interface orientation

```

UIScreenEdgePanGestureRecognizer 是继承于UIPanGestureRecognizer 其中edges 是修改滑动的位置<br>

```
typedef NS_OPTIONS(NSUInteger, UIRectEdge) {
    UIRectEdgeNone   = 0,
    UIRectEdgeTop    = 1 << 0,
    UIRectEdgeLeft   = 1 << 1,
    UIRectEdgeBottom = 1 << 2,
    UIRectEdgeRight  = 1 << 3,
    UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
 } NS_ENUM_AVAILABLE_IOS(7_0);

```

表示从左右上下方向滑动,但是还不是还不是全局滑动.只能自定义全局手势<br>

###### <2>.自定义全局手势

从上面导航控制器的打印数据可以知道UIScreenEdgePanGestureRecognizer 的
target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f993ec6f690>)
所以我们全局手势也调用原生的target 和action

我们打印self.interactivePopGestureRecognizer.delegate 获得地址和 UIScreenEdgePanGestureRecognizer的target地址是一样的

```
NSLog(@"interactivePopGestureRecognizer.delegate = %@",self.interactivePopGestureRecognizer.delegate);
  //打印数据
 <_UINavigationInteractiveTransition: 0x7fadd7d2aa90>
 
```

创建全局手势

```
 UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
[self.view addGestureRecognizer:pan];

//设置代理防止上面的"假死"状态
pan.delegate = self;

//禁用系统手势
self.interactivePopGestureRecognizer.enabled = NO;
```















