1 Получить ключи aws

I Install prerequisites
1) install python3, python3-pip,
2) install venv: pip3 install virtualenv
3) create venv: virtualenv /path/to/env
4) use venv: source /path/to/env/bin/activate
5) install ansible: pip install ansible


II Setup aws environment
1) go to aws.amazon.com and make auth
2) Open the IAM console.In the navigation pane, choose Users.
3) Choose your IAM user name (not the check box). Choose the Security Credentials tab and then choose Create Access Key.
4) To see your access key, choose Show User Security Credentials. Your credentials will look something like this:
    Access Key ID: AKIAIOSFODNN7EXAMPLE
    Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    Choose Download Credentials, and store the keys in a secure location.
5) Export your credentials to env
    export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
    export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    export EC2_REGION='us-east-1'
6) Create a security group, e.g. sg_naviaddress - see Amazon's docs
    a)
    b)
7) Create a load balancer, e.g. lb-naviaddress - see Amazon's docs
    a)
    b)
8) Setup domain in route53 - see Amazon's docs
    a)
    b)
9)

III Setup dynamic inventory
1)
2)
3)