

data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${var.lambda_function_file}"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "${data.archive_file.lambda_function.output_path}"
  function_name    = "${var.lambda_function_name}"
  description      = "${var.lambda_function_description}"
  role             = "${var.lambda_function_iam_role_arn}"
  handler          = "${var.lambda_function_handler}"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:

  #source_code_hash = "${filebase64sha256(data.archive_file.lambda_function.output_base64sha256)}"
  source_code_hash = "${data.archive_file.lambda_function.output_base64sha256}"

  runtime          = "${var.lambda_function_runtime}"
  timeout          = "${var.lambda_function_timeout}"
  memory_size      = "${var.lambda_function_memory_size}" 

  tags             = "${var.lambda_function_tags}"

  environment {
    variables      = "${var.lambda_function_env}"
  }
}
