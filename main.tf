data "aws_lambda_function" "lambda_function" {
    function_name = var.lambda_function_name
}

resource "aws_cloudwatch_event_rule" "schedule_event" {
    name = "${var.lambda_function_name}-schedule-event"
    description = "Triggers on a schedule to keep Lambda warm"
    schedule_expression = var.event_rule_schedule
}

resource "aws_cloudwatch_event_target" "check_lambda_on_schedule" {
    rule = "${aws_cloudwatch_event_rule.schedule_event.name}"
    target_id = "${var.lambda_function_name}-event-targetId"
    arn = "${data.aws_lambda_function.lambda_function.arn}"
}

# create role to allow schedule execution
resource "aws_lambda_permission" "allow_cloudwatch_to_schedule_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${var.lambda_function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.schedule_event.arn}"
}