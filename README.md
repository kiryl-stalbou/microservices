# Docker Setup

Run all microservices using Docker.

## Prerequisites

- **Docker** installed and running.

## Commands

1. **Build and Start All Services**:

   docker-compose up --build

2. **Stop All Services**:

   docker-compose down


# Specification

## Cart Service

1. **Add Products to Cart**
- URL: /cart
- Method: POST
- Request: { "productId": "1", "quantity": 2 }
- Response: Products added to cart.
- Curl: curl -X POST http://localhost:8081/cart \
        -H "Content-Type: application/json" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9" \
        -d '{"productId": "1", "quantity": 2}'

2. **Get User's Cart**
- URL: /cart
- Method: GET
- Response: [ { "productId": "1", "quantity": 2 } ]
- Curl: curl -X GET http://localhost:8081/cart \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9"


## Delivery Service

1. **Create Order**
- URL: /order
- Method: POST
- Request: { "address": "123 Main St" }
- Response: Order created successfully
- Curl: curl -X POST http://localhost:8082/order \
        -H "Content-Type: application/json" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9" \
        -d '{"address": "123 Main St"}'

2. **Get Order**
- URL: /order
- Method: GET
- Response: { "address": "123 Main St" }
- Curl: curl -X GET "http://localhost:8082/order" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9"


## Payment Service

1. **Process Payment**
- URL: /payment
- Method: POST
- Request: { "orderId": "87654321", "amount": 100.00 }
- Response: Payment processed successfully
- Curl: curl -X POST http://localhost:8083/payment \
        -H "Content-Type: application/json" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9" \
        -d '{"orderId": "1", "amount": 100.00}'

2. **Get Payment Status**
- URL: /payment
- Method: GET
- Request: Query parameter ?orderId=1
- Response: { "orderId": "87654321", "status": "paid" }
- Curl: curl -X GET "http://localhost:8083/payment?orderId=1" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9"


## Product Service

1. **Add Product**
- URL: /product
- Method: POST
- Request: { "productId": "1", "name": "Product A", "price": 50.0 }
- Response: Product added successfully
- Curl: curl -X POST http://localhost:8084/product \
        -H "Content-Type: application/json" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9" \
        -d '{"productId": "1", "name": "Product A", "price": 50.0}'

2. **Get Product**
- URL: /product
- Method: GET
- Request: Query parameter productId, e.g., /product?productId=1
- Response: { "productId": "1", "name": "Product A", "price": 50.0 }
- Curl: curl "http://localhost:8084/product?productId=1" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9"


## Review Service

1. **Post Review**
- URL: /review
- Method: POST
- Request: { "productId": "1", "rating": 4, "comment": "Great product!" }
- Response: Review added successfully
- Curl: curl -X POST http://localhost:8085/review \
        -H "Content-Type: application/json" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9" \
        -d '{"productId": "1", "rating": 4, "comment": "Great product!"}'

2. **Get Reviews by Product ID**
- URL: /review
- Method: GET
- Request: Query parameter productId, e.g., /review?productId=1
- Response: [ { "productId": "1", "rating": 4, "comment": "Great product!" } ]
- Curl: curl "http://localhost:8085/review?productId=1" \
        -H "Authorization: eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9"


## User Service

1. **User Registration**
- URL: /register
- Method: POST
- Request: { "username": "John Doe", "password": "123" }
- Response: { "auth_token": "<auth_token>" }
- Curl: curl -X POST http://localhost:8086/register \
        -H "Content-Type: application/json" \
        -d '{"username": "John Doe", "password": "123"}'

2. **User Login**
- URL: /login
- Method: POST
- Request: { "username": "John Doe", "password": "123" }
- Response: { "auth_token": "<auth_token>" }
- Curl: curl -X POST http://localhost:8086/login \
        -H "Content-Type: application/json" \
        -d '{"username": "John Doe", "password": "123"}'

3. **Get User**
- URL: /user
- Method: GET
- Response: { "username": "John Doe", "password": "123" }
- Curl: curl -X GET "http://localhost:8086/user" \
        -H "Authorization: <auth_token>"
