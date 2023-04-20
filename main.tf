#Terraform code will cover the creation of:

# Private Subnet

resource "aws_subnet" "private_subnet" {
    vpc_id     = data.aws_vpc.vpc.id
    cidr_block = "10.0.21.0/24"
    map_public_ip_on_launch = false
     


  tags = {
    Name = "private_subnet"
  }

  
}
# Routing Table

resource "aws_route_table" "route_table" {
  vpc_id = data.aws_vpc.vpc.id

    route {
      
      cidr_block = "0.0.0.0/0"
      
      nat_gateway_id = data.aws_nat_gateway.nat.id
      
    }
  tags = {
    Name = "route_table"
  }   
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.route_table.id
}
# Lambda Function

#Security Group

resource "aws_security_group" "default" {
    
    description = "Default security group to allow inbound/outbound from the VPC"
    vpc_id = data.aws_vpc.vpc.id
    depends_on = [
        data.aws_vpc.vpc
    ]

       egress {
          from_port = "0"
          to_port   = "0"
          protocol  = "-1"
          self      = "true"
    }

    tags = {
        Name = "default"
    }
}
  
  #Lambda function
  data "archive_file" "Maheshlambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "Maheshlambda_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "Maheshlambda_payload.zip"
  function_name = "lambda_function_Mahesh"
  description = "This is Lambda function create to execute payload"
  role          = data.aws_iam_role.lambda.arn
  handler       = "lambda.lambda_handler" #[Refernece Python sciptname.function]

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"
   vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.default.id]
  }
  environment {
    variables = {
      Mahesh_Subnet = aws_subnet.private_subnet.id
    }
  }
}
