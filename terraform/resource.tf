resource "helm_release" "lb-test" {
  name             = "lb-test"
  chart            = "./helm"
  namespace        = "uharov"
  create_namespace = "true"
  values = [
    "${file("./helm/nginx.yaml")}"
  ]
}
