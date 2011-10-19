//
//  XMLWriter.m
//
#import "XMLWriter.h"

@implementation XMLWriter
@synthesize treeLevel,node, objectlevel,nodeCounts, currentNode, nodes, xml, oldroot, samenodeflag, treeNodes;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.currentNode = -1;
        self.treeLevel = 0;
        self.objectlevel = 0;
        self.node = 0;
        self.xml = @"";
        self.nodeCounts = 0;
        self.samenodeflag = 0;
        nodes = [[NSMutableArray alloc] init]; 
        oldroot = [[NSMutableArray alloc] init]; 
        treeNodes = [[NSMutableArray alloc] init]; 

    }
    
    return self;
}
-(void)dealloc
{
    [nodes release], nodes = nil ;
    [oldroot release], oldroot = nil;
    [treeNodes release], treeNodes = nil;
    [super dealloc];
}
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary
{
    if (![[dictionary allKeys] count])
        return NULL;
    
    XMLWriter* fromDictionary = [[[XMLWriter alloc]init]autorelease];
    [fromDictionary serialize:dictionary];
    return [fromDictionary xmlString];
}
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error
{
    
    XMLWriter* fromDictionary = [[[XMLWriter alloc]init]autorelease];
    [fromDictionary serialize:dictionary];
    [[fromDictionary xmlString] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:error];
    return YES;

}

-(void)serialize:(id)root
{
    [self pushRootHistory:root];
    
    if([root isKindOfClass:[NSArray class]])
        {
            [treeNodes addObject:root];

            for (int i = 0;i <[root count];i++)
            {
                if([[root objectAtIndex:i] isKindOfClass:[NSString class]])
                [self pushStackValue:[root objectAtIndex:i]];
                    else
                [self serialize:[root objectAtIndex:i]];
                nodeCounts++;
            }
            [treeNodes removeLastObject];


        }
        else if ([root isKindOfClass:[NSDictionary class]])
        {
            NSArray* trunk = [root allKeys];
            currentNode++;
            NSString* storeTag;
            for(int i =0;i<[trunk count];i++){
                treeLevel = currentNode;
                storeTag = [trunk objectAtIndex:i];
                [self Stack:storeTag];
                [self serialize:[root objectForKey:[trunk objectAtIndex:i ]]];
            }
            currentNode--;
        }
        else if ([root isKindOfClass:[NSString class]])
        {
            objectlevel ++;
            treeLevel = (objectlevel+currentNode);
                [self pushStackValue:root];

            objectlevel --; //string end
        }
        
}
-(void)pushRootHistory:(id)root
{
    if(![oldroot count])
        [oldroot removeLastObject];
    [oldroot addObject:root];
}
-(id)callOldRoot
{
    return [oldroot objectAtIndex:0];
}
-(NSString *)nodeIndex
{
    return [nodes objectAtIndex:(node-1)];
}
-(void)push:(NSString *)stack
{
    [nodes addObject:stack];
    node++; 
    
}
-(void)pop
{
//    xml = [xml stringByAppendingFormat:@"</%@>",[self nodeIndex]];                
    node--;
    [nodes removeLastObject];
}
-(void)Stack:(NSString *)stack
{

    for (int i = treeLevel; i < [nodes count]; i++) {
        
        [self pop];

    } 
    [self checkParent];    
//    NSLog(@" <> stack => %@",stack);

    [self push:stack];
    xml = [xml stringByAppendingFormat:@"<%@>",stack];

   
}
-(void)checkParent
{
    if (0<nodeCounts)
    {   
//        NSLog(@"%d ====> %@",nodeCounts,[self nodeIndex]);
        xml = [xml stringByAppendingFormat:@"</%@>",[self nodeIndex]];                
//        xml = [xml stringByAppendingFormat:@"<%@>",[self nodeIndex]];
        nodeCounts--;
    }
}
-(void)pushStackValue:(NSString *)stack
{
    [self push:stack];
//    NSLog(@" Ω stack => %@",stack);

    xml = [xml stringByAppendingFormat:@"%@",stack];
    node--;
    [nodes removeLastObject];
    xml = [xml stringByAppendingFormat:@"</%@>",[self nodeIndex]];                

    
}
-(NSString *)endString
{

    node--;
    [nodes removeLastObject];

    do{
        node--;
        xml = [xml stringByAppendingFormat:@"</%@>",[nodes objectAtIndex:node]]; 
        [nodes removeLastObject];

    }while (node != 0);
    

    return self.xml;
}

-(NSString *)xmlString
{
    return [self endString];
}
@end
