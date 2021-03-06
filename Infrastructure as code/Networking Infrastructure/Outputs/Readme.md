# Outputs

Outputs are optional but are very useful if there are output values you need to:

- import into another stack
- return in a response
- view in AWS console
To declare an `Output` use the following syntax:

```
Outputs:
  Logical ID:
    Description: Information about the value
    Value: Value to return
    Export:
      Name: Value to export
```

The `Value` is required but the `Name` is optional. In the following example we are returning the id of our `VPC` as well as our Environment's Name:

``` 
VPC: 
        Description: A reference to the created VPC
        Value: !Ref VPC
        Export:
          Name: !Sub ${EnvironmentName}-VPCID
```

## Join Function

You can use the `join` function to combine a group of `values`. The syntax requires you provide a `delimiter` and a list of values you want appended.

`Join` function syntax:

`Fn::Join: [ delimiter, [ comma-delimited list of values ] ]`

In the following example we are using `!Join` to combine our subnets before returning their values:

```
PublicSubnets:
        Description: A list of the public subnets
        Value: !Join [ ",", [ !Ref PublicSubnet1, !Ref PublicSubnet2 ]]
        Export:
          Name: !Sub ${EnvironmentName}-PUB-NETS
```

### Resources

- [Outputs Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html)
- [Join Function](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-join.html)
- [Substitutes](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-sub.html)