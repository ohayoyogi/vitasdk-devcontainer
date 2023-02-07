# vitasdk-devcontainer

DevContainer for vitasdk. You can use this image on aarch64 (ARM64) machine, also.

## How to build

```bash
git clone https://github.com/ohayoyogi/vitasdk-devcontainer
cd vitasdk-devcontainer
docker build -t vitasdk-devcontainer .
```

## Usage

In `.devcontainer/devcontainer.json`, you can specify this image like this.

```json
{
  "name": "VitaSDK DevContainer",
  "image": "vitasdk-devcontainer",
  "remoteUser": "ubuntu"
}
```

enjoy.
