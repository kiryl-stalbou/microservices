# Microservices Docker Setup

Run all Dart microservices locally using Docker and Docker Compose.

## Prerequisites

- **Docker** and **Docker Compose** installed.

## Commands

1. **Build and Start All Services**:

   docker-compose up --build

2. **Stop All Services**:

   docker-compose down


# Microservices Specification

## Cart Service

1. **Add Product to Cart**
- URL: /cart
- Method: POST
- Request: { "userId": "12345678", "productId": "1", "quantity": 2 }
- Response: Product added to cart
- Curl: curl -X POST http://localhost:8083/cart -H "Content-Type: application/json" -d '{"userId": "12345678", "productId": "1", "quantity": 2}'

2. **Get User's Cart**
- URL: /cart
- Method: GET
- Request: Query parameter userId, e.g., /cart?userId=12345678
- Response: [ { "productId": "1", "quantity": 2 } ]
- Curl: curl "http://localhost:8083/cart?userId=12345678"


## Delivery Service
1. **Create Order**
- URL: /order
- Method: POST
- Request: { "userId": "12345678", "address": "123 Main St" }
- Response: Order created successfully
- Curl: curl -X POST http://localhost:8085/order -H "Content-Type: application/json" -d '{"userId": "12345678", "address": "123 Main St"}'

2. **Get Order**
- URL: /order
- Method: GET
- Request: Query parameter userId, e.g., /order?userId=12345678
- Response: { "userId": "12345678", "address": "123 Main St" }
- Curl: curl "http://localhost:8085/order?userId=12345678"


## Payment Service
1. **Process Payment**
- URL: /payment
- Method: POST
- Request: { "userId": "12345678", "orderId": "87654321", "amount": 100.00 }
- Response: Payment processed successfully
- Curl: curl -X POST http://localhost:8084/payment -H "Content-Type: application/json" -d '{"userId": "12345678", "orderId": "87654321", "amount": 100.00}'

2. **Get Payment Status**
- URL: /payment
- Method: GET
- Request: Query parameter userId and orderId, e.g., /payment?userId=12345678&orderId=87654321
- Response: { "userId": "12345678", "orderId": "87654321", "status": "paid" }
- Curl: curl "http://localhost:8084/payment?userId=12345678&orderId=87654321"


## Product Service
1. **Add Product**
- URL: /product
- Method: POST
- Request: { "productId": "1", "name": "Product A", "price": 50.0 }
- Response: Product added successfully
- Curl: curl -X POST http://localhost:8082/product -H "Content-Type: application/json" -d '{"productId": "1", "name": "Product A", "price": 50.0}'

2. **Get Product**
- URL: /product
- Method: GET
- Request: Query parameter productId, e.g., /product?productId=1
- Response: { "productId": "1", "name": "Product A", "price": 50.0 }
- Curl: curl "http://localhost:8082/product?productId=1"


## Review Service
1. **Post Review**
- URL: /review
- Method: POST
- Request: { "productId": "1", "userId": "12345678", "rating": 4, "comment": "Great product!" }
- Response: Review added successfully
- Curl: curl -X POST http://localhost:8086/review -H "Content-Type: application/json" -d '{"productId": "1", "userId": "12345678", "rating": 4, "comment": "Great product!"}'

2. **Get Reviews by Product ID**
- URL: /review
- Method: GET
- Request: Query parameter productId, e.g., /review?productId=1
- Response: [ { "productId": "1", "userId": "12345678", "rating": 4, "comment": "Great product!" } ]
- Curl: curl "http://localhost:8086/review?productId=1"


## User Service
1. **User Registration**
- URL: /register
- Method: POST
- Request: { "username": "user1", "password": "pass1" }
- Response: { "userId": "12345678" }
- Curl: curl -X POST http://localhost:8081/register -H "Content-Type: application/json" -d '{"username": "user1", "password": "pass1"}'

2. **User Login**
- URL: /login
- Method: POST
- Request: { "username": "user1", "password": "pass1" }
- Response: { "userId": "12345678" }
- Curl: curl -X POST http://localhost:8081/login -H "Content-Type: application/json" -d '{"username": "user1", "password": "pass1"}'

3. **Get User**
- URL: /user
- Method: GET
- Request: Query parameter userId, e.g., /user?userId=12345678
- Response: { "userId": "12345678", "username": "user1", "password": "pass1" }
- Curl: curl "http://localhost:8081/user?userId=12345678"

