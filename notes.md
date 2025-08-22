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