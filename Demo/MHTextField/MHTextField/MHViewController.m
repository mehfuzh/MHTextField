//
//  MHViewController.m
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import "MHViewController.h"

@interface MHViewController ()

@property (nonatomic, strong) NSMutableArray *demos;

@end

@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _demos = [[NSMutableArray alloc] init];
    
    [_demos addObject:@"Form Demo"];
    [_demos addObject:@"Disabled Field Demo"];
    [_demos addObject:@"Custom Field Demo"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_demos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Demo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setText:[_demos objectAtIndex:indexPath.item]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [_demos objectAtIndex:indexPath.item];
    
    NSString *identifier =[title stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self performSegueWithIdentifier:identifier sender:self];
}


@end
