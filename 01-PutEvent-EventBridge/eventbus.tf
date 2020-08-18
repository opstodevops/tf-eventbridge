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

data "aws_cloudformation_stack" "eventbridge_bus_name" {
    name = aws_cloudformation_stack.eventbridge_bus.name
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
  name = "order-catchall"

  tags = {
    Environment = "dev"
    Application = "invoice"
  }
}

data "aws_cloudformation_stack" "eventbridge_loggroup_name" {
    name = aws_cloudwatch_log_group.eventbridge_loggroup.id
}

resource "aws_cloudformation_stack" "eventbridge_rule" {
  name = "eventbridge-rule"

  template_body = <<EOF
Resources:
  EventRule: 
  Type: AWS::Events::Rule
  Properties:
    EventBusName: "${data.aws_cloudformation_stack.eventbridge_bus_name.name}"
    Description: "EventRule"
    EventPattern: 
      detail-type:
        - "TBD"
      detail: 
        userIdentity:
          type:
            - "${data.aws_caller_identity.current.account_id}"
    State: "ENABLED"
    Targets: 
      - Arn: "${data.aws_cloudformation_stack.eventbridge_loggroup_name.id}"
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