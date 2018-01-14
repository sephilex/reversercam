//
//  PlayController.m
//  reveredemo
//
//  Created by sephilex on 2017/9/22.
//

#import "PlayController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayController ()

@end

@implementation PlayController {
    AVPlayer *player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(show) withObject:nil afterDelay:0.5];
}

- (void)show {
    // Do any additional setup after loading the view from its nib.
    //   1 创建要播放的元素
    
    //    NSURL *url = [[NSBundle mainBundle]URLForResource:@"视频文件名" withExtension:nil];
    //    playerItemWithAsset:通过设备相册里面的内容 创建一个 要播放的对象    我们这里直接选择使用URL读取
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:_playUrl];
    
    //    duration   当前播放元素的总时长
    //    status  加载的状态          AVPlayerItemStatusUnknown,  未知状态
    //    AVPlayerItemStatusReadyToPlay,  准备播放的状态
    //    AVPlayerItemStatusFailed   失败的状态
    
    //    时间控制的类目
    //    current
    //    forwordPlaybackEndTime   跳到结束位置
    //    reversePlaybackEndTime    跳到开始位置
    //    seekToTime   跳到指定位置
    
    //2  创建播放器
    player = [AVPlayer playerWithPlayerItem:item];
    //也可以直接WithURL来获得一个地址的视频文件
    //    externalPlaybackVideoGravity    视频播放的样式
    //AVLayerVideoGravityResizeAspect   普通的
    //    AVLayerVideoGravityResizeAspectFill   充满的
    //    currentItem  获得当前播放的视频元素
    
    //    3  创建视频显示的图层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = self.view.bounds;
    // 显示播放视频的视图层要添加到self.view的视图层上面
    [self.view.layer addSublayer:layer];
    
    //最后一步开始播放
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
