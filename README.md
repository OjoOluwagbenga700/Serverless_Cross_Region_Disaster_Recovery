


<h1>Serverless_Cross_Region_Disaster_Recovery</h1>

<h2>Description</h2>
This project showcases a fully automated, multi-region serverless architecture built on AWS, designed for high availability, fault tolerance, and disaster recovery. Using Terraform, I deployed a resilient web application that automatically fails over between regions using Amazon Route 53 DNS-based health checks.

The application includes a static frontend hosted on Amazon S3, a backend powered by API Gateway and AWS Lambda, and persistent storage with a DynamoDB Global Table for real-time cross-region data replication.
<br />


<h2>Project Architecture</h2>

<p align="center">
<img src="https://i.imgur.com/TjOgjI7.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />


<h2>Key Features: </h2>

- <b>🌐 Static frontend hosted on Amazon S3 and delivered globally</b> 
- <b>🚀 Multi-region API Gateway + Lambda for regional fault tolerance</b> 
- <b>🌍 DynamoDB Global Tables for synchronous data replication</b> 
- <b>🔒 ACM SSL Certificates for secure, custom domain support</b> 
- <b>📊 CloudWatch Logs + Route 53 Health Checks for monitoring</b> 
- <b>⚙️ Fully automated with Terraform (modular, reusable IaC)</b> 


<h2>Tools & Technologies::</h2>

- <b> AWS Services: S3, Lambda, API Gateway, Route 53, DynamoDB, ACM, CloudWatch</b> 
- <b> Infrastructure as Code: Terraform</b> 
- <b> Testing & Debugging: curl, Postman, AWS CLI</b>

  
<h2>How it Works::</h2>

- <b> Users access the frontend hosted on S3 via a custom domain</b> 
- <b> API calls are routed to the primary region's API Gateway + Lambda</b> 
- <b> DynamoDB Global Tables replicate data to the secondary region</b>
- <b> if the primary region fails, Route 53 automatically reroutes traffic to the secondary region</b>


