variable "event_rule_schedule" {
    description = "The schedule in minutes the event rule triggers"
    default = "rate(10 minutes)"
}

variable "lambda_function_name" {
    description = "The lambda function name"
}