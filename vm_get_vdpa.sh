#=======================================================================
#时间：2023.10.16
#作者：bigw
#随便写的
#=======================================================================

vm_name=$1

pod_name=`kubectl get pod |grep "$vm_name" |awk '{print $1}'`

vm_vpda=`kubectl logs $pod_name -c hook-sidecar-0 |grep "vhost-vdpa" |head -n 1  |awk '{print $8}'`
vm_vdpa_num=`kubectl logs $pod_name -c hook-sidecar-0 |grep "vhost-vdpa" |head -n 1  |awk '{print $8}' | sed 's/[^0-9]*\([0-9]\+\).*/\1/'`

vm_node=`kubectl get pod -o wide |grep "$vm_name" |awk '{print $7}'`
vm_ovs_name=`kubectl get pod -n diylink-ovn-system -o wide |grep $vm_node |awk '{print $1}'`

echo "======================================================================="
echo "                              VDPA设备"
echo "======================================================================="
kubectl logs $pod_name -c hook-sidecar-0 |grep "vhost-vdpa" |head -n 1  |awk '{print $8}'
echo "======================================================================="
echo "                             OVS端口状态"
echo "======================================================================="
kubectl exec -n diylink-ovn-system $vm_ovs_name  -- ovs-vsctl list interface eth$vm_vdpa_num
