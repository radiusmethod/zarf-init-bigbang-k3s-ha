ARCH:=amd64
# renovate: depName=zarf-dev/zarf
ZARF_VERSION:="0.59.0"
# renovate: depName=go-gitea/gitea
GITEA_VERSION:="1.24.5"
# renovate: depName=distribution/distribution
REGISTRY_VERSION:="3.0.0"

ZARF_DIR:="zarf"
BUILD_DIR:="../../build"
KMS_ALIAS:="zarf-init-bigbang"

.PHONY: lint
lint:
	cd zarf/$(FLAVOR) && \
	zarf dev lint -a $(ARCH) . \
	--set REGISTRY_IMAGE_DOMAIN="registry1.dso.mil/" \
	--set REGISTRY_IMAGE="ironbank/opensource/docker/registry-v2" \
	--set REGISTRY_IMAGE_TAG=$(REGISTRY_VERSION) \
	--set AGENT_IMAGE_DOMAIN="registry1.dso.mil/" \
	--set AGENT_IMAGE="ironbank/opensource/defenseunicorns/zarf/zarf-agent" \
	--set AGENT_IMAGE_TAG=v$(ZARF_VERSION) \
	--set INJECTOR_VERSION="2025-03-24" \
	--set INJECTOR_AMD64_SHASUM="a78d66b9e2b00a22edd9b4e6432a4d934621e3757f09493b12f688c7c9baca93" \
	--set GITEA_IMAGE=registry1.dso.mil/ironbank/opensource/go-gitea/gitea:v$(GITEA_VERSION)

.PHONY: build-full
build-full:
	cd zarf/full && \
	zarf package create -o $(BUILD_DIR) -a $(ARCH) --confirm . \
	--set REGISTRY_IMAGE_DOMAIN="registry1.dso.mil/" \
	--set REGISTRY_IMAGE="ironbank/opensource/docker/registry-v2" \
	--set REGISTRY_IMAGE_TAG=$(REGISTRY_VERSION) \
	--set AGENT_IMAGE_DOMAIN="registry1.dso.mil/" \
	--set AGENT_IMAGE="ironbank/opensource/defenseunicorns/zarf/zarf-agent" \
	--set AGENT_IMAGE_TAG=v$(ZARF_VERSION) \
	--set INJECTOR_VERSION="2025-03-24" \
	--set INJECTOR_AMD64_SHASUM="a78d66b9e2b00a22edd9b4e6432a4d934621e3757f09493b12f688c7c9baca93" \
	--set GITEA_IMAGE=registry1.dso.mil/ironbank/opensource/go-gitea/gitea:v$(GITEA_VERSION) && \
	mv $(BUILD_DIR)/zarf-init-amd64-v$(ZARF_VERSION).tar.zst $(BUILD_DIR)/zarf-init-full-amd64-v$(ZARF_VERSION).tar.zst

.PHONY: build-minimal
build-minimal:
	cd zarf/minimal && \
	zarf package create -o $(BUILD_DIR) -a $(ARCH) --confirm . && \
	mv $(BUILD_DIR)/zarf-init-amd64-v$(ZARF_VERSION).tar.zst $(BUILD_DIR)/zarf-init-minimal-amd64-v$(ZARF_VERSION).tar.zst

.PHONY: generate-key-pair
generate-key-pair:
	cosign generate-key-pair --kms awskms:///alias/$(KMS_ALIAS)
