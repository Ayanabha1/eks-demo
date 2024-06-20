docker_build("web-server-1", "./web-server-1")
k8s_resource("s1-deployment", port_forwards=[8001])

docker_build("web-server-2", "./web-server-2")
k8s_resource("s2-deployment", port_forwards=[8002])

k8s_yaml("web-server-1/local-deployment.yml")
k8s_yaml("web-server-2/local-deployment.yml")
k8s_yaml("web-server-1/local-service.yml")
k8s_yaml("web-server-2/local-service.yml")
k8s_yaml("local-ingress.yml")

watch_file('web-server-1')
watch_file('web-server-2')
