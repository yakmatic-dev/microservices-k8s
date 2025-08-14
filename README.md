## 1. Overview <a name="overview"></a>
Online Boutique is a cloud-native microservices demonstration application implementing a complete e-commerce platform. This application showcases a modern, cloud-first architecture with 11 microservices handling different aspects of an online store. Users can browse products, add items to their cart, and complete purchases. The project demonstrates industry best practices in containerization, Kubernetes orchestration, observability, and resilience engineering.

## 2. Microservices Architecture <a name="microservices-architecture"></a>
## Microservices Architecture

### Core Services

| Service                   | Language | Port      | Description                                                                 |
|---------------------------|----------|-----------|-----------------------------------------------------------------------------|
| **frontend**              | Go       | 80        | Web interface serving the e-commerce site with React UI                     |
| **cartservice**           | C#       | 7070      | Manages shopping cart items using Redis storage                             |
| **productcatalogservice** | Go       | 3550      | Provides product listings and search functionality                          |
| **currencyservice**       | Node.js  | 7000      | Handles real-time currency conversions                                      |
| **paymentservice**        | Node.js  | 50051     | Processes credit card transactions (mock implementation)                    |
| **shippingservice**       | Go       | 50051     | Calculates shipping costs and simulates order fulfillment                   |
| **emailservice**          | Python   | 5000      | Sends order confirmation emails (mock service)                              |
| **checkoutservice**       | Go       | 5050      | Orchestrates payment, shipping, and notification workflows                 |
| **recommendationservice** | Python   | 8080      | Provides product recommendations based on cart contents                     |
| **adservice**             | Java     | 9555      | Displays contextual text ads based on user activity                         |
| **shoppingassistantservice** | Go    | 8080      | Provides AI-powered shopping recommendations (custom extension)             |

### Supporting Infrastructure

| Component          | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Redis**          | Persistent storage for cartservice (StatefulSet with PVC)                   |
| **PostgreSQL**     | Primary database for order history and user data                            |
| **Prometheus**     | Metrics collection and time-series database                                 |
| **Grafana**        | Visualization dashboard for monitoring and observability                    |
| **Alertmanager**   | Handles alerts from Prometheus                                              |

### Deployment Architecture

```mermaid
graph TD
    A[User] --> B[frontend:80]
    B --> C[productcatalogservice:3550]
    B --> D[cartservice:7070]
    B --> E[currencyservice:7000]
    D --> F[redis:6379]
    B --> G[checkoutservice:5050]
    G --> H[paymentservice:50051]
    G --> I[shippingservice:50051]
    G --> J[emailservice:5000]
    B --> K[recommendationservice:8080]
    B --> L[adservice:9555]
    B --> M[shoppingassistantservice:8080]
    N[Prometheus] --> O[All Services]
    O --> P[Grafana Dashboard]
    Q[PostgreSQL] --> R[Order History]
    S[Horizontal Pod Autoscaler] --> T[CPU/Memory Metrics]
    U[Network Policy] --> V[Service-to-Service Communication]
