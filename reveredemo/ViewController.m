//
//  ViewController.m
//  reveredemo
//
//  Created by 卢旭东 on 2017/9/21.
//  Copyright © 2017年 sephilex. All rights reserved.
//

#import "ViewController.h"
#import "FMImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayController.h"
#import "AVUtilities.h"

@interface ViewController ()<FMImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreAppBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *groupArrays;
@property (nonatomic, strong) UIImageView *litimgView;


@end

@implementation ViewController
{
    AVPlayer *player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shareBtn.titleLabel.numberOfLines = 0;
    _shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_shareBtn setTitle:@"Share/\nContact" forState:UIControlStateNormal];
    
    _moreAppBtn.titleLabel.numberOfLines = 0;
    _moreAppBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_moreAppBtn setTitle:@"More/\nApps" forState:UIControlStateNormal];
    
    self.groupArrays = [NSMutableArray array];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.litimgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    [self.view addSubview:_litimgView];
}

- (IBAction)share:(id)sender {
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[@"hello", @"sephilex"] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)selectFromAlbum:(id)sender {
//    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
//    videoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    videoPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//    [self presentViewController:videoPicker animated:YES completion:nil];
    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [weakSelf.groupArrays addObject:group];
            } else {
                [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL  *stop) {
                        if ([result thumbnail] != nil) {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                                
                                //                                NSDate *date= [result valueForProperty:ALAssetPropertyDate];
                                //                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                //                                NSString *fileName = [[result defaultRepresentation] filename];
                                //                                NSURL *url = [[result defaultRepresentation] url];
                                //                                int64_t fileSize = [[result defaultRepresentation] size];
                                //
                                //                                NSLog(@"date = %@",date);
                                //                                NSLog(@"fileName = %@",fileName);
                                //                                NSLog(@"url = %@",url);
                                //                                NSLog(@"fileSize = %lld",fileSize);
                                //
                                //                                // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
                                //                                dispatch_async(dispatch_get_main_queue(), ^{
                                //                                    self.litimgView.image = image;
                                //                                });
                                NSLog(@"读取到照片了");
                            }
                            // 视频
                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                                NSLog(@"读取到视频了");
                                NSURL *url = [[result defaultRepresentation] url];
                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];                                NSLog(@"%@",url);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.litimgView.image = image;
                                });
                                // 和图片方法类似
                            }
                        }
                    }];
                }];
                
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
}

- (IBAction)startRecord:(id)sender {
    FMImagePicker *picker = [[FMImagePicker alloc] init];
    picker.fmdelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)play:(NSURL *)url {
    [self deleteFile];
    AVAsset *origin = [[AVURLAsset alloc] initWithURL:url options:nil];
//    AVAsset *originalAsset = [[AVURLAsset alloc] initWithURL:[NSURL urlWithString:@"~/video.mp4"]];
    NSString *tmpDir = NSTemporaryDirectory();
    NSURL *output = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@/output.mp4", tmpDir]];
    AVAsset *reversedAsset = [AVUtilities assetByReversingAsset:origin outputURL:output];
    [self performSelector:@selector(showPlayView:) withObject:output afterDelay:1];
}

- (void)showPlayView:(NSURL *)url {
    PlayController *vc = [PlayController new];
    vc.playUrl = url;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)deleteFile {
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    
    NSString *uniquePath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mp4"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    
    if (!blHave) {
        
        NSLog(@"no  have");
        
        return ;
        
    }else {
        
        NSLog(@" have");
        
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        
        if (blDele) {
            
            NSLog(@"dele success");
            
        }else {
            
            NSLog(@"dele fail");
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
