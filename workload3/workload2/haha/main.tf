

provider "google" {
  project = "methodical-bee-198709"
  region  = "us-central1"
}

module "vpc" {
  source      = "airasia/vpc_network/google"
  version     = "2.14.0"
  name_suffix = "whatever"
  ip_ranges = {
    private_primary    = "10.20.0.0/16"
    private_k8s        = [{ pods_rname = "", pods_cidr = "10.21.0.0/16", svcs_rname = "", svcs_cidr = "10.22.0.0/16" }]
    private_redis      = ["10.23.0.0/29"]
    private_g_services = "10.24.0.0/16"
    proxy_only         = ""
    serverless_access  = ["10.26.0.0/28"]
  }
}

module "dhurbal" {
  source                 = "./terraform-google-gke_cluster"
  name_suffix            = "whatever"
  pods_ip_range_name     = module.vpc.ip_range_names_private_k8s_pods.0
  services_ip_range_name = module.vpc.ip_range_names_private_k8s_services.0
  vpc_network            = module.vpc.network
  vpc_subnetwork         = module.vpc.private_subnet
}
/*
 module.vpc.ip_range_names_private_k8s_pods.0
  services_ip_range_name     = module.vpc.ip_range_names_private_k8s_services.0


*/
