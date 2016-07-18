//
//  resultViewController.m
//  fooderV2
//
//  Created by Backman on 2015/11/16.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import "resultViewController.h"
#import "TableViewCell.h"
#import "dataObject.h"
#import "newCell.h"
#import "FD.h"


#define uploadUrl @"http://140.114.77.56:3000/fooder/newFD"
#define votingUrl @"http://140.114.77.56:3000/fooder/voting"
typedef struct{

    int ID;
    int state;

} tButtonEvent;

@interface resultViewController (){
    
    dataObject *dObj;
    
    tButtonEvent bEvent;
    
    bool added;
   

}

@end

@implementation resultViewController

@synthesize foodTableView =_foodTableView;
@synthesize redBar=_redBar,greenBar=_greenBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    added=false;
    
    dObj= [dataObject getInstance];
    
    
    [_foodTableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"listBackground"]]];


    bEvent.ID=0;
    bEvent.state=0;

    
    NSLog(@"in viewdidload");

}
- (void)sendForUpdate {
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    
    
        [_params setObject:dObj.RSID_of_FD forKey:@"RSID"];
        
    
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
        NSData *imageData = UIImageJPEGRepresentation(dObj.imgFD, 1.0);
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
            
            FD* fObj=[[FD alloc] init];
            
            fObj.ID=[NSString stringWithString:json[@"ID"] ] ;
            fObj.gValue=[NSNumber numberWithInt:0];
            fObj.bValue=[NSNumber numberWithInt:0];
            fObj.img=dObj.imgFD;
            fObj.similarity=[NSNumber numberWithInt:-1];
            
    
           [dObj.ansFooders setObject:fObj forKey:[NSString stringWithFormat:@"%d", [[dObj.ansFooders allKeys] count] ]];
            
            
          
            NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow: [[dObj.ansFooders allKeys]count ]-1 inSection:0], nil];
            
            
            [_foodTableView beginUpdates];
            
            
            
            [_foodTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            
            [_foodTableView endUpdates];
            

    
            
        });
        
    });

    
    
}



