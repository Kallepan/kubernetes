#!/bin/bash

set -e

export KUBECONFIG="${HOME}/Dev/SIT/kubeconfig-eph.yaml"
# export KUBECONFIG="${HOME}/.kube/config"
export SECRET_FILE="$(pwd)/.s3_secret"

export BACKUP="velero-system-daily-20250331130026"

### MINIKUBE ONLY ###
# # Start minikube
# if ! minikube status &> /dev/null; then
#     minikube start --driver=docker
# fi

# # Enable CSI drivers
# minikube addons disable storage-provisioner
# minikube addons disable default-storageclass
# minikube addons enable volumesnapshots
# minikube addons enable csi-hostpath-driver
### MINIKUBE ONLY ###

velero install --provider aws \
    --bucket veritas-poc-backup-data \
    --prefix velero-backup \
    --secret-file $SECRET_FILE \
    --features=EnableCSI \
    --use-volume-snapshots=true \
    --default-snapshot-move-data=true \
    --use-node-agent \
    --backup-location-config region=eu-central-1,s3ForcePathStyle="true",s3Url=https://object.storage.eu01.onstackit.cloud \
    --snapshot-location-config region=eu-central-1,s3ForcePathStyle="true",s3Url=https://object.storage.eu01.onstackit.cloud \
    --plugins velero/velero-plugin-for-aws:v1.10.0

### MINIKUBE ONLY ###
# kubectl apply -f sc-mapping.yaml
# kubectl label VolumeSnapshotClass csi-hostpath-snapclass \
#     velero.io/csi-volumesnapshot-class=true \
#     --overwrite
### MINIKUBE ONLY ###

echo "Now run the following commands to test the installation: "
echo "velero backup get"
echo "velero restore create --from-backup ${BACKUP} --wait --write-sparse-files"