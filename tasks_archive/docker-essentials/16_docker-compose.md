# Docker Compose
In this task we will install a minimal Prometheus stack via docker-compose

## Inspect all files
Inspect all files of this task

## Start the stack
```
docker-compose up -d

# Verify all containers are running
docker ps
```

## Grafana
Use Webpreview to access the Grafana Dashboard. Remember to use the correct port (see docker-compose.yml)
User: admin Password: admin

### Add Datasource
We need to add Prometheus as datasource. The URL of prometheus is: `http://prometheus:9090`

### Import Dashboard
Next we need to import a dashboard to visualize our data.
Use Dashboard with ID **193**.
Inspect what you see on the dashboard.

## Cleanup
```
docker-compose down
```