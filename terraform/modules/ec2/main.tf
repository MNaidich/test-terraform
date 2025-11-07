# --- 1. IAM Role for EC2 ---
resource "aws_iam_role" "role_streamlit_app" {
  name = "${var.project_name}-${var.environment}-streamlit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# --- 2. IAM Policy for S3 Read-Only Access ---
resource "aws_iam_policy" "s3_read_policy" {
  name        = "${var.project_name}-${var.environment}-s3-read-policy"
  description = "Grants read-only access to the specified S3 bucket for Streamlit EC2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowS3Read",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# --- 3. Attach IAM Policy to Role ---
resource "aws_iam_role_policy_attachment" "s3_read_attach" {
  role       = aws_iam_role.role_streamlit_app.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# --- 4. Create IAM Instance Profile ---
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project_name}-${var.environment}-instance-profile"
  role = aws_iam_role.role_streamlit_app.name
}

# --- 5. EC2 Instance Definition ---
resource "aws_instance" "streamlit_host" {

  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile   = aws_iam_instance_profile.app_profile.name

  user_data = <<-EOF
    #!/bin/bash
    # Update and install dependencies
    sudo yum update -y
    sudo yum install -y python3 python3-pip

    # Install Python packages
    pip3 install streamlit pandas boto3

    # Download and run the Streamlit app from S3
    aws s3 cp s3://${var.s3_bucket_name}/python_files/streamlit_app.py /home/ec2-user/streamlit_app.py
    streamlit run /home/ec2-user/streamlit_app.py --server.port 8501 --server.enableCORS false &
  EOF

  tags = {
    Name        = "${var.project_name}-streamlit-host"
    Environment = var.environment
  }
}

# --- 6. Get the Latest Amazon Linux AMI ---
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
