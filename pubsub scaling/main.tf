resource "google_pubsub_topic" "echo" {
  name = "echo"
}

resource "google_pubsub_subscription" "echo" {
  name  = "echo-read"
  topic = "${google_pubsub_topic.echo.name}"

  ack_deadline_seconds = 20
}

provider "google" {
  project = "methodical-bee-198709"
}
# kubectl get --raw '/apis/external.metrics.k8s.io/v1beta1/namespaces/pubsub/pubsub.googleapis.com|subscription|num_undelivered_messages'

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/namespaces/pubsub/pubsub.googleapis.com|subscription|num_undelivered_messages" 