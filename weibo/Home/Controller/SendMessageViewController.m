//
//  SendMessageViewController.m
//  weibo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "SendMessageViewController.h"
#import "Common.h"
#import "ThemeButton.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "DataService.h"
#import "MMDrawerController.h"



@interface SendMessageViewController ()
{
    UIImage *_sendImage;
}

@end

@implementation SendMessageViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"发送微博";
    [self _createNavItem];
    [self _createEditorView];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated ];
    //弹出键盘
    [_textView becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    //导航栏不透明，当导航栏不透明的时候 ，子视图的y的0位置在导航栏下面
//    self.navigationController.navigationBar.translucent = NO;
//    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    //弹出键盘
    [_textView becomeFirstResponder];
}
#pragma mark - 创建子视图
-(void)_createNavItem
{
    //1.关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.normalImageName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    //1.发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.normalImageName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
}

-(void)_createEditorView
{
    //1.文本输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    
    _textView.backgroundColor = [UIColor lightGrayColor];
    //圆角边框
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_textView];
    
    //编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                              ];
    for (int i = 0 ; i < imgs.count; i++) {
        NSString *imageName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15 + (kScreenWidth / 5) * i, 20, 40, 33)];
        button.tag = 10 + i;
        button.normalImageName = imageName;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editorBar addSubview:button];
        
        //创建lable显示位置信息
        _locLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
        _locLable.hidden = YES;
        _locLable.font = [UIFont systemFontOfSize:14];
        _locLable.backgroundColor = [UIColor grayColor];
        [_editorBar addSubview:_locLable];
    }
    
}

-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 10) {
        [self _selectPhoto];
    }
    else if (button.tag == 13)
    {
        //显示位置
        [self _location];
        
    }
    else if (button.tag == 14)
    {
        //显示、隐藏表情
        BOOL isFirstResponder = _textView.isFirstResponder;
        //输入框是否第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder) {
            //隐藏键盘
            [_textView resignFirstResponder];
            //显示表情
            [self _showFaceView];
            
        }
        else
        {
            //隐藏表情
            [self _hideFaceView];
            //显示键盘
            [_textView becomeFirstResponder];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendAction
{
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
        
    }
    else if (text.length > 140)
    {
        error = @"微博内容大于140字符";
        
    }
    //弹出提示错误信息
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    

    AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
        NSLog(@"%@",result);
        [self showStatusTip:@"发送成功" show:NO operation:operation];
    }];
    [self showStatusTip:@"正在发送" show:YES operation:operation];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)closeAction
{
    
//    //通过UIWindow找到  MMDRawer
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//
//    if ([window.rootViewController isKindOfClass:[MMDrawerController class]]) {
//        MMDrawerController *mmDrawer = (MMDrawerController *)window.rootViewController;
//
//        [mmDrawer closeDrawerAnimated:YES completion:NULL];
//    }
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 键盘弹出通知
-(void)keyBoardWillShow:(NSNotification *)notification
{
    //1.取出键盘的frame。这个frame 相对于window的
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [bounsValue CGRectValue];
    
    //键盘高度
    CGFloat height = frame.size.height;
    //调整视图的高度
    _editorBar.bottom = kScreenHeight - height - 64;
    
}
#pragma mark - 选择照片
-(void)_selectPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    //选择拍照或相册
    if (buttonIndex == 0) {
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alter show];
            return;
        }
        
        
    }
    else if (buttonIndex == 1)
    {
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    else
    {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//照片选择代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //2取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //显示缩略图
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc] init];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom + 10, 80, 80);
        [self.view addSubview:_zoomImageView];
        
    }
    _zoomImageView.image = image;
    _sendImage = image;

}
#pragma mark - zoomImageViewDelegate

-(void)imageWillZoomOut:(ZoomImageView *)imageView
{
    [_textView becomeFirstResponder];
}

-(void)imageWillZoomIn:(ZoomImageView *)imageView
{
    [_textView resignFirstResponder];
}


#pragma mark - 地理位置

/*
 修改 info.plist 增加以下两项
 NSLocationWhenInUseUsageDescription  BOOL YES
 NSLocationAlwaysUsageDescription         string “提示描述”
 */

-(void)_location
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        if (kVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
            
        }
        //设置定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"已经更新位置");
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;

    
    NSLog(@"经度 = %lf 纬度 = %lf",coordinate.longitude,coordinate.latitude);
    
    //地理位置反编码
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:coordinateStr forKey:@"coordinate"];
    
    __weak __typeof(self) weakSelf = self;
    [DataService requestUrl:geo_to_address httpMethod:@"GET" params:params block:^(id result) {
        NSArray *geos = [result objectForKey:@"geos"];
        if (geos.count > 0) {
            NSDictionary *geoDic = [geos lastObject];
            NSString *addr = [geoDic objectForKey:@"address"];
            NSLog(@"地址 %@",addr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(self) strongSelf = weakSelf;
                strongSelf->_locLable.text = addr;
                strongSelf->_locLable.hidden = NO;
            });
        }
    }];
}


#pragma mark - 表情处理
- (void)_showFaceView{
    
    //创建表情面板
    if (_faceViewPanel == nil) {
        
        
        _faceViewPanel = [[FaceScrollView alloc] init];
        [_faceViewPanel setFaceViewDelegate:self];
        //放到底部
        _faceViewPanel.top  = kScreenHeight-64;
        [self.view addSubview:_faceViewPanel];
    }
    
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        
        _faceViewPanel.bottom = kScreenHeight-64;
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPanel.top;
        
    }];
}

//隐藏表情
- (void)_hideFaceView {
    
    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.top = kScreenHeight-64;
        
    }];
    
}
- (void)faceDidSelect:(NSString *)text{
    NSLog(@"选中了%@",text);
    
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,text];
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
