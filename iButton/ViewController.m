//
//  ViewController.m
//  AudioRecorder
//
//  Created by Ken Huang on 13-6-7.
//  Copyright (c) 2013 Ken Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize btn;
@synthesize imageView = _imageView;
@synthesize playBtn = _playBtn;
@synthesize avPlay = _avPlay;
@synthesize myTextField=_myTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self audio];
    [self.btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];
    [self.playBtn addTarget:self action:@selector(playRecordSound:) forControlEvents:UIControlEventTouchDown];
}

- (IBAction)playRecordSound:(id)sender
{
    if (self.avPlay.playing) {
        [self.avPlay stop];
        return;
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    self.avPlay = player;
    [player release];
    [self.avPlay play];
}

- (IBAction)btnDown:(id)sender
{
    //Creat the file, prepare to record.
    if ([recorder prepareToRecord]) {
        //start recording
        [recorder record];
    }
    
    //set the timer.
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}
- (IBAction)btnUp:(id)sender
{
    double cTime = recorder.currentTime;
    if (cTime > 2) {//DO NOT SENT if time <2.
        NSLog(@"sent");
    }else {
        //Delete the record file.
        [recorder deleteRecording];
    }
    [recorder stop];
    [timer invalidate];
}
- (IBAction)btnDragUp:(id)sender
{
    //Delete recording file.
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    
    NSLog(@"cancelled");
}

- (void)audio
{
    //Record setting
    NSMutableDictionary *recordSetting = [[[NSMutableDictionary alloc]init] autorelease];
    //set Format  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //set quality(Hz) such as:AVSampleRateKey==8000/44100/96000
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //set # of channel.
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //Bit 8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //audio quality key.
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    urlPlay = url;
    
    NSError *error;
    //Initialize.
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //start testing.
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (void)detectionVoice
{
    [recorder updateMeters]; //update.
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
   
    
    if (0<lowPassResults<=0.06) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

-(IBAction)editAction:(id)sender{
    NSLog(@"wtf");
}

- (void) updateImage
{
    [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.myTextField.text);
    [self.myTextField resignFirstResponder];
    return YES;
}
- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTextField:nil];
    [super viewDidUnload];
}
@end
