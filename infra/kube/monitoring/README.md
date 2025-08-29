# overview
Monitoring with Prometheus, visualization with Grafana, alerting with alertmanager.

This uses mailhog for SMTP testing

mailhog testing

    curl --mail-from alerts@liquid.local \
         --mail-rcpt admin@liquid.local \
         --url smtp://localhost:1025 \
         -T /tmp/message.txt

For Production alerts, we're using [Brevo]()

