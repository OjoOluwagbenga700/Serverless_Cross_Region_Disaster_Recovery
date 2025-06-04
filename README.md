


<h1>Serverless_Cross_Region_Disaster_Recovery</h1>

<h2>Description</h2>
This project showcases a fully automated, multi-region serverless architecture built on AWS, designed for high availability, fault tolerance, and disaster recovery. Using Terraform, I deployed a resilient web application that automatically fails over between regions using Amazon Route 53 DNS-based health checks.

The application includes a static frontend hosted on Amazon S3, a backend powered by API Gateway and AWS Lambda, and persistent storage with a DynamoDB Global Table for real-time cross-region data replication.
<br />


<h2>Project Architecture</h2>

<p align="center">
<img src="https://i.imgur.com/TjOgjI7.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />

| Component         | Primary Region                | Secondary Region              | Purpose/Notes                                   |
|-------------------|------------------------------|-------------------------------|-------------------------------------------------|
| **Frontend**      | S3 Static Website Hosting    | S3 Static Website Hosting     | SPA/Static site, optionally via CloudFront      |
| **API Gateway**   | `primary-api.domain.com`      | `secondary-api.domain.com`    | HTTP API with Lambda integration                |
| **Lambda**        | `read_function`, `write_function` | `read_function`, `write_function` | Handles API logic, deployed in both regions     |
| **DynamoDB**      | Global Table                  | Replica Table                 | Synchronous cross-region data replication       |
| **Route 53**      | Failover DNS: `api.domain.com`| Health checks on both regions | Automatic failover for high availability        |
| **ACM**           | Regional SSL Certificates     | Regional SSL Certificates     | Secure custom domains                           |
| **Monitoring**    | CloudWatch, Route 53 Health Checks | CloudWatch, Route 53 Health Checks | End-to-end observability and alerting      |
| **IaC**           | Terraform                     | Terraform                     | All infrastructure deployed end-to-end          |

<h2>Tools & Technologies::</h2>

- <b> AWS Services: S3, Lambda, API Gateway, Route 53, DynamoDB, ACM, CloudWatch</b> 
- <b> Infrastructure as Code: Terraform</b> 
- <b> Testing & Debugging: curl, Postman, AWS CLI</b>

  
<h2>How it Works::</h2>

- <b> Users access the frontend hosted on S3 via a custom domain</b> 
- <b> API calls are routed to the primary region's API Gateway + Lambda</b> 
- <b> DynamoDB Global Tables replicate data to the secondary region</b>
- <b> if the primary region fails, Route 53 automatically reroutes traffic to the secondary region</b>

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- AWS CLI configured with credentials for both regions
- Registered domain name

### Deployment Steps

1. **Clone the repository**
    ```sh
    git clone <repo-url>
    cd Serverless_Cross_Region_Disaster_Recovery/Infra
    ```

2. **Set up Terraform variables**
    - Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values (domain name, regions, etc).

3. **Initialize Terraform**
    ```sh
    terraform init
    ```

4. **Plan and Apply**
    ```sh
    terraform plan
    terraform apply
    ```

5. **Verify Deployment**
    - Visit your S3 static website endpoint.
    - Test API endpoints:
        - `https://api.<your-domain>/read`
        - `https://primary-api.<your-domain>/read`
        - `https://secondary-api.<your-domain>/read`
    - Check Route 53 health checks and failover.

---

## Project Structure

```
Infra/
  modules/
    apigateway/
    dynamodb/
    iam/
    lambda/
    route53/
    acm/
  src/
    read_function.py
    write_function.py
  main.tf
  variables.tf
  outputs.tf
  terraform.tfvars
```

---

## Monitoring & Alerts

- **API Gateway**: CloudWatch logs and metrics enabled.
- **Lambda**: CloudWatch logs and error metrics.
- **DynamoDB**: CloudWatch metrics for replication and throttling.
- **Route 53**: Health checks with SNS notification support (optional).

---

## Failover Testing

To test failover:
1. Disable or break the primary API Gateway endpoint (e.g., remove mapping or Lambda integration).
2. Wait for Route 53 health check to detect failure.
3. Access `https://api.<your-domain>/read` and confirm it routes to the secondary region.

---

## Cleanup

To destroy all resources:
```sh
terraform destroy
```

---

## License

MIT License

---

## Credits

Built by Gbenga Ojo-Samuel 
---
