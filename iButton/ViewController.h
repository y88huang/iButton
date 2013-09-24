//
//  ViewController.h
//  AudioRecorder
//
//  Created by Ken Huang on 13-6-7.
//  Copyright (c) 2013年 Ken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioRecorderDelegate,UITextFieldDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    UITextField *myTextField;
}
@property (retain, nonatomic) IBOutlet UITextField *myTextField;
@property (retain, nonatomic) IBOutlet UIButton *btn;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIButton *playBtn;
@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end
