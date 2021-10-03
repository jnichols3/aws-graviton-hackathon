# aws-graviton-hackathon
Project repo for the AWS Graviton Hackathon: https://awsgraviton.devpost.com/
Our project path in the hackathon is:  https://devpost.com/software/my-project-580myn

## Inspiration

AWS reports that a vast majority of workloads on EC2 today will be migrated to Graviton2 based architectures.  Visibility into these workloads will be key to provide the operational environments these workloads have on i86 architectures, including Splunk monitoring for EC2 and EKS workloads.  Currently, if graviton2 instances are added to an EKS cluster, the nodes are not directly observed with Splunk.

## What it does

The upstream splunk-docker project is updated to build, test and push mutli-arch containers to ECR.  These images are then used in an EKS cluster to monitor a machine learning workload.

## How we built it

Updates the upstream splunk-docker project to add Makefile support to use docker buildx and create mutli-arch containers for the splunk universal forwarder.  An Github action is created to build and push these images to an ECR repository.  The Splunk operator for Kubernetes can then place the forwarder on each node in the cluster, including graviton2 based images.

## Challenges we ran into

Splunk has only made ARM compatible binaries available for the universal forwarder component.  The vast majority of splunk installations in the enterprise environment are just the forwarder.  Graviton2/ARM support is likely coming soon for the indexer and search head components of Splunk and the changes made here can be applied to the other parts of the splunk infrastructure itself, for now we can only tackle the basic observability problem on Graviton2.

The other challenge we encountered is that the upstream splunk-docker project is in the midst of moving from CircleCI based container builds to Github actions, but the work is not yet complete. 

## Accomplishments that we're proud of

At our normal day jobs, we have been converting workloads that run in docker over to Graviton2 and ARM compatible EC2 instances or hybrid x86/arm EKS clusters.  Some projects and workloads have been easy and others have not.  The splunk updates were easy compared to the others.

## What we learned

<a target="_blank" href="https://media.defense.gov/2021/Aug/03/2002820425/-1/-1/1/CTR_KUBERNETES%20HARDENING%20GUIDANCE.PDF">Recent publications by the U.S. NSA and CISA</a> have highlighted a need to tightly secure and control the supply-chain in regards to software components and containers used within Kubernetes environments.  While we would ideally just use an upstream image off of docker hub, the use of Docker hub, CircleCI, and now Github actions add several possible attack surfaces to the supply chain of a critical observability component that is intended to be deployed widely in an environment.   This is why we went for the lowest level update to the container build involved- the Makefile - so that we ourselves or other users of this project can build the container themselves locally or in a sandbox zero-trust build environment their choosing.

## What's next for my project

It is likely that Splunk will release ARM compatible binaries for the other infrastructure components.  The code and changes made here will directly apply and we'll be able to quickly add support for building and running these very large workloads on Graviton2.
