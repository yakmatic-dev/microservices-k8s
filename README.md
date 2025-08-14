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
4. Containerization Process <a name="containerization-process"></a>
All microservices were built from source and pushed to Docker Hub:

bash
# Docker images created
REPOSITORY                          TAG    IMAGE ID       CREATED       SIZE
yakub363/shoppingassistantservice   v1.0   50ef9c9f9cf7   2 hours ago   428MB
yakub363/shippingservice            v1.0   0b8dfc1d1072   2 hours ago   22.5MB
yakub363/recommendationservice      v1.0   43e6746ff945   2 hours ago   214MB
yakub363/productcatalogservice      v1.0   e4d0ffd01fc0   3 hours ago   35.1MB
yakub363/paymentservice             v1.0   8ca2a77ec4bb   3 hours ago   151MB
yakub363/frontend                   v1.0   8b89243d9614   4 hours ago   30.6MB
yakub363/emailservice               v1.0   f4b96c6c73a8   4 hours ago   177MB
yakub363/currencyservice            v1.0   029d2986e8d2   4 hours ago   158MB
yakub363/checkoutservice            v1.0   69834429763e   5 hours ago   23.4MB
yakub363/adservice                  v1.0   9522cff954da   6 hours ago   244MB
yakub363/cartservice                v1.0   49f346d3d4c3   6 hours ago   235MB

# Push to Docker Hub
for service in frontend cartservice productcatalogservice currencyservice \
paymentservice shippingservice emailservice checkoutservice \
recommendationservice adservice shoppingassistantservice; do
  docker push yakub363/$service:v1.0
done
5. Local Deployment with Docker Compose <a name="local-deployment-with-docker-compose"></a>
The application can be run locally using Docker Compose:

bash
git clone https://github.com/yakmatic-dev/microservices-k8s.git
cd microservices-k8s

sudo docker compose up -d

# Output
[+] Running 14/14
 ✔ Container emailservice             Started 
 ✔ Container productcatalogservice    Started 
 ✔ Container paymentservice           Started 
 ✔ Container redis                    Started 
 ✔ Container currencyservice          Started 
 ✔ Container adservice                Started 
 ✔ Container shippingservice          Started 
 ✔ Container shoppingassistantservice Started 
 ✔ Container cartservice              Started 
 ✔ Container recommendationservice    Started 
 ✔ Container checkoutservice          Started 
 ✔ Container frontend                 Started 
6. Kubernetes Deployment <a name="kubernetes-deployment"></a>
Full deployment to dev namespace with production-grade configurations:

Service Details <a name="service-details"></a>
bash
kubectl get services -n dev
NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
adservice                       ClusterIP   10.108.218.74    <none>        9555/TCP       5m7s
cartservice                     ClusterIP   10.103.63.94     <none>        7070/TCP       5m7s
checkoutservice                 ClusterIP   10.103.111.69    <none>        5050/TCP       5m7s
currencyservice                 ClusterIP   10.108.220.156   <none>        7000/TCP       5m7s
emailservice                    ClusterIP   10.103.140.24    <none>        5000/TCP       5m7s
frontend-service                NodePort    10.110.130.42    <none>        80:30080/TCP   5m7s
paymentservice                  ClusterIP   10.110.96.207    <none>        50051/TCP      5m7s
postgres                        ClusterIP   10.108.2.189     <none>        5432/TCP       5m7s
productcatalogservice           ClusterIP   10.105.204.77    <none>        3550/TCP       5m6s
recommendationservice           ClusterIP   10.100.153.189   <none>        8080/TCP       5m6s
redis                           ClusterIP   10.111.41.94     <none>        6379/TCP       5m6s
shippingservice                 ClusterIP   10.101.186.24    <none>        50051/TCP      5m6s
shoppingassistantservice        ClusterIP   10.110.239.249   <none>        8080/TCP       5m6s
Deployment Details <a name="deployment-details"></a>
bash
kubectl get deployments -n dev
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
ad-deployment                   2/2     2            2           5m7s
cartapp-deploy                  2/2     2            2           5m7s
checkoutapp-deploy              1/1     1            1           5m7s
currencyapp-deploy              1/1     1            1           5m7s
emailapp-deploy                 1/1     1            1           5m7s
frontend-deploy                 1/1     1            1           5m7s
payment-deploy                  1/1     1            1           5m7s
postgres                        1/1     1            1           5m7s
productcatalog-deploy           1/1     1            1           5m6s
recommendation-deploy           1/1     1            1           5m6s
redis                           1/1     1            1           5m6s
shipping-deploy                 1/1     1            1           5m6s
shoppingassistant-deploy        0/1     1            0           5m6s

