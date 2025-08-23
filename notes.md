VPC:
on primises:
==========
physical space
power
network
AC
physical security
Buy server
Install OS
configure networking

Data centre == VPC
VPC means an isolated space where we can create project resources and control them




terraform-aws-instance
    variables
    locals
    functions
    resources
    outputs --- instance_id
    data sources
    readme.md 

roboshop-ec2

modules "roboshop" {
    source = "../terraform-aws-instance"
    #mandatory values and values should be given
    var-name = value
    # we can also overide the deafault values

}

output "name" {
    module.roboshop.instance_id  # you will get instance id as a output
}

VPC:

entrance --->village ----> streets ---> Roads
IGW ---->    VPC -------> Subnets ----> Routes

SYS1 ---> SYS2 --->(small connection) CONNECT means networking . He for multiple system connections we use IGW

Example:
pincode ---500032
VPC ---> CIDR
subents -----> streets

32 bits = 4 * 8
why we are creatin 2 availablity zones:
beacuse of disater recovery
1 region altest have 2 availablity zones

manual VPC creation :
=======================

VPC ----> vpc only ---> roboshop --> CIDR = 10.0.0.0/16 ---> create vpc
now need to attach IGW
internet gateway ---> roboshop --> Attach to VPC --> create
now we will create subnets
subnets ---> create subnet ---> name ---> roboshop-public-1a ---> subenet cidr block 
=10.0.1.0/24 ---> create
subnets ---> create subnet ---> name ---> roboshop-public-1b ---> subenet cidr block 
=10.0.2.0/24 ---> create

subnets ---> create subnet ---> name ---> roboshop-private-1a ---> subenet cidr block 
= 10.0.11.0/24 ---> create
subnets ---> create subnet ---> name ---> roboshop-private-1b ---> subenet cidr block 
= 10.0.12.0/24 ---> create

subnets ---> create subnet ---> name ---> roboshop-database-1a ---> subenet cidr block 
= 10.0.21.0/24 ---> create
subnets ---> create subnet ---> name ---> roboshop-database-1b ---> subenet cidr block 
= 10.0.22.0/24 ---> create

Now we will create route tables for each

route table ---> create route table ---> roboshop public ---> vpc ---> create
vpc ---> route table ---> edit ---->
public means ----> 0.0.0.0/0 ---> internet notation----> Internet gateway
subnet assications ---> edit ---> and public ---> save
attach route to public----> vpc ---> route tables ---> edit and attach

Here the request will come from local and internet gateway/ it will conatin routeto the internet

route table ---> create route table ---> roboshop private ---> vpc ---> create
subnet assiocation ---> add private ---dsave
route table ---> create route table ---> roboshop-database ---> vpc ---> create
subnet assiocation ---> add database ---dsave



---------------------
create VPC
Create IGW
attach VPC to IGW
create 2 public subnets
create 2 private subnets
create 2 database subnets
create public route
add inetrent as a route throught IGW
attach public 1a and public 1b
create private route
attach private 1a and private 1b
create database route
attach database 1a and database 1b



-----------------------------------------------------------------------
ROBOSHOP:
============
# frontend
80 ----> http ---> public
443 ----> https --->public sercure
22 ----> ssh ----> login for admins

* before creating instances we need SG


# if we want install any packages or doing anything from private
ex: take vpc real time example
here public will not directly ta with database( means there is no scope for incoming traffic)
but private is can talk with public (means outgoing traffic)

dnf install mysql-server ----> HTTP
outgoing -----> incoming
here waht is incoming traffic and what is outgoing traffic
incoming means someone is connecting wih mysql

consider we have one linux server: that need to hit the repo--->
the traffic is generated from instances
system --> request ---> repos ---> hit ---> installing nginx

here ingress traffic is not safe but egress tarffic is safe.
In that case we use NAT gates (pubic subenets)
It will take the traffic from outside
lest consider we have EC2 in database 

internet<-----tarffic <------NAT gate <-------- EC2
ingress           egress

here ec2 will request NAT gate.it will take traffic.
NAT means it is a service in AWS. It contain Elastic Ip

