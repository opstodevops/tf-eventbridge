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
      Name: eventbridge-bus
EOF
}

# resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
#   name        = "catchall-invoice"
#   description = "Catch all events for invoice"

#   event_pattern = <<EOF
# {
#   "account": [
#     "${data.aws_caller_identity.current.account_id}"
#   ]
# }
# EOF
# }

resource "aws_cloudwatch_log_group" "eventbridge_loggroup" {
  name = "/aws/events/order-catchall"

  tags = {
    Environment = "dev"
    Application = "invoice"
  }
}


resource "aws_cloudformation_stack" "eventbridge_rule" {
  name = "eventbridge-rule"

  template_body = <<EOF
Resources:
  EventRule: 
    Type: AWS::Events::Rule
    Properties:
      EventBusName: "${aws_cloudformation_stack.eventbridge_bus.name}"
      Name: "catchall-invoice"
      Description: "EventRule"
      EventPattern:
        account:
          - "${data.aws_caller_identity.current.account_id}"
        # detail-type:
        #   - "TBD"
        # detail: 
        #   account:
        #     type:
        #       - "${data.aws_caller_identity.current.account_id}"
      State: "ENABLED"
      Targets: 
        - Arn: "${aws_cloudwatch_log_group.eventbridge_loggroup.arn}"
          Id: "01-TargetCWLogGroup"
#   PermissionForEventsToInvokeLambda: 
#     Type: AWS::Lambda::Permission
#     Properties: 
#       FunctionName: 
#         Ref: "LambdaFunction"
#       Action: "lambda:InvokeFunction"
#       Principal: "events.amazonaws.com"
#       SourceArn: 
#         Fn::GetAtt: 
#           - "EventRule"
#           - "Arn"
EOF
}