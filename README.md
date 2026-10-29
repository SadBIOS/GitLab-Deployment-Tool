# GitLab Self-Hosting Script for Air-Gapped Deployment

The following script is designed for deploying GitLab EE (should also work for CE but it has not been tested) through my personal staging tool and the official omnibus package into Debian<sup>®</sup> Linux systems.

# Operation/Deployment

> [!CAUTION]
> * 4 cores and 8GB of RAM recommended for 1 Admin + 1 Active user
> * 8 cores and 16GB of RAM recommended for 1 Admin + 10 Active users
> * Storage is dependent on project size but 40GB is a good baseline
> * It is also a good idea to host this deployment a Type-1 Hypervisor rather than bare-metal

> [!NOTE]
> Every reference of `Node A` will mean the online/staging machine and `Node B` will be the offline/airgapped deployment machine.

## Staging on `Node A`

After cloning/extracting the source code make the shell scripts executable with the following command.

```bash
chmod +x -v *.sh
```

Start the staging process (it will fetch all dependencies and the Gitlab omnibus package)

```bash
./setup.sh --build-offline-archive
```

Compress/package once everything has been cached to the root directory of the script.

## Deployment on `Node B`

After extracting the archive and making the scripts executable again just run the following and select options accordingly. 

```bash
./setup.sh --deploy
```

Once everything has completed carefully note down the first time login credentials and IP address.

> [!CAUTION]
> TLS is **NOT** set up by default as it is depends on end users PKI

---

> [!IMPORTANT]  
> Tested and built on the following OS builds
> * Debian<sup>®</sup> 13.7 *"Trixie"*, Kernel **6.12.113+deb13-amd64**