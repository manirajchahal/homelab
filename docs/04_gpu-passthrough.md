# GPU passthrough: RTX 4070 into an unprivileged LXC

Jellyfin in CT 100 uses the RTX 4070 for hardware transcoding. The GPU is
**shared** into the container (device nodes), not passed through via VFIO, so
the host keeps the driver.

## The problem

- The driver is installed with NVIDIA's `.run` installer + DKMS. Its device
  nodes are not devtmpfs nodes: `nvidia-modprobe` creates them on demand, and
  nothing did that at boot.
- `nvidia-uvm` gets a **dynamic major number**. On the first real reboot it
  moved 508 to 511 (and `nvidia-caps` 511 to 236). The old hardcoded
  `lxc.cgroup2.devices.allow: c 508:* rwm` lines would have broken
  transcoding.
- Jellyfin uses CDI (`devices: nvidia.com/gpu=all`), and the CDI spec pins the
  device paths and majors too.

## The fix, in three layers

1. **Host**: [`nvidia.conf`](../pve1/host/etc/modules-load.d/nvidia.conf)
   loads `nvidia` + `nvidia_uvm`, and
   [`nvidia-devnodes.service`](../pve1/host/etc/systemd/system/nvidia-devnodes.service)
   runs `nvidia-modprobe -c 0 -u` *before* `pve-guests`, then `nvidia-smi -L`
   so a broken driver shows up in `systemctl --failed`.
2. **Container config**: PVE `devN:` entries instead of hand-written cgroup
   rules. PVE resolves major:minor at every start:
   ```
   dev0: /dev/nvidia0,mode=0666
   dev1: /dev/nvidiactl,mode=0666
   dev2: /dev/nvidia-uvm,mode=0666
   dev3: /dev/nvidia-uvm-tools,mode=0666
   ```
   `mode=0666` matters: the default is root-only 0660, and Jellyfin runs as
   uid 1000.
3. **Inside CT 100**: a oneshot unit runs `nvidia-ctk cdi generate` before
   Docker starts, rebuilding the CDI spec from the live nodes. The toolkit's
   own refresh unit never fires in an LXC because its condition checks
   `/lib/modules`, which doesn't exist there.

## Kernel upgrades

`proxmox-default-headers` is installed, so new kernels bring matching headers
and DKMS rebuilds the module. Rule: after `apt upgrade`, confirm
`dkms status` lists the new kernel **before** rebooting. With `devN:` entries,
CT 100 refuses to start if the nodes are missing.

## When the GPU disappears

After a new NVMe was installed under the GPU, the card dropped off the PCIe bus
and CT 100 refused to start ("Device /dev/nvidia-uvm does not exist"). A
running AM4 system never re-trains the GPU's root port, so reseating needs a
**cold power cycle**. Emergency start without the GPU:

```sh
pct set 100 --delete dev0,dev1,dev2,dev3 && pct start 100
```

## Test

Inside the Jellyfin container:

```sh
ffmpeg -f lavfi -i testsrc=duration=2:size=1280x720:rate=30 -pix_fmt yuv420p -c:v h264_nvenc /tmp/t.mp4
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i /tmp/t.mp4 -c:v h264_nvenc -f null -
```

Keep `-pix_fmt yuv420p`. Without it NVENC writes 4:4:4, which NVDEC can't
decode, a false alarm.
