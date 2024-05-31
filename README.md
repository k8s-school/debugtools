<p align="center"><img alt="kind" src="./logo/logo.png" width="50%" /></p>

# debugtools
Container with debug tools: gdb, ps, nc, ...

## Pre-requisite

Access to a Kubernetes cluster

## Usage

## As a container

```bash
docker run -it --rm --name debugtools --privileged -v /:/media/root --ipc=host --net=host --pid=host k8sschool/debugtools
```

## With a regular container

Use container template provided in [share-process-namespace documentation], and replace the image field value (i.e. `busybox`) with `k8sschool/debugtools:1.0.0`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  shareProcessNamespace: true
  containers:
  - name: nginx
    image: nginx
  - name: shell
    image: k8sschool/debugtools:1.0.0
    securityContext:
      capabilities:
        add:
        - SYS_PTRACE
    stdin: true
    tty: true
```

Then create the pod:

```shell
kubectl apply -f pod.yaml
```

Finally open a shell in the container and start debugging:

```shell
kubectl exec -it nginx -c shell -- bash
# All processes running in the pod are listed below
# thanks to the shareProcessNamespace field
[root@nginx /] ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
65535          1       0  0 12:27 ?        00:00:00 /pause
root           8       0  0 12:27 ?        00:00:00 nginx: master process nginx -g daemon off;
101           38       8  0 12:27 ?        00:00:00 nginx: worker process
...
101           49       8  0 12:27 ?        00:00:00 nginx: worker process
root          50       0  0 12:27 pts/0    00:00:00 /usr/bin/bash
root         237       0  0 12:36 pts/1    00:00:00 bash
```

`debugtools` provides a `gdb` helper which can be used to build `gdb` command line to attach a process

```shell
[root@nginx /] debugtools 8
2021/08/09 12:36:45 Path to executable: /proc/8/root/usr/sbin/nginx
2021/08/09 12:36:45 gdb command-line: gdb -iex "set sysroot /proc/8/root" -iex "set auto-load safe-path /proc/8/root" -p 8 /proc/8/root/usr/sbin/nginx
[root@nginx /]  gdb -iex "set sysroot /proc/8/root" -iex "set auto-load safe-path /proc/8/root" -p 8 /proc/8/root/usr/sbin/nginx
GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-120.el7
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
...
0x00007fbd5dbb1b09 in sigsuspend () from /proc/8/root/lib/x86_64-linux-gnu/libc.so.6
(gdb) bt
\#0  0x00007fbd5dbb1b09 in sigsuspend () from /proc/8/root/lib/x86_64-linux-gnu/libc.so.6
\#1  0x000055f607feab2a in ngx_master_process_cycle ()
\#2  0x000055f607fc1508 in main ()
```



## With an ephemeral container

**Pre-requisite**: Access to a Kubernetes cluster with feature gate `EphemeralContainers` enabled

Can be used with `kubectl debug` command:

```shell
kubectl debug -it <my-pod> --image=k8sschool/debugtools:1.0.0 --target=<my-container>
```

See [kubectl debug documentation] to learn how to fine-tune it.

[kubectl debug documentation]: https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/

[share-process-namespace documentation]: https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/
