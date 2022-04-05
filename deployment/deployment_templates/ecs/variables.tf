variable "cluster_map" {
  type = map(object({
    cluster_name = string
    containerInsights = string
    capacity_providers = list(string)
  }))
}