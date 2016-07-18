//
//  pickerResultController.m
//  fooderV2
//
//  Created by Backman on 2015/11/9.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import "pickerResultController.h"
#import "dataObject.h"

@interface pickerResultController (){

    dataObject *dObj;
}

@end

@implementation pickerResultController

@synthesize foodImgView=_foodImgView;
@synthesize segmentButton=_segmentButton;
@synthesize retakeButton=_retakeButton;
@synthesize segmentView=_segmentView;
- (void)viewDidLoad {
    [super viewDidLoad];
     dObj = [ dataObject getInstance];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer:)];
    
    
    
    _foodImgView.userInteractionEnabled = NO;
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    
    [_foodImgView setImage:dObj.originImg];
    
        
   
    
    
}





-(void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    
    _segmentView.transform = CGAffineTransformScale(_segmentView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    
    
    
    
    pinchGestureRecognizer.scale = 1.0;
    /*pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
     */
    
}

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    
    
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    
    int x= touchLocation.x+_segmentView.frame.size.width/2;
    int y= touchLocation.y+_segmentView.frame.size.height/2;
    
    CGPoint pos=_segmentView.center;
    
    
    if( _segmentView.frame.size.width< x&&x< _foodImgView.frame.size.width)
        pos.x=touchLocation.x;
    if(_segmentView.frame.size.height<y && y<_foodImgView.frame.size.height)
        pos.y=touchLocation.y;
    
    
    
    _segmentView.center=pos;
    
    
    
    
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    
    
    
    CGPoint touchLocation = [tapGestureRecognizer locationInView:self.view];
    
    int x= touchLocation.x+_segmentView.frame.size.width/2;
    int y= touchLocation.y+_segmentView.frame.size.height/2;
    
    CGPoint pos=_segmentView.center;
    
    
    if( _segmentView.frame.size.width< x&&x< _foodImgView.frame.size.width)
        pos.x=touchLocation.x;
    if(_segmentView.frame.size.height<y && y<_foodImgView.frame.size.height)
        pos.y=touchLocation.y;
    
    
    
    _segmentView.center=pos;
       
       
       
       
        
       
    
    
    
}






- (IBAction)retake:(id)sender {
    
    
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];


    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    dObj.originImg = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
     [_foodImgView setImage:dObj.originImg];
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (IBAction)segment:(id)sender {
    
    
    
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // resize to 320*568
    UIImage *newImg = [self imageWithImage:dObj.originImg scaledToSize:CGSizeMake(320, 568)];
    
    
    
    IplImage* img =[self CreateIplImageFromUIImage:newImg];
    
    IplImage* result=cvCreateImage(cvSize(_segmentView.frame.size.width,_segmentView.frame.size.height),8,3);
    
    CvRect rect;
    
    
    rect.x =  _segmentView.center.x - _segmentView.frame.size.width/2;
    rect.y =  _segmentView.center.y - _segmentView.frame.size.height/2;
    
    rect.width=_segmentView.frame.size.width;
    rect.height=_segmentView.frame.size.height;
    
    cvSetImageROI(img,rect);
    
    cvCopy(img,result,NULL);
    
    
    dObj.analysisImg= [self UIImageFromIplImage: result];
    
    
    
    
}




-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(UIImage *)UIImageFromIplImage:(IplImage *)inputImage
{
    CGColorSpaceRef colorSpace;
    if (inputImage->nChannels == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        
        
        cvCvtColor(inputImage, inputImage, CV_BGR2RGB);
    }
    
    
    NSData *data = [NSData dataWithBytes:inputImage->imageData length:inputImage->imageSize];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    
    CGImageRef imageRef = CGImageCreate(inputImage->width,
                                        inputImage->height,
                                        inputImage->depth,
                                        inputImage->depth * inputImage->nChannels,
                                        inputImage->widthStep,
                                        colorSpace,
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault
                                        );
    
    
    UIImage *outputImage = [UIImage imageWithCGImage:imageRef];
    
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return outputImage;
}




@end
