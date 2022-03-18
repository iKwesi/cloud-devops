# Routing

Routing: Routing is the action of applying routing rules to your network, in this case, to your VPC.
Routing rule: Resources follow the routing rule, which defines what resource has access to communicate with another resource. It blocks traffic from resources that do not follow the routing rule.

#### Route Tables
We create `RouteTables` for `VPCs` so that we can add `Routes` that we later associate with `Subnets`. The following is the syntax used to define a RouteTable:

```
Type: AWS::EC2::RouteTable
Properties: 
  Tags: 
    - Tag
  VpcId: String
  ```

The only required property for setting up a RouteTable is the VpcId. Here is an example table:

```
PublicRouteTable:
        Type: AWS::EC2::RouteTable
        Properties: 
            VpcId: !Ref VPC
            Tags: 
                - Key: Name 
                  Value: !Sub ${EnvironmentName} Public Routes 
```
#### Routes
The following is the syntax used to set up our `Route`:

```
Type: AWS::EC2::Route
Properties: 
  DestinationCidrBlock: String
  DestinationIpv6CidrBlock: String
  EgressOnlyInternetGatewayId: String
  GatewayId: String
  InstanceId: String
  NatGatewayId: String
  NetworkInterfaceId: String
  RouteTableId: String
  VpcPeeringConnectionId: String
  ```

The `DestinationCidrBlock` property is used for destination matching and a `wildcard address` (`0.0.0/0`) to reference all traffic. So in the following example, when we use the wildcard address `0.0.0.0/0`, we are saying for any address that comes through this route, send it to the referenced `GatewayId`:

``` 
DefaultPublicRoute: 
        Type: AWS::EC2::Route
        DependsOn: InternetGatewayAttachment
        Properties: 
            RouteTableId: !Ref PublicRouteTable
            DestinationCidrBlock: 0.0.0.0/0
            GatewayId: !Ref InternetGateway
```

#### SubnetRouteTableAssociation
In order to associate `Subnets` with our `Route Table` we will need to use a `SubnetRouteTableAssociation`. `SubnetRouteTableAssociation`s are defined using the following syntax:

```
Type: AWS::EC2::SubnetRouteTableAssociation
Properties: 
  RouteTableId: String
  SubnetId: String
```

This only takes two properties, which are the id's used for our `RouteTable` and our `Subnet`. You can see references used in the example:
```
PublicSubnet1RouteTableAssociation:
        Type: AWS::EC2::SubnetRouteTableAssociation
        Properties:
            RouteTableId: !Ref PublicRouteTable
            SubnetId: !Ref PublicSubnet1
```

Important Note: `Routes` should be defined starting with the most specific rule and transitioning to the least specific rule.

```
PublicRouteTable:
        Type: AWS::EC2::RouteTable
        Properties: 
            VpcId: !Ref VPC
            Tags: 
                - Key: Name 
                  Value: !Sub ${EnvironmentName} Public Routes

    DefaultPublicRoute: 
        Type: AWS::EC2::Route
        DependsOn: InternetGatewayAttachment
        Properties: 
            RouteTableId: !Ref PublicRouteTable
            DestinationCidrBlock: 0.0.0.0/0
            GatewayId: !Ref InternetGateway

    PublicSubnet1RouteTableAssociation:
        Type: AWS::EC2::SubnetRouteTableAssociation
        Properties:
            RouteTableId: !Ref PublicRouteTable
            SubnetId: !Ref PublicSubnet1

    PublicSubnet2RouteTableAssociation:
        Type: AWS::EC2::SubnetRouteTableAssociation
        Properties:
            RouteTableId: !Ref PublicRouteTable
            SubnetId: !Ref PublicSubnet2


    PrivateRouteTable1:
        Type: AWS::EC2::RouteTable
        Properties: 
            VpcId: !Ref VPC
            Tags: 
                - Key: Name 
                  Value: !Sub ${EnvironmentName} Private Routes (AZ1)

    DefaultPrivateRoute1:
        Type: AWS::EC2::Route
        Properties:
            RouteTableId: !Ref PrivateRouteTable1
            DestinationCidrBlock: 0.0.0.0/0
            NatGatewayId: !Ref NatGateway1

    PrivateSubnet1RouteTableAssociation:
        Type: AWS::EC2::SubnetRouteTableAssociation
        Properties:
            RouteTableId: !Ref PrivateRouteTable1
            SubnetId: !Ref PrivateSubnet1

    PrivateRouteTable2:
        Type: AWS::EC2::RouteTable
        Properties: 
            VpcId: !Ref VPC
            Tags: 
                - Key: Name 
                  Value: !Sub ${EnvironmentName} Private Routes (AZ2)

    DefaultPrivateRoute2:
        Type: AWS::EC2::Route
        Properties:
            RouteTableId: !Ref PrivateRouteTable2
            DestinationCidrBlock: 0.0.0.0/0
            NatGatewayId: !Ref NatGateway2

    PrivateSubnet2RouteTableAssociation:
        Type: AWS::EC2::SubnetRouteTableAssociation
        Properties:
            RouteTableId: !Ref PrivateRouteTable2
            SubnetId: !Ref PrivateSubnet2
```

#### Resources
- [Route Tables Overview](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
- [Route Table Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route-table.html)
- [Route Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html)
- [Subnet Route Table Association Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-route-table-assoc.html)