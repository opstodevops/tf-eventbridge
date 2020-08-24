### 02-TransformEvent-EventBridge

This repository is for putting a transformed event in a CloudWatch log group by manually invoking a lambda function.

WIP: The transformation rule is yet to be written.

#### Event from CloudWatch Logs
```
{
    "version": "0",
    "id": "5132f118-5147-0d3b-33f0-eab73c998dd3",
    "detail-type": "New Order",
    "source": "Order Service",
    "account": "448051883053",
    "time": "2020-08-23T21:59:32Z",
    "region": "us-east-1",
    "resources": [],
    "detail": {
        "orderNumber": "123",
        "productId": "ISN123",
        "price": 100,
        "customer": {
            "name": "Jane Doe",
            "customerId": "1",
            "address": "galaxy far far away"
        }
    }
}
```
#### Custom Pattern
```
"{\"source\": [\"Order Service\"],\"detail-type\":[\"New Order\"]}"
```

#### Testing the validity of the custom pattern against the event
```
aws events test-event-pattern --event-pattern "{\"source\": [\"Order Service\"],\"detail-type\":[\"New Order\"]}" --event '{
    "version": "0",
    "id": "5132f118-5147-0d3b-33f0-eab73c998dd3",
    "detail-type": "New Order",
    "source": "Order Service",
    "account": "448051883053",
    "time": "2020-08-23T21:59:32Z",
    "region": "us-east-1",
    "resources": [],
    "detail": {
        "orderNumber": "123",
        "productId": "ISN123",
        "price": 100,
        "customer": {
            "name": "Jane Doe",
            "customerId": "1",
            "address": "galaxy far far away"
        }
    }
}'
```
