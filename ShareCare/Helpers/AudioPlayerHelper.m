//
//  AudioPlayerHelper.m
//  ShareCare
//
//  Created by 朱明 on 2018/1/24.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "AudioPlayerHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>   


@interface AudioPlayerHelper(){
    SystemSoundID _soundID;
    
}
@end


@implementation AudioPlayerHelper
- (instancetype)init{
    if(self = [super init]){ 
        return self;
    }
    return nil;
}

- (void)receiveMessage{ 
    if (!_soundID) {
        //获取URL
        CFURLRef urlRef = (__bridge CFURLRef)([[NSBundle mainBundle] URLForResource:@"receive-msg.caf" withExtension:nil]);
        //创建保存soundID的变量
        //通过URL和SoundID的地址,接收对应的音效SoundID
        AudioServicesCreateSystemSoundID(urlRef, &_soundID);
    } 
    //播放
    AudioServicesPlaySystemSound(_soundID);//效果:直接播放,有震动效果
//    if ([self getVolume] == 0) {
//        AudioServicesPlayAlertSound(soundID);//效果:直接播放,有震动效果
//    }else{
//        AudioServicesPlaySystemSound(soundID);//效果:直接播放,没有震动效果
//    }
    
//    
//    
//    AudioServicesPlaySystemSoundWithCompletion(soundID,block);//效果:带有播放完成回调代码块
    //根据SoundID释放内存
//    AudioServicesDisposeSystemSoundID(soundID);
    
    //获取手机音量  
//    float volume = [[AVAudioSession sharedInstance] outputVolume];  
//    
//    NSLog(@"volume=%f",volume);
} 
@end
