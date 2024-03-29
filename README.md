## Directory Structure of the tests

```bash
Taen__DevOps-Engineer-Test
├── .github/
│ └── workflows
├── Test 1: Multi-Language Microservice Deployment:
│ ├── go-service
│ ├── node-service
│ └── python-service
└── Test2:
├── app
└── IAC
```

### Test 1: Multi-Language Microservice Deployment:

**Execute this command to spin up the microservices:**

```bash
docker-compose up
```

Each service's `localhost:PORT` route sends greeting messages.

**_Here is the list of directories with service documentation:_**

**1.1 node-service:**

This service runs on port `3000`.
Primarily accepts POST requests on the `localhost:3000/sort` route and requires the data payload like the shape below for giving a successful response:

```json
{ "data": [1, 5, 3, 4, 2] } // Request payload
```

After successfully forwarding requests to **python-service** and **go-service** the service returns response like the below:

```json
{
  "status": "logged" // Response
}
```

**1.2 python-service:**

This service runs on port `4000`.
Primarily accepts POST requests on `localhost:4000/sort` with unsorted data and returns sorted data as a response.

**1.3 go-service:**

This service runs on port `6000`.
Primarily accepts POST request on `localhost:6000/log` with both unsorted and sorted data and log like below:

```bash
2023/12/28 22:16:11 Received: [1 5 3 4 2], Sorted: [1 2 3 4 5], Time: 2023-12-28 22:16:11.360173303 +0000 UTC m=+4.723929545
```

This service finally returns a JSON response we get when we call the **node-service**.

### Test2:

**2.1 app:** The basic web application is written in Python with a basic unit test.
The application runs on the `3000` port.

**To install application dependencies:**

```bash
pip3 install -r requirements.txt
```

**To run unit tests:**

```bash
python3 -m unittest test_app.py
```

**To run the application:**

```bash
python3 app.py
```

**2.2 IaC:**
This directory contains the terraform files to spin up the infrastructure.

**To spin up the infrastructure:**

```bash
terraform apply
```

**Terraform output:**

```bash
taen_eip = "52.220.123.143"
```

**2.3 .github/workflows/**
This directory contains the CICD pipeline to test and deploy the basic Python app to EC2.

**To run the CICD workflow successfully we've to set some secrets in GitHub like:**

```bash
  SSH_PRIVATE_KEY: <THE_PRIVATE_KEY_OF_THE_PUBLIC_KEY_THAT_WE_ADDED_AS_A_KEY_PAIR_IN_EC2>

  REMOTE_HOST: <taen_eip_OUTPUT_FROM_TERRAFORM>

  REMOTE_USER: ubuntu
```

**Visit your application on live**

```bash
<REMOTE_HOST:3000>
```

You will get a response called `Hello World!`

`Chears!`
