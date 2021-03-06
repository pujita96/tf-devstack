

sudo openstack tripleo container image prepare  -e ~/containers-prepare-parameter.yaml -e ~/rhsm.yaml > ~/overcloud_containers.yaml

echo 'sudo openstack overcloud container image upload --config-file ~/overcloud_containers.yaml'
sudo openstack overcloud container image upload --config-file ~/overcloud_containers.yaml

registry=${CONTAINER_REGISTRY:-'docker.io/tungstenfabric'}
tag=${CONTRAIL_CONTAINER_TAG:-'latest'}

~/contrail-tripleo-heat-templates/tools/contrail/import_contrail_container.sh \
    -f ~/contrail_containers.yaml -r $registry -t $tag

sed -i ~/contrail_containers.yaml -e "s/192.168.24.1/${prov_ip}/"

#temp hack for vrouter-kernel-init (will be removed when official images are available)
sed -i ~/contrail_containers.yaml -e "s/contrail-vrouter-kernel-init:latest/contrail-vrouter-kernel-init:rhosp16/"

cat ~/contrail_containers.yaml

echo 'sudo openstack overcloud container image upload --config-file ~/contrail_containers.yaml'
sudo openstack overcloud container image upload --config-file ~/contrail_containers.yaml

echo Checking catalog in docker registry
openstack  tripleo container image list
