import { 
  Vpc,
  SubnetType,
  SecurityGroup,
  Peer,
  Port,
  Instance,
  InstanceType,
  InstanceClass,
  InstanceSize,
  GenericLinuxImage,
  BlockDevice,
  BlockDeviceVolume,
} from 'aws-cdk-lib/aws-ec2';
import { Role, ServicePrincipal, ManagedPolicy } from 'aws-cdk-lib/aws-iam';
import { Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { readFileSync } from 'fs';

export class DevInfraBuilderStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
  
    const vpc = new Vpc(this, 'vpc-dev-machine', {
      cidr: '10.0.0.0/16',
      natGateways: 0,
      subnetConfiguration: [
        {name: 'public', cidrMask: 24, subnetType: SubnetType.PUBLIC },
      ],
    });

    const devMachineSG = new SecurityGroup(this, 'dev-machine-sg', {
      vpc,
      allowAllOutbound: true,
    });

    //devMachineSG.addIngressRule(
    //  Peer.anyIpv4(),
    //  Port.tcp(22),
    //  'Allow SSH access from anywhere',
    //);
  
    const devMachineRole = new Role(this, 'dev-machine-role', {
      assumedBy: new ServicePrincipal('ec2.amazonaws.com'),
      managedPolicies: [
        ManagedPolicy.fromAwsManagedPolicyName('AmazonS3ReadOnlyAccess'),
      ],
    });
    
    const ec2Instance = new Instance(this, 'dev-machine-instance', {
      vpc,
      vpcSubnets: {
        subnetType: SubnetType.PUBLIC,
      },
      role: devMachineRole,
      securityGroup: devMachineSG,
      instanceType: InstanceType.of(
        InstanceClass.BURSTABLE2,
        InstanceSize.MEDIUM,
      ),
      machineImage: new GenericLinuxImage({
        'ca-central-1': 'ami-0b6937ac543fe96d7' 
      }),
      blockDevices: [
        {
          deviceName: '/dev/sda1',
          volume: BlockDeviceVolume.ebs(60),
        }
      ],
      keyName: 'dev-machine-key-pair',
    });

    const userDataScript = readFileSync('./lib/user-data.sh', 'utf-8');
    ec2Instance.addUserData(userDataScript);
  }
}
