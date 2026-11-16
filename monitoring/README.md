# DevOps Infrastructure Monitoring Lab

## Project Overview

This lab monitors the Ubuntu server and Docker containers using Prometheus, Grafana, cAdvisor, and Node Exporter.

## Monitoring Components

- Prometheus: collects and stores metrics.
- Grafana: displays monitoring dashboards.
- cAdvisor: collects Docker container metrics.
- Node Exporter: collects Linux server metrics.

## Prometheus Targets

Prometheus collects metrics every 15 seconds from:

- prometheus:9090
- node-exporter:9100
- cadvisor:8080

## Service Ports

| Service | Port |
|---|---:|
| Grafana | 3000 |
| Prometheus | 9090 |
| cAdvisor | 8084 |
| Node Exporter | 9100 |

All services bind to localhost by default.

## Installation and Setup

1. Navigate into the monitoring directory:

   ```bash
   cd monitoring
   ```

2. Create your private environment file:

   ```bash
   cp .env.example .env
   ```

3. Set your Grafana password:

   ```bash
   nano .env
   ```

4. Start the monitoring services:

   ```bash
   docker compose up -d
   ```

5. Check that the services are running:

   ```bash
   docker compose ps
   ```

## Accessing the Services

- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090
- Prometheus Targets: http://localhost:9090/targets
- cAdvisor: http://localhost:8084
- Node Exporter: http://localhost:9100/metrics

## Useful Prometheus Queries

Available server memory:

```promql
node_memory_MemAvailable_bytes
```

Container memory:

```promql
container_memory_working_set_bytes
```

Container CPU:

```promql
rate(container_cpu_usage_seconds_total[5m])
```

## Security

- Never commit the private `.env` file.
- Use a strong Grafana admin password.
- Keep monitoring ports bound to localhost unless secure remote access is configured.
- Never commit passwords or access tokens.

## Evidence Collected

The project submission includes screenshots of:

1. Grafana dashboard with seven panels.
2. Prometheus targets.
3. cAdvisor container metrics.
4. Node Exporter memory metrics.
5. Grafana Prometheus data source connection.
6. Docker Compose monitoring services.
