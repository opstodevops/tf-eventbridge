##################################################################################
# RESOURCES
##################################################################################

resource "aws_cloudformation_stack" "eventbridge_bus" {
  name = "eventbridge-bus"

  template_body = <<EOF
Resources:
  EventBus:
    Type: AWS::Events::EventBus
    Properties:
      Name: orders
EOF
}

resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name        = "catchall-invoice"
  description = "Catch all events for invoice"

  event_pattern = <<EOF
{
  "account": [
    "$(data.aws_caller_identity.current.account_id)"
  ]
}
EOF
}