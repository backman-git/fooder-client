//
//  downloadRSViewController.m
//  fooderV2
//
//  Created by Backman on 2015/12/6.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import "downloadRSViewController.h"
#import "RS.h"


#import "dataObject.h"
#define analysisRSUrl @"http://140.114.77.56:3000/fooder/analysisRS"
#define resultRSURL @"http://140.114.77.56:3000/fooder/resultRS"
#define imgRSUrl @"http://140.114.77.56:3002"
@interface downloadRSViewController (){


     NSTimer* fetchResultT;
    
    dataObject* dObj;
    
    
    NSDictionary* resultJson;

    
    
    

}

@end

@implementation downloadRSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dObj = [dataObject getInstance];
    
    
    
    [self sendForAnalysisRS];
    
    
    
    

    

}







-(void) sendForAnalysisRS {
    
    [dObj.ansRS removeAllObjects];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    
    
        [_params setObject:@"0.0" forKey:@"longitude"];
        [_params setObject:@"1.0" forKey:@"latitude"];
    
    
    
        // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
        NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
        NSString* FileParamConstant = @"userPhoto";
    
        // the server url to which the image (or the media) is uploaded. Use your server url here
        NSURL* requestURL = [NSURL URLWithString:analysisRSUrl];
    
    
    
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
            NSLog(@"returnString =%@",returnString);
    
            NSDictionary* json=[NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:0 error:NULL];
    
    
            dObj.resultID_RS=json[@"ID"] ;
            
            
            self->fetchResultT=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fetch:) userInfo:nil repeats:YES];
            

    
        });
    
    });

}






-(void)fetch:(NSTimer*)t{
    
    
    [self fetchResult];
   
    
}





// result json


-(void)fetchResult{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        //2
        
        NSData* resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?ID=%d",resultRSURL,[dObj.resultID_RS intValue ]]]];
        
        
        
        
        //3
        NSDictionary* json = nil;
        NSError *error = nil;
        if (resultData) {
            json = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&error];
        }
        
        
        
        //4
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            //5
            
            if(json!=nil &&[json[@"status"] isEqualToString:@"true" ]){
                [self->fetchResultT invalidate];
                
                resultJson =[NSDictionary dictionaryWithDictionary:json];
                
                
                [self downloadImg];
               
            
            
            
            }
            
            
            
            
            
            
            
        });
        
    });
    
    
    
}

// result images~!

-(void)downloadImg{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int imgN = [resultJson[@"numberOfImgs"] intValue];
        NSLog(@"number of images ->%d",imgN);
        
        

        
        
        for(int i=0 ;i<imgN;i++){
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.jpg",imgRSUrl,resultJson[[NSString stringWithFormat:@"%d",i]   ][0]]];
            
            
            NSData *data = [NSData dataWithContentsOfURL:url];
           
            RS *RSObj = [[RS alloc] init];
            
            
            
            RSObj.ID=[NSString stringWithString: resultJson[  [NSString stringWithFormat:@"%d",i]  ][0] ] ;
            RSObj.gValue=resultJson[  [NSString stringWithFormat:@"%d",i]  ][1]  ;
            RSObj.bValue=resultJson[  [NSString stringWithFormat:@"%d",i]  ][2]  ;
            RSObj.similarity=resultJson[  [NSString stringWithFormat:@"%d",i]  ][3] ;
            RSObj.img=[UIImage imageWithData:data];
            [dObj.ansRS setObject:RSObj forKey:[NSString stringWithFormat:@"%d",i]];

            
            
            
            
            
                   
        }
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"fetch images success!!");
            
            [self performSegueWithIdentifier:@"segueToResultRS" sender:self];
            
            
            
        });
        
    });
    
    
    
    
    
    
    
    
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
