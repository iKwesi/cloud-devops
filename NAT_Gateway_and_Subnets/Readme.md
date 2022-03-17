# NAT Gateway and Subnets

#### Adding Subnets
To specify a `Subnet` for your `VPC` you use the following syntax:

```
Type: AWS::EC2::Subnet
Properties: 
  AssignIpv6AddressOnCreation: Boolean
  AvailabilityZone: String
  CidrBlock: String
  Ipv6CidrBlock: String
  MapPublicIpOnLaunch: Boolean
  Tags: 
    - Tag
  VpcId: String
```

Here is the actual setup of our 2 private `Subnets`:

```
PrivateSubnet1
    Type: AWS::EC2::Subnet
    Properties:
        VpcId: !Ref VPC
        AvailabilityZone: !Select [ 0, !GetAZ's '' ]
        CirderBlock: !Ref PrivateSubnet1CIDR
        MapPublicIpOnLaunch: false
        Tags: 
            -   Key: Name
                Value: !Sub ${EnvironmentName} Private Subnet (AZ1)

PrivateSubnet2
    Type: AWS::EC2::Subnet
    Properties:
        VpcId: !Ref VPC
        AvailabilityZone: !Select [ 1, !GetAZ's '' ]
        CirderBlock: !Ref PrivateSubnet1CIDR
        MapPublicIpOnLaunch: false
        Tags: 
            -   Key: Name
                Value: !Sub ${EnvironmentName} Private Subnet (AZ2)
```

You can see the index being used from the returning `AvailabilityZone`'s array. Notice that our `subnets` are not sharing `AvailabilityZones`. We are keeping them separated like we displayed in our diagrams from the previous lesson:

PrivateSubnet1: `AvailabilityZone: !Select [ 0, !GetAZ's '' ]`

PrivateSubnet2: `AvailabilityZone: !Select [ 1, !GetAZ's '' ]`

This code:
```
!select [0, !GetAZs‘’]
```
calls the function GetAZ, which returns a list of availability zones, which are indexed 0, 1 etc.

Tip
- Name your subnets using tags, to keep track when you create many subnets

### Adding a NAT Gateway
You can use `NAT Gateways` in both your public and/or private `Subnets`. The following code is the basic syntax for declaring a `NAT Gateway`:
```
Type: AWS::EC2::NatGateway
Properties: 
  AllocationId: String
  SubnetId: String
  Tags: 
    - Tag
```

The following declarations are sample code:
```
NatGateway1EIP:
        Type: AWS::EC2::EIP
        DependsOn: InternetGatewayAttachment
        Properties: 
            Domain: vpc

    NatGateway2EIP:
        Type: AWS::EC2::EIP
        DependsOn: InternetGatewayAttachment
        Properties:
            Domain: vpc

    NatGateway1: 
        Type: AWS::EC2::NatGateway
        Properties: 
            AllocationId: !GetAtt NatGateway1EIP.AllocationId
            SubnetId: !Ref PublicSubnet1

    NatGateway2: 
        Type: AWS::EC2::NatGateway
        Properties:
            AllocationId: !GetAtt NatGateway2EIP.AllocationId
            SubnetId: !Ref PublicSubnet2
```

The `EIP` in `AWS::EC2::EIP` stands for Elastic IP. This will give us a known/constant IP address to use instead of a disposable or ever-changing IP address. This is important when you have applications that depend on a particular IP address. `NateGateway1EIP` uses this type for that very reason:

```
 NatGateway1EIP:
        Type: AWS::EC2::EIP
        DependsOn: InternetGatewayAttachment
        Properties: 
            Domain: vpc
```

Tip
Use the `DependsOn` attribute to protect your dependencies from being created without the proper requirements.
In the scenario above the `EIP` allocation will only happen after the `InternetGatewayAttachment` has completed.

#### Resources
- [Subnet Resource Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html)
- [DependsOn Attribute](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-dependson.html)
- [Creating NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html#nat-gateway-creating)
- [NAT Gateway Resource Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-natgateway.html)