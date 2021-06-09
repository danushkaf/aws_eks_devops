### Setup Charts (This will needs to be run at infrastructure creation only)
Infrastructure chart is created for the one time deployments of kubernetes components. You may need to provide following parameters as well when deploying this chart.

```
helm install --name <deployment_name> <source_location>/helm_charts/infrastructure --set clusterName=<EKS Cluster Name>,region=<EKS region>,vpcID=<ID of the EKS VPC>,hostedZone=<hosted zone domain name>,xrayImage=<Image name of xray>
```
### Deployment (Deployment should be per tenant)
Everything that should go in to a tenant is in the charts in the deployment folder. By just running commands below, everything can be deployed to a tenant.

Each micro service is created as a separate chart so individual deployment is enabled.

```
helm install --name <deployment_name> <source_location>/helm_charts/deployment/product-service --set namespace=<tenant_name> --namespace=<tenant_name>


```

After installing common deployment to apply network policies You can run the script as below. You will need to provide tenant name as a parameter to this script.
```
.<source_location>/helm_charts/deploy_network_policies.sh <tenant_name>
```

Deployment to each tenant with different parameter values through helm --set command will enable to deploy using the same chart with different values.

For example to create a deployment with different memory for mambuaccountservice following command can be used.
```
helm install --name <deployment_name> <source_location>/helm_charts/deployment/product-service --set namespace=<tenant_name>,deployments.resources.limits.memory=1024Mi --namespace=<tenant_name>
```
### Monitoring
Grafana and Prometheus override configs are provided under the location <source_location>/helm_charts/monitoring. Install Prometheus and Grafana using commands below.

```
helm install --name prometheus --namespace prometheus -f <source_location>/helm_charts/monitoring/prometheus.yaml stable/prometheus
helm install --name grafana --namespace grafana -f <source_location>/helm_charts/monitoring/grafana.yaml stable/grafana
```
Findout the Grafana admin password by executing below.
```
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
### Adding a new Micro Service Chart

Helm is used for deployment of the microservices. All the helm charts will be added here and developer who develops the microservice need to create the new chart for his/her microservice and should send a PR. Ops team will review and merge it to the repo and it will be used by the CICD pipeline there after.

# Prerequisites
You will need to setup helm in your machine locally or use a common VM with helm setup. Please refer to Helm official site ```https://helm.sh/``` for additional details. If you are using a common VM then you can develop the chart locally and copy it over to the VM and test it.

# Steps
To add a new microservice to deployment, you need to create a new helm chart and add templates for deployment, service, config maps and secrets. And also if this service needs to be exposed to the outside world you will need to add an entry to ingress in common chart. This section will go through the steps needed to follow to add a new microservice to a chart.

All the helm charts that deploys microservices are placed inside the ```<source_location>/helm_charts/deployment``` directory. In this section all the commands will need to execute from this location.

First take a copy of another chart like product-service (please don't use common chart here since its not a chart for microservice deployment.). 

```
cp product-service newchart
```

Now Do a string replace within the chart for the name of the chart. Here since I copied product-service chart I need to replace the string "product-service" with "newchart". But if you copied from another chart then you need to replace the name of the original chart by the new chart name.

Next step would be to do changes related to microservice. First lets go to values.yaml and do the changes there.

1. Change the deployment name at ```deployments.name``` and ```deployments.labels.app```. Make sure both values are the same.
2. Change the value of ```deployments.labels.selectorApp```.
3. Change image details at ```deployments.image.repository``` and ```deployments.image.tag```
4. Change values of ```deployments.resources``` section to provide resource limitations to the microservice.
5. Change value of ```deployments.healthCheckPath``` and ```services.context``` to match context of the microservice.
6. Change value of service name at ```services.name```.
7. Change value of config map name and secret name at ```deployments.configMap.name``` and ```deployments.secrets.name```.
8. Then you need change content of the config maps and secrets section under ```deployments.configMap``` and ```deployments.secrets```. Here you need to remove what’s there and add your application properties and secrets to these sections.

Now try to deploy your chart using command below.
```
helm install newapp newchart
```

If you want to expose your service endpoints to outside world, then you will need to add entries to ingress controller. To do that you will need to edit the existing helm chart common. You will need to add service details and endpoint details you need to expose in the ```values.yaml``` to expose your endpoints. Please make sure to expose the swagger use all endpoints that are previously used in the ingress configuration.

Now update the existing ingress deployment using command below. If you are not sure, you should get help from dev ops team on this matter.
```
helm upgrade <name_of_the_ingress_deployment> common --set <variables_to_override>
```

If everything works fine send a PR with the change.

### Accessing kubernetes dashboard
**Prerequisites**

You will need to setup kubectl in your machine before accessing the kubernetes dashboard.

**Steps**

*  First open a proxy by running command below.

`kubectl proxy`

*  Now run the command below to extract the token to login.

`kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')`

* You should get an output as below.

```
Name:         eks-admin-token-b5zv4
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=eks-admin
              kubernetes.io/service-account.uid=bcfe66ac-39be-11e8-97e8-026dce96b6e8

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      <authentication_token>
```

*  Now open up the browser and access the link below.

`http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/`


*  Use the *<authentication_token>* extracted from above to login.