kubectl get replicasets -n dev
NAME                                       DESIRED   CURRENT   READY   AGE
ad-deployment-75c848cc9d                   2         2         2       5m7s
cartapp-deploy-5898bc458f                  2         2         2       5m7s
checkoutapp-deploy-644cf955f5              1         1         1       5m7s
currencyapp-deploy-658974dc4f              1         1         1       5m7s
emailapp-deploy-7dbf445774                 1         1         1       5m7s
frontend-deploy-5db47c9fb8                 1         1         1       5m7s
payment-deploy-6c988c48c6                  1         1         1       5m7s
postgres-65fff7c46b                        1         1         1       5m6s
productcatalog-deploy-55cdd64f4            1         1         1       5m6s
recommendation-deploy-fbcf9d95             1         1         1       5m6s
redis-7f799dfdfd                           1         1         1       5m6s
shipping-deploy-58cf9d6b56                 1         1         1       5m5s
shoppingassistant-deploy-7b754f7f66        1         1         0       5m5s
Storage Configuration <a name="storage-configuration"></a>
bash
kubectl get storageclass
NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  26d

kubectl get pvc -n dev
NAME                                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
my-prometheus-server                   Bound    pvc-34fa4080-aca0-4805-ab3a-c9c8fcc4ebcd   8Gi        RWO            standard       3h36m
storage-my-prometheus-alertmanager-0   Bound    pvc-904441b1-b063-4bb5-b7e4-9d1b01b1e594   2Gi        RWO            standard       3h36m
Auto-Scaling Configuration <a name="auto-scaling-configuration"></a>
bash
kubectl get horizontalpodautoscaler -n dev
NAME             REFERENCE                   TARGETS                        MINPODS   MAXPODS   REPLICAS   AGE
adservice-hpa    Deployment/ad-deployment    cpu: 2%/70%, memory: 51%/75%   2         5         2          4m54s
cartapp-hpa      Deployment/cartapp-deploy   cpu: 2%/60%, memory: 45%/60%   2         7         2          4m54s
7. Monitoring Stack <a name="monitoring-stack"></a>
Production-grade monitoring implemented with Prometheus and Grafana:

bash
# Install Prometheus
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring

# Install Grafana
helm install grafana grafana/grafana \
  --namespace monitoring 
Monitoring Features:

Real-time Service Metrics: Latency, error rates, request volumes

Resource Utilization: CPU/Memory usage per service and pod

Kubernetes Cluster Health: Node status, pod distribution, resource allocation

Business KPIs: Orders per minute, conversion rates, cart abandonment

Custom Alerting: SLA violations, error spikes, resource exhaustion

Distributed Tracing: End-to-end transaction visibility across services
 Production-Grade Features <a name="production-grade-features"></a>
Resilience Mechanisms <a name="resilience-mechanisms"></a>
Pod Disruption Budgets (PDB):

Network Policies

Liveness and Readiness Probes:

Security Controls <a name="security-controls"></a>
RBAC Configuration

Secrets Management

Pod Security Policies

9. Future Improvements Roadmap <a name="future-improvements-roadmap"></a>
KEDA Implementation <a name="keda-implementation"></a>

graph LR
A[Redis Queue Depth] --> B[KEDA Scaler]
B --> C[Kubernetes HPA]
C --> D[cartservice Pods]

GitOps with Argo CD <a name="gitops-with-argo-cd"></a>

YugabyteDB Distributed SQL <a name="yugabytedb-distributed-sql"></a>

Open Policy Agent (OPA) <a name="open-policy-agent-opa"></a>

Service Mesh Integration <a name="service-mesh-integration"></a>
Istio Implementation

# Clone repository
git clone https://github.com/yakmatic-dev/microservices-k8s.git
cd microservices-k8s

# Create namespace
kubectl create namespace dev

# Apply Kubernetes manifests
kubectl apply -f k8s-manifests/ -n dev

# Verify deployment
kubectl get all -n dev

# Access application
kubectl port-forward svc/frontend-service 8080:80 -n dev

# Open in browser
http://localhost:8080

# Access Grafana dashboard
kubectl port-forward svc/grafana 3000:3000 -n monitoring
http://localhost:3000 (admin/securepassword)

11. Support <a name="support"></a>
Project Maintainer: Yakub Iliyas
Email: yakubiliyas12@gmail.com
Repository: github.com/yakmatic-dev/microservices-k8s