-(void)sendForVoting:(NSString*)ID RSID:(NSString*)rsid votingType:(NSString*)vt priority:(int)p  {
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *post = [NSString stringWithFormat:@"ID=%@&RSID=%@&votingType=%@",ID,rsid,vt];
        
        
        NSLog(@"post: %@",post);
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:votingUrl]];
        
        [request setHTTPMethod:@"POST"];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
         NSLog(@"return String of voting: %@",returnString);
       
        
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            NSError *jsonError;
            NSData *objectData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
           
            
            
            FD* fooder=[dObj.ansFooders objectForKey:[NSString stringWithFormat:@"%d",p]];

            
            FD* fObj=[[FD alloc] init ];
            
            
     
                
            fObj.ID=[NSString  stringWithString: json[@"ID"] ];
            fObj.gValue=json[@"gValue"] ;
            fObj.bValue=json[@"bValue"] ;
            fObj.img=fooder.img;
            fObj.similarity=fooder.similarity;
            
            
            
            NSLog(@"ID:%@ g:%@ b:%@",fObj.ID,fObj.gValue,fObj.bValue);
                
                
           

            
           [dObj.ansFooders setObject:fObj forKey:[NSString stringWithFormat:@"%d",p]];
            
            
            
            
            [_foodTableView reloadData];

            
            
        });
        
    });
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(added==false)
        return [[dObj.ansFooders allKeys]count ]+1;
    else
        return [[dObj.ansFooders allKeys]count ];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    
   if(indexPath.row< [[dObj.ansFooders allKeys] count]){
       
      
        
        static NSString *simpleTableIdentifier = @"TableViewCell";
    
    
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
        if(!cell){
    
    
    
            cell =[[TableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
    
        
    
        cell.thumbUp.tag=indexPath.row;
        [cell.thumbUp addTarget:self action:@selector(thumbUpClicked:) forControlEvents:UIControlEventTouchUpInside];
      
      
        
        
        cell.thumbDown.tag=indexPath.row;
        [cell.thumbDown addTarget:self action:@selector(thumbDownClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        cell.backgroundColor =[UIColor clearColor];
        cell.backgroundView= nil;
        cell.selectedBackgroundView=nil;
    
        cell.outline.image = [UIImage imageNamed:@"listCellOutline"];
       
       
       
        FD* fooder=[dObj.ansFooders objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    
       cell.foodView.image = fooder.img;
       
       if([fooder.similarity intValue]!=-1)
           cell.similarityLabel.text = [NSString stringWithFormat:@"%d%%",[fooder.similarity intValue]];
       else{
           cell.similarityLabel.text=@"";
           cell.statusLabel.text=@"";
       
       
       }
        cell.foodView.layer.cornerRadius = cell.foodView.frame.size.width/2;
        cell.foodView.clipsToBounds =YES;
       
       
       

       
      
       
     
       
       
       
      
       float redValue=0;
       float greenValue = 0;
       
       if([fooder.bValue intValue]!=0 && [fooder.gValue intValue]!=0){
           redValue = (float)[fooder.bValue intValue]/(float)([fooder.gValue intValue]+[fooder.bValue intValue]);
       
           greenValue= 1.0-redValue;
       }
       else if([fooder.bValue intValue]==0 && [fooder.gValue intValue]!=0){
       
           greenValue=1.0;
           redValue=0.0;
       
       
       }
       else if([fooder.bValue intValue]!=0 && [fooder.gValue intValue]==0){
       
           
           greenValue=0.0;
           redValue=1.0;

       
       
       
       
       }else{
       
           greenValue=0;
           redValue=0;
       
       }
       
       
       
       cell.greenLabel.text = [NSString stringWithFormat:@"%2.1f%%",greenValue*100];
       cell.redLabel.text = [NSString stringWithFormat:@"%2.1f%%",redValue*100];
       
       
        //percentBar
        
        
        
      _redBar=[[percentageBar alloc] init ];
      [_redBar setPercentage:redValue clockWise:NO color:[UIColor redColor]];
      
      
      
      _greenBar=[[percentageBar alloc] init];
       [_greenBar setPercentage:greenValue clockWise:YES color:[UIColor greenColor]];
      
        [cell.contentView.layer addSublayer:_redBar];
      
        [cell.contentView.layer addSublayer:_greenBar];
// spot
        
      if(bEvent.ID==indexPath.row && bEvent.state==2){
          
          bool flag=false;
          for (CALayer *layer in cell.contentView.layer.sublayers) {
              if ([layer.name isEqualToString:@"greenSpot"]) {
                  flag=true;
                  break;
              }
          }

          
          if(flag==false){
          
              CAShapeLayer* greenSpot = [CAShapeLayer layer];
              [greenSpot setName:@"greenSpot"];
              greenSpot.strokeColor=[UIColor greenColor].CGColor;
              greenSpot.fillColor= [UIColor greenColor].CGColor;
          
         
              [greenSpot setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(265, 102, 45, 45)] CGPath]];
              [cell.contentView.layer insertSublayer:greenSpot below:cell.thumbUp.layer];
          
              for (CALayer *layer in cell.contentView.layer.sublayers) {
                  if ([layer.name isEqualToString:@"redSpot"]) {
                      [layer removeFromSuperlayer];
                      break;
                  }
              }
          }
          
      }
      else if(bEvent.ID == indexPath.row && bEvent.state==1){
          bool flag=false;
          for (CALayer *layer in cell.contentView.layer.sublayers) {
              if ([layer.name isEqualToString:@"redSpot"]) {
                  flag=true;
                  break;
              }
          }
          
          
          if(flag==false){
              
              CAShapeLayer* greenSpot = [CAShapeLayer layer];
              [greenSpot setName:@"redSpot"];
              greenSpot.strokeColor=[UIColor redColor].CGColor;
              greenSpot.fillColor= [UIColor redColor].CGColor;
              
              
              [greenSpot setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(9, 102, 45, 45)] CGPath]];
              [cell.contentView.layer insertSublayer:greenSpot below:cell.thumbDown.layer];
              
              for (CALayer *layer in cell.contentView.layer.sublayers) {
                  if ([layer.name isEqualToString:@"greenSpot"]) {
                      [layer removeFromSuperlayer];
                      break;
                  }
              }
          }
      
      }
      
      
        
        
        return cell;
    }
    else{
        
        static NSString *simpleTableIdentifier = @"newCell";
        
        
        newCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        
        if(!cell){
            
            
            
            cell =[[newCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
        
        cell.backgroundColor =[UIColor clearColor];
        cell.backgroundView= nil;
        cell.selectedBackgroundView=nil;
        
        
        
        cell.addFood.image = dObj.imgFD;
        cell.addFood.layer.cornerRadius = cell.addFood.frame.size.width/2;
        cell.addFood.clipsToBounds =YES;
        
        
        [cell.add addTarget:self action:@selector(newAdded:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    
    
    
    
    
    
    
    }
      
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    


}

-(void)newAdded:(UIButton*)sender{

   

    sender.hidden=true;
    
    NSLog(@"remove: %d",[[dObj.ansFooders allKeys] count]);
    
    added=true;
    
    NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[[dObj.ansFooders allKeys] count]  inSection:0], nil];

    
    [_foodTableView beginUpdates];
    
    [_foodTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
    
    [_foodTableView endUpdates];

    
    
    [self sendForUpdate];
    NSLog(@"add one fooder");
    



}



-(void)thumbUpClicked:(UIButton*)sender
{

    NSLog(@"green press");
    bEvent.ID=sender.tag;
    bEvent.state=2;
    
    //voting
    
    
   
    
    FD* fooder=[dObj.ansFooders objectForKey:[NSString stringWithFormat:@"%d",sender.tag]];
    
    
    NSLog(@"%@",fooder.gValue);
    NSLog(@"-->%@",fooder.ID);
      NSLog(@"---->%@",dObj.ansFooders);
    
    [self sendForVoting:fooder.ID RSID:dObj.RSID_of_FD votingType:@"gValue" priority:sender.tag];
    
    
    
}


-(void)thumbDownClicked:(UIButton*)sender{


  NSLog(@"red press");
    
    bEvent.ID=sender.tag;
    bEvent.state=1;
    //voting
    
  
    
    FD* fooder= [dObj.ansFooders objectForKey:[NSString stringWithFormat:@"%d",sender.tag]];
    
 
    
    
    [self sendForVoting:fooder.ID RSID:dObj.RSID_of_FD votingType:@"bValue" priority:sender.tag];
    
    
 


}





- (IBAction)retake:(id)sender {
    
    
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
    
    dObj.imgFD = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}



@end