ec2 public instances on restart then the pubic Ip are changed. But are using rs3 based on the IP's --> It is not work if we restart--->it will change in the backend
NAT gateaway is also background server is in EC2 --->
so while creating the NAT gateway we need to give elastic IP ---> to get static IP
we can request to ISP(internet provier services) to provide static Ip.
They will provide and they will charge. IPv4 ---> here if server restared then the ip is not changed

before creating NAT gate:
===============================
VPC ----> elastip ----> us-east-1 ---> we will get one IP ---> we can use wherever we want
VPC ----> create NAT ------> roboshop-dev ----> allocate elstic ip ---> create

so here
elastic ip ----> NAT gate ----> we need to add route 

NAT gateway doesn't require IGW but if NAT gateway wants to go out it needs go from IGW ----> we added public subnet to IGW

internet<-----IGW <------tarffic <------NAT gate <-------- EC2
ingress                                                   egress

NAT gateaway enables oubound traffic for the instances in private subnets
==================

# peering
-=====================

two villages can communicate:
============================
1. should have diffrent pincode
2. roads should be available
default two vpc's by can't connect. If we want we can enable VPC peering.

2nd VPC possiblities:
=====================
my account same region
my account diffrent region

diff account diff region
diff account same region

# here i am connection with default vpc with roboshop-dev
VPC ---->  peering connection ---> create ---> roboshop-default --->account =my account ----> region=this region ---> vpc id ---> create peering ---> Accept

# now need to create a road right

roboshop (10.0.0.0/16) ---> default (172.31.0.0/16)

roboshop public ---> default VPC
public RT destination is 172.31.0.0/16
target peering

deafult VPC
destination 10.0.0.0/16
target peering

connections:
==============
172.31.0.0/16 ---accepter
10.0.0.0/16 ---Requester VPC
VPC ---> route tables ----> roboshop-public-dev ----> routes ---> edit routes --->
add route ---> (172.31.0.0/16) ---> peering connection ----> select -----> save

# now mypublic instance is reach out to default VPC

# now default VPC needs to send the tarffic back

VPC ---> route tables ----> default ----> routes ---> edit routes --->
add route ---> (10.0.0.0/16) ---> peering connection ----> select -----> save
# this is manullay ---> delete after we will do from terraform



what we complted:
================
VPC
IGW and associate with VPC
subnets
elasti ip
NAT
ROUTE tables
routes
subnets and route table associations
peering


Trobuleshooting: (routes.io)
=====================
let consider we are not creating peering

aws account:

roboshop-vpc ---public-sub-net ---ec2
default-vpc ---public-sub-net ---ec2

VPC -----> create ----Vpcforinstance

EC2 ---> default--->t3.micro---->sg (public)---> create ---> lanch
EC2 ---> roboshop--->t3.micro---->sg(private) ---> create ---> lanch

default ---> sudo dnf install nginx ----->systemctl start nginx ---> curl localhost--> It will give resposne
publicip

roboshop ----> curl <default-publicI> ----> It will give resposnes
roboshop ----> curl <default-private> ----> It will not give resposnes ----> beacuse there is no connection b/w them
# now we will create connection b/w them
VPC ----> peering connection ---->roboshop-default ---->roboshop(VPC) -----> my account ---> my region ---> default(vpc) ----> create---> Accept
# now we have generated peering connection
# before taking IP it will check routes
# the traffic will go from subnets
# 1st traffic will go from instances ---> egrss traffic(outbound) ------>
Ec2---->roboshop ----> oubound traffic -----> all all ----> from here the taffic will go out and check in subnet
# curl <default-private> is this Ip in this network 
subnet ----> roboshop-public-us-east-1a ----> route table ----> 10.0.0.0/16 =local  ---> No
                                                                0.0.0.0/0 =IGW ----> Yes
# we need to create route table 
route table ---> roboshop-dev-public ---> here we need to create one route ---> edit ----> 172.31.0.0/16 (CIDR range for default VPC)-----> IGW ----> here we need to entre from the peering ----> peering connection -----> save changes
# till here the traffic come from subnet from it is not conneted to another beacuse there is no route on default side
# we need to add here also
route table ---> default ---> route ---> edit ----> 10.0.0.0/16 ----> peering connection ----> save
# now we will check on roboshop ec2
check with private ip
telent <default-privateip> or we can also do shh ec2-user <ip>
# delete and we will done from terraform



