//
//  IConnectionBase.h
//  BaseConnection
//
//  Created by Sarun Krishnalome on 11/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Protocol for all handlers of server communication objects*/
@protocol IConnectionBase

/* Callback fired when the data has been succesfully downloaded
- Param: sender, the object firing the call.
*/
 -(void) onDownloadComplete:(id)sender;
/*
 Callback fired when the error data has been collected
 - Param: sender, the object firing the call.
 */
 -(void) onDownloadFailed:(id)sender;
/* Callback fired when the initial reachability (internet access) has failed.
*/
-(void) reachabilityFailed;

/* Callback fired when the connection errors.
 - Param: sender, the object firing the call.
*/
-(void) connectionError:(id)sender withError:(NSError*)error;

/* Callback fired when the connection times out.
 - Param: sender, the object firing the call.
*/ 
-(void) connectionTimeout:(id)sender;



@end
