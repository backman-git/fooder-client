//
//  RSViewController.m
//  fooderV2
//
//  Created by Backman on 2015/12/6.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import "resultRSViewController.h"
#import "RSTableViewCell.h"
#import "dataObject.h"
#import "RS.h"
#import "newCellRS.h"
#define uploadUrl @"http://140.114.77.56:3000/fooder/newRS"



@interface resultRSViewController ()

@end

@implementation resultRSViewController{
    
    dataObject* dObj;
    
    bool added;
    
}
@synthesize tableViewRS=_tableViewRS;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dObj= [dataObject getInstance];
    added=false;
    
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if(added==false)
        return [[dObj.ansRS allKeys]count ]+1;
    else
        return [[dObj.ansRS allKeys]count ];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if(indexPath.row< [[dObj.ansRS allKeys] count]){
       
        static NSString *simpleTableIdentifier = @"cellRS";
    
    
        RSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
        if(!cell){
        
        
        
            cell =[[RSTableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
    

        RS *rs=[dObj.ansRS objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        cell.imageViewRS.image = rs.img;
        
        if([rs.similarity intValue]!=-1)
            cell.similarityLabel.text = [NSString stringWithFormat:@"%d%%",[rs.similarity intValue]];
        else{
            cell.similarityLabel.text=@"";
            cell.statusLabel.text=@"";
        }
    
        return cell;
    
    }
    else{
    
        static NSString *simpleTableIdentifier = @"newRS";
        
        
         newCellRS* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        
        if(!cell){
            
            
            
            cell =[[newCellRS alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
        
        cell.addImgRS.image = dObj.imgRS;
    
    
    
         [cell.add addTarget:self action:@selector(newAdded:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
        return cell;
    
    }
    
    
    
    
    
    
}

-(void)newAdded:(UIButton*)sender{
    
    
    
    sender.hidden=true;
    
    
    added=true;
    
    NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[[dObj.ansRS allKeys] count]  inSection:0], nil];
    
    
    [_tableViewRS beginUpdates];
    
    [_tableViewRS deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
    
    [_tableViewRS endUpdates];
    
    
    
    [self sendForUpdate];
    NSLog(@"add one RS");
    
    
    
    
}



- (void)sendForUpdate {
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        
        
        [_params setObject:@"0.0" forKey:@"longitude"];
        [_params setObject:@"0.0" forKey:@"latitude"];
        
        
        // the boundary string : a random string, that will not repeat in post data, to separate post data  fields.
        NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
        
        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
        NSString* FileParamConstant = @"userPhoto";
        
        // the server url to which the image (or the media) is uploaded. Use your server url here
        NSURL* requestURL = [NSURL URLWithString:uploadUrl];
        
        
        
        
        // create request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        
        
        
        [request setHTTPMethod:@"POST"];
        
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        // add params (all params are strings)
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // add image data
        NSData *imageData = UIImageJPEGRepresentation(dObj.imgRS, 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // set URL
        [request setURL:requestURL];
        
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"returnString =%@",returnString);
        
        
        
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSError *jsonError;
            NSData *objectData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
            
            RS* RSObj=[[RS alloc] init];
            
            RSObj.ID=[NSString stringWithString:json[@"ID"] ] ;
            RSObj.gValue=[NSNumber numberWithInt:0];
            RSObj.bValue=[NSNumber numberWithInt:0];
            RSObj.similarity =[NSNumber numberWithInt:-1];
            RSObj.img = dObj.imgRS;
            
            
            

            
            
            NSLog(@"all key count %d ",[[dObj.ansRS allKeys] count] );
            
            [dObj.ansRS setObject:RSObj forKey:[NSString stringWithFormat:@"%d", [[dObj.ansRS allKeys] count] ]];
            
            
            NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow: [[dObj.ansRS allKeys]count ]-1 inSection:0], nil];
            
            
            
            
            
            [_tableViewRS beginUpdates];
            
            
            
            [_tableViewRS insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            
            [_tableViewRS endUpdates];
            
            
            
            
        });
        
    });
    
    
    
}

















- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    
    RS *rs=[dObj.ansRS objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    if(rs.ID!=NULL){
        NSLog(@"choose ->%@ row:%ld",rs.ID,(long)indexPath.row);
    
    
        dObj.RSID_of_FD=[NSString stringWithString:rs.ID];
    

    
    


        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"拍照搜尋食物嗎？"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"好",@"不了，顯示菜單",nil];
    
        [myAlertView show];
    }
  
    
    
    



}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    switch (buttonIndex) {
        case 0:
           
            break;
        case 1:
            [self snap];
            
            
            
            break;
        case 2:
          
            break;
        
        
        
        
        default:
            break;
    }
    
    
    
    
    
    
    
    
}




-(void)snap{

  



    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        //simulator
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }







}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //may change size
    dObj.imgFD = [self imageWithImage: info[UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(320, 250)];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSegueWithIdentifier:@"segueToDownloadFD" sender:self];
    
    
    
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
