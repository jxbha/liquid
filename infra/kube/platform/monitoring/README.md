# Overview
Monitoring with Prometheus, visualization with Grafana, alerting with Alertmanager.

This uses mailhog and curl for basic SMTP testing.

Example:

    curl --mail-from alerts@liquid.local \
         --mail-rcpt admin@liquid.local \
         --url smtp://localhost:1025 \
         -T /tmp/message.txt

For Production alerts, we're using the AlertManagerConfig CRD pointed to [Brevo](https://www.brevo.com). Sendgrid and SMTP2Go were both considered but Brevo has a free tier and accepts new accounts.

