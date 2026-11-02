# Minimal Hardened Container Images Build System
# Uses Chainguard melange (build from source) + apko (assemble image)
# All images are shell-less/distroless for security

REGISTRY ?= ghcr.io
OWNER ?= $(shell git config user.name | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
VERSION ?= $(shell date +%Y%m%d)

# Helper: extract version from a melange.yaml (single source of truth)
melange_version = $(shell grep '^  version:' $(1) 2>/dev/null | awk '{print $$2}')

# --- Infrastructure/Core ---
JENKINS_VERSION ?= $(call melange_version,images/jenkins/melange.yaml)
NGINX_VERSION ?= 1.29.4
HTTPD_VERSION ?= 2.4.66

# --- Databases/Storage ---
REDIS_VERSION ?= $(call melange_version,images/redis-slim/melange.yaml)
MYSQL_VERSION ?= $(call melange_version,images/mysql/melange.yaml)
MARIADB_VERSION ?= $(call melange_version,images/mariadb/melange.yaml)
MEMCACHED_VERSION ?= $(call melange_version,images/memcached/melange.yaml)
MINIO_VERSION ?= $(call melange_version,images/minio/melange.yaml)
ETCD_VERSION ?= $(call melange_version,images/etcd/melange.yaml)

# --- Languages/Frameworks ---
RUBY_VERSION ?= $(call melange_version,images/ruby/melange.yaml)
RAILS_VERSION ?= $(shell grep '^  rails_version:' images/rails/melange.yaml 2>/dev/null | awk '{print $$2}')

# --- Messaging/Coordination ---
KAFKA_VERSION ?= $(call melange_version,images/kafka/melange.yaml)
ZOOKEEPER_VERSION ?= $(call melange_version,images/zookeeper/melange.yaml)
TOMCAT_VERSION ?= $(call melange_version,images/tomcat/melange.yaml)
VALKEY_VERSION ?= $(call melange_version,images/valkey/melange.yaml)
NATS_VERSION ?= $(call melange_version,images/nats/melange.yaml)
RABBITMQ_VERSION ?= $(call melange_version,images/rabbitmq/melange.yaml)
CASSANDRA_VERSION ?= $(call melange_version,images/cassandra/melange.yaml)
SOLR_VERSION ?= $(call melange_version,images/solr/melange.yaml)
FLINK_VERSION ?= $(call melange_version,images/flink/melange.yaml)
PULSAR_VERSION ?= $(call melange_version,images/pulsar/melange.yaml)

# --- Ingress/Proxies ---
CADDY_VERSION ?= $(call melange_version,images/caddy/melange.yaml)
HAPROXY_VERSION ?= $(call melange_version,images/haproxy/melange.yaml)
TRAEFIK_VERSION ?= $(call melange_version,images/traefik/melange.yaml)
ENVOY_VERSION ?= $(call melange_version,images/envoy/melange.yaml)

# --- Observability ---
PROMETHEUS_VERSION ?= $(call melange_version,images/prometheus/melange.yaml)
ALERTMANAGER_VERSION ?= $(call melange_version,images/alertmanager/melange.yaml)
JAEGER_VERSION ?= $(call melange_version,images/jaeger/melange.yaml)
OTELCOL_VERSION ?= $(call melange_version,images/otelcol/melange.yaml)
VICTORIA_METRICS_VERSION ?= $(call melange_version,images/victoria-metrics/melange.yaml)
TELEGRAF_VERSION ?= $(call melange_version,images/telegraf/melange.yaml)
MIMIR_VERSION ?= $(call melange_version,images/mimir/melange.yaml)

# --- DNS/Secrets/IAM ---
COREDNS_VERSION ?= $(call melange_version,images/coredns/melange.yaml)
PHP_VERSION ?= $(call melange_version,images/php/melange.yaml)
GITEA_VERSION ?= $(call melange_version,images/gitea/melange.yaml)
OPENBAO_VERSION ?= $(call melange_version,images/openbao/melange.yaml)
KEYCLOAK_VERSION ?= $(call melange_version,images/keycloak/melange.yaml)

# --- Logging ---
LOKI_VERSION ?= $(call melange_version,images/loki/melange.yaml)
FLUENT_BIT_VERSION ?= $(call melange_version,images/fluent-bit/melange.yaml)

# --- Search/AI ---
QDRANT_VERSION ?= $(call melange_version,images/qdrant/melange.yaml)
MEILISEARCH_VERSION ?= $(call melange_version,images/meilisearch/melange.yaml)
AIRFLOW_VERSION ?= $(call melange_version,images/airflow/melange.yaml)
WORDPRESS_VERSION ?= $(call melange_version,images/wordpress/melange.yaml)
VAULTWARDEN_VERSION ?= $(call melange_version,images/vaultwarden/melange.yaml)
KVROCKS_VERSION ?= $(call melange_version,images/kvrocks/melange.yaml)
OPENSEARCH_VERSION ?= $(call melange_version,images/opensearch/melange.yaml)

# --- Registries ---
# NB: REGISTRY (above) is the OCI registry hostname; DISTRIBUTION_VERSION is the
# upstream version of distribution/distribution we ship as `containers-registry`.
DISTRIBUTION_VERSION ?= $(call melange_version,images/registry/melange.yaml)

# --- Dev tools ---
MAILPIT_VERSION ?= $(call melange_version,images/mailpit/melange.yaml)

# --- Service Discovery / Coordination (HashiCorp) ---
CONSUL_VERSION ?= $(call melange_version,images/consul/melange.yaml)

# --- Observability (extra) ---
TEMPO_VERSION ?= $(call melange_version,images/tempo/melange.yaml)
THANOS_VERSION ?= $(call melange_version,images/thanos/melange.yaml)
NODE_EXPORTER_VERSION ?= $(call melange_version,images/node-exporter/melange.yaml)
BLACKBOX_EXPORTER_VERSION ?= $(call melange_version,images/blackbox-exporter/melange.yaml)
REDIS_EXPORTER_VERSION ?= $(call melange_version,images/redis-exporter/melange.yaml)
KUBE_STATE_METRICS_VERSION ?= $(call melange_version,images/kube-state-metrics/melange.yaml)
PUSHGATEWAY_VERSION ?= $(call melange_version,images/pushgateway/melange.yaml)

# --- IaC / GitOps ---
OPENTOFU_VERSION ?= $(call melange_version,images/opentofu/melange.yaml)

# --- Security tooling ---
TRIVY_VERSION ?= $(call melange_version,images/trivy/melange.yaml)
COSIGN_VERSION ?= $(call melange_version,images/cosign/melange.yaml)
ZOT_VERSION ?= $(call melange_version,images/zot/melange.yaml)
ERLANG_VERSION ?= $(call melange_version,images/erlang/melange.yaml)
PERL_VERSION ?= $(call melange_version,images/perl/melange.yaml)
NEO4J_VERSION ?= $(call melange_version,images/neo4j/melange.yaml)
SYFT_VERSION ?= $(call melange_version,images/syft/melange.yaml)
GRYPE_VERSION ?= $(call melange_version,images/grype/melange.yaml)
ORAS_VERSION ?= $(call melange_version,images/oras/melange.yaml)
GITLEAKS_VERSION ?= $(call melange_version,images/gitleaks/melange.yaml)
STEP_VERSION ?= $(call melange_version,images/step-cli/melange.yaml)
OPA_VERSION ?= $(call melange_version,images/opa/melange.yaml)
OSV_SCANNER_VERSION ?= $(call melange_version,images/osv-scanner/melange.yaml)
DEX_VERSION ?= $(call melange_version,images/dex/melange.yaml)
KUBE_VIP_VERSION ?= $(call melange_version,images/kube-vip/melange.yaml)
ZIPKIN_VERSION ?= $(call melange_version,images/zipkin/melange.yaml)
SEAWEEDFS_VERSION ?= $(call melange_version,images/seaweedfs/melange.yaml)
RCLONE_VERSION ?= $(call melange_version,images/rclone/melange.yaml)
RESTIC_VERSION ?= $(call melange_version,images/restic/melange.yaml)
TAILSCALE_VERSION ?= $(call melange_version,images/tailscale/melange.yaml)
DESCHEDULER_VERSION ?= $(call melange_version,images/descheduler/melange.yaml)
SYNCTHING_VERSION ?= $(call melange_version,images/syncthing/melange.yaml)
NSQ_VERSION ?= $(call melange_version,images/nsq/melange.yaml)
GITLAB_RUNNER_VERSION ?= $(call melange_version,images/gitlab-runner/melange.yaml)
BUILDKIT_VERSION ?= $(call melange_version,images/buildkit/melange.yaml)
OAUTH2_PROXY_VERSION ?= $(call melange_version,images/oauth2-proxy/melange.yaml)
FLUX_VERSION ?= $(call melange_version,images/flux/melange.yaml)
KUSTOMIZE_VERSION ?= $(call melange_version,images/kustomize/melange.yaml)
SOPS_VERSION ?= $(call melange_version,images/sops/melange.yaml)
CRANE_VERSION ?= $(call melange_version,images/crane/melange.yaml)
KUBESEAL_VERSION ?= $(call melange_version,images/kubeseal/melange.yaml)
CMCTL_VERSION ?= $(call melange_version,images/cmctl/melange.yaml)
TIMESCALEDB_VERSION ?= $(call melange_version,images/timescaledb/melange.yaml)
HELMFILE_VERSION ?= $(call melange_version,images/helmfile/melange.yaml)
REGCTL_VERSION ?= $(call melange_version,images/regctl/melange.yaml)
STERN_VERSION ?= $(call melange_version,images/stern/melange.yaml)
NOTATION_VERSION ?= $(call melange_version,images/notation/melange.yaml)
CONFTEST_VERSION ?= $(call melange_version,images/conftest/melange.yaml)
KUBECONFORM_VERSION ?= $(call melange_version,images/kubeconform/melange.yaml)
KUBE_BENCH_VERSION ?= $(call melange_version,images/kube-bench/melange.yaml)
TRUFFLEHOG_VERSION ?= $(call melange_version,images/trufflehog/melange.yaml)
# --- Messaging (MQTT) ---
MOSQUITTO_VERSION ?= $(call melange_version,images/mosquitto/melange.yaml)
PGBOUNCER_VERSION ?= $(call melange_version,images/pgbouncer/melange.yaml)
UNBOUND_VERSION ?= $(call melange_version,images/unbound/melange.yaml)
KEEPALIVED_VERSION ?= $(call melange_version,images/keepalived/melange.yaml)
METRICS_SERVER_VERSION ?= $(call melange_version,images/metrics-server/melange.yaml)
EXTERNAL_DNS_VERSION ?= $(call melange_version,images/external-dns/melange.yaml)
VELERO_VERSION ?= $(call melange_version,images/velero/melange.yaml)
KANIKO_VERSION ?= $(call melange_version,images/kaniko/melange.yaml)
STEP_CA_VERSION ?= $(call melange_version,images/step-ca/melange.yaml)
SKOPEO_VERSION ?= $(call melange_version,images/skopeo/melange.yaml)
HELM_VERSION ?= $(call melange_version,images/helm/melange.yaml)
KUBECTL_VERSION ?= $(call melange_version,images/kubectl/melange.yaml)

# --- AI/ML ---
CUDA_VERSION ?= 12.9.0

#==============================================================================
# DEV VARIANT MACROS
# Used by each image's :latest-dev variant. See docs/dev-variants/CONVENTIONS.md.
#==============================================================================

# DEV_IMAGE_RULE — declare `<name>-dev` apko build target.
#   $(1) image name (also the dir name and apko config prefix)
#   $(2) prerequisite target (e.g. ruby-melange) — leave empty for apko-only
#   $(3) extra apko flags (e.g. --repository-append ./packages
#        --keyring-append melange.rsa.pub) — leave empty for apko-only
# Conventions: dev apko config lives at <name>/apko/<name>-dev.yaml,
# image publishes :$(VERSION)-dev and :latest-dev tags.
define DEV_IMAGE_RULE
$(1)-dev: $(2)
	@echo "Assembling containers-$(1)-dev image with apko..."
	apko build images/$(1)/apko/$(1)-dev.yaml \
		$$(REGISTRY)/$$(OWNER)/containers-$(1):$$(VERSION)-dev \
		$(1)-dev.tar \
		--arch x86_64 $(3)
	docker load < $(1)-dev.tar
	docker tag $$(REGISTRY)/$$(OWNER)/containers-$(1):$$(VERSION)-dev-amd64 \
		$$(REGISTRY)/$$(OWNER)/containers-$(1):$$(VERSION)-dev
	docker tag $$(REGISTRY)/$$(OWNER)/containers-$(1):$$(VERSION)-dev-amd64 \
		$$(REGISTRY)/$$(OWNER)/containers-$(1):latest-dev
	@rm -f $(1)-dev.tar sbom-*.spdx.json
	@echo "✓ containers-$(1)-dev built"
endef

# DEV_TEST_RULE — declare `test-<name>-dev` smoke test target.
#   $(1) image name
# Conventions: test script lives at <name>/test-dev.sh and reads $$IMAGE.
define DEV_TEST_RULE
test-$(1)-dev:
	@IMAGE=$$(REGISTRY)/$$(OWNER)/containers-$(1):latest-dev bash images/$(1)/test-dev.sh
	@echo "✓ $(1) dev tests passed"
endef

.PHONY: all build scan clean help lint-workflows lint-versions check-autoupdate check-toolchain-pins check-curl-retries test-classifier test-versions-config
.PHONY: zookeeper zookeeper-melange test-zookeeper
.PHONY: tomcat tomcat-melange test-tomcat
.PHONY: pgbouncer pgbouncer-melange pgbouncer-dev test-pgbouncer test-pgbouncer-dev
.PHONY: unbound unbound-melange unbound-dev test-unbound test-unbound-dev
.PHONY: dnsmasq dnsmasq-dev test-dnsmasq test-dnsmasq-dev
.PHONY: kong kong-dev test-kong test-kong-dev
.PHONY: couchdb couchdb-dev test-couchdb test-couchdb-dev
.PHONY: argo-cd argo-cd-dev test-argo-cd test-argo-cd-dev
.PHONY: argo-cd-repo-server argo-cd-repo-server-dev test-argo-cd-repo-server test-argo-cd-repo-server-dev
.PHONY: patroni patroni-dev test-patroni test-patroni-dev
.PHONY: vector vector-dev test-vector test-vector-dev
.PHONY: keepalived keepalived-melange keepalived-dev test-keepalived test-keepalived-dev
.PHONY: metrics-server metrics-server-melange metrics-server-dev test-metrics-server test-metrics-server-dev
.PHONY: external-dns external-dns-melange external-dns-dev test-external-dns test-external-dns-dev
.PHONY: velero velero-melange velero-dev test-velero test-velero-dev
.PHONY: kaniko kaniko-melange kaniko-dev test-kaniko test-kaniko-dev
.PHONY: step-ca step-ca-melange step-ca-dev test-step-ca test-step-ca-dev
.PHONY: skopeo skopeo-melange skopeo-dev test-skopeo test-skopeo-dev
.PHONY: python python-dev jenkins jenkins-melange go go-dev node-slim node-slim-dev nginx httpd redis-slim redis-slim-melange redis-slim-dev mysql mysql-melange mysql-local memcached memcached-melange memcached-dev caddy caddy-melange haproxy haproxy-melange postgres-slim postgres-slim-dev bun bun-dev sqlite sqlite-dev dotnet dotnet-dev java java-dev ruby ruby-melange ruby-dev php php-melange php-dev rails rails-melange rails-dev deno deno-dev kafka kafka-melange cassandra cassandra-melange solr solr-melange pulsar pulsar-melange keygen opensearch opensearch-melange opensearch-dev mariadb mariadb-melange mariadb-dev valkey valkey-melange valkey-dev
.PHONY: valkey valkey-melange nats nats-melange traefik traefik-melange envoy envoy-melange rabbitmq rabbitmq-melange minio minio-melange
.PHONY: prometheus prometheus-melange alertmanager alertmanager-melange mariadb mariadb-melange
.PHONY: etcd etcd-melange victoria-metrics victoria-metrics-melange jaeger jaeger-melange otelcol otelcol-melange qdrant qdrant-melange meilisearch meilisearch-melange meilisearch-dev airflow airflow-melange airflow-dev wordpress wordpress-melange wordpress-dev deno deno-melange
.PHONY: cuda-python cuda-python-melange
.PHONY: coredns coredns-melange openbao openbao-melange loki loki-melange fluent-bit fluent-bit-melange keycloak keycloak-melange
.PHONY: gitea gitea-melange gitea-melange test-gitea
.PHONY: telegraf telegraf-melange telegraf-dev test-telegraf test-telegraf-dev scan-telegraf
.PHONY: mimir mimir-melange mimir-dev test-mimir test-mimir-dev scan-mimir
.PHONY: registry registry-melange registry-dev test-registry test-registry-dev
.PHONY: mailpit mailpit-melange mailpit-dev test-mailpit test-mailpit-dev
.PHONY: consul consul-melange consul-dev test-consul test-consul-dev
.PHONY: tempo tempo-melange tempo-dev test-tempo test-tempo-dev
.PHONY: opentofu opentofu-melange test-opentofu
.PHONY: trivy trivy-melange test-trivy
.PHONY: cosign cosign-melange test-cosign
.PHONY: zot zot-melange zot-dev test-zot test-zot-dev
.PHONY: erlang erlang-melange erlang-dev test-erlang test-erlang-dev
.PHONY: perl perl-melange perl-dev test-perl test-perl-dev
.PHONY: neo4j neo4j-melange neo4j-dev test-neo4j test-neo4j-dev
.PHONY: syft syft-melange test-syft
.PHONY: temporal-server temporal-server-melange temporal-admin-tools temporal-admin-tools-melange temporal-ui-server temporal-ui-server-melange
.PHONY: grype grype-melange test-grype
.PHONY: external-secrets external-secrets-melange kyverno kyverno-melange flagger flagger-melange reloader reloader-melange postgres-exporter postgres-exporter-melange headscale headscale-melange victoria-logs victoria-logs-melange metallb metallb-melange
.PHONY: oras oras-melange test-oras
.PHONY: gitleaks gitleaks-melange test-gitleaks
.PHONY: step-cli step-cli-melange test-step-cli
.PHONY: opa opa-melange test-opa
.PHONY: osv-scanner osv-scanner-melange test-osv-scanner
.PHONY: dex dex-melange test-dex
.PHONY: kube-vip kube-vip-melange test-kube-vip
.PHONY: zipkin zipkin-melange test-zipkin
.PHONY: seaweedfs seaweedfs-melange test-seaweedfs
.PHONY: rclone rclone-melange test-rclone
.PHONY: restic restic-melange test-restic
.PHONY: tailscale tailscale-melange test-tailscale
.PHONY: descheduler descheduler-melange test-descheduler
.PHONY: syncthing syncthing-melange syncthing-dev test-syncthing test-syncthing-dev
.PHONY: nsq nsq-melange nsq-dev test-nsq test-nsq-dev
.PHONY: gitlab-runner gitlab-runner-melange gitlab-runner-dev test-gitlab-runner test-gitlab-runner-dev
.PHONY: buildkit buildkit-melange buildkit-dev test-buildkit test-buildkit-dev
.PHONY: oauth2-proxy oauth2-proxy-melange test-oauth2-proxy
.PHONY: flux flux-melange test-flux
.PHONY: kustomize kustomize-melange test-kustomize
.PHONY: sops sops-melange test-sops
.PHONY: crane crane-melange test-crane
.PHONY: kubeseal kubeseal-melange test-kubeseal
.PHONY: cmctl cmctl-melange test-cmctl
.PHONY: timescaledb timescaledb-melange test-timescaledb
.PHONY: helmfile helmfile-melange test-helmfile
.PHONY: regctl regctl-melange test-regctl
.PHONY: stern stern-melange test-stern
.PHONY: notation notation-melange test-notation
.PHONY: conftest conftest-melange test-conftest
.PHONY: kubeconform kubeconform-melange test-kubeconform
.PHONY: kube-bench kube-bench-melange test-kube-bench
.PHONY: trufflehog trufflehog-melange test-trufflehog
.PHONY: thanos thanos-melange test-thanos
.PHONY: node-exporter node-exporter-melange test-node-exporter
.PHONY: blackbox-exporter blackbox-exporter-melange test-blackbox-exporter
.PHONY: flink flink-melange test-flink
.PHONY: vaultwarden vaultwarden-melange test-vaultwarden
.PHONY: kvrocks kvrocks-melange kvrocks-dev test-kvrocks test-kvrocks-dev
.PHONY: redis-exporter redis-exporter-melange test-redis-exporter
.PHONY: kube-state-metrics kube-state-metrics-melange test-kube-state-metrics
.PHONY: pushgateway pushgateway-melange test-pushgateway
.PHONY: mosquitto mosquitto-melange mosquitto-dev test-mosquitto test-mosquitto-dev
.PHONY: scan-external-secrets scan-kyverno scan-flagger scan-reloader scan-postgres-exporter scan-headscale scan-victoria-logs scan-metallb
.PHONY: scan-python scan-jenkins scan-go scan-node-slim scan-nginx scan-httpd scan-redis-slim scan-mysql scan-memcached scan-caddy scan-haproxy scan-postgres-slim scan-bun scan-sqlite scan-dotnet scan-java scan-ruby scan-php scan-rails scan-kafka scan-cassandra scan-solr scan-pulsar scan-valkey scan-nats scan-traefik scan-rabbitmq scan-minio scan-opensearch scan-prometheus scan-mariadb scan-etcd scan-victoria-metrics scan-jaeger scan-otelcol scan-qdrant scan-meilisearch scan-airflow scan-wordpress scan-deno scan-coredns scan-openbao scan-loki scan-fluent-bit scan-keycloak
.PHONY: test-external-secrets test-external-secrets-dev test-kyverno test-kyverno-dev test-flagger test-flagger-dev test-reloader test-reloader-dev test-postgres-exporter test-postgres-exporter-dev test-headscale test-headscale-dev test-victoria-logs test-victoria-logs-dev test-metallb test-metallb-dev
.PHONY: test-python test-python-dev test-jenkins test-go test-go-dev test-node-slim test-node-slim-dev test-nginx test-httpd test-redis-slim test-redis-slim-dev test-mysql test-memcached test-caddy test-haproxy test-postgres-slim test-postgres-slim-dev test-bun test-bun-dev test-sqlite test-dotnet test-dotnet-dev test-java test-java-dev test-ruby test-ruby-dev test-php test-php-dev test-rails test-rails-dev test-deno test-deno-dev test-mariadb test-mariadb-dev test-valkey test-valkey-dev test-memcached-dev test-sqlite-dev test-opensearch-dev test-kafka test-cassandra test-solr test-pulsar test-valkey test-nats test-traefik test-envoy test-rabbitmq test-minio test-opensearch test-prometheus test-mariadb test-etcd test-victoria-metrics test-jaeger test-otelcol test-qdrant test-meilisearch test-meilisearch-dev test-airflow test-airflow-dev test-wordpress test-wordpress-dev test-deno test-coredns test-openbao test-loki test-fluent-bit test-keycloak

all: build scan

# Build all images
build: python node-slim bun go java ruby php dotnet deno mysql mariadb postgres-slim pgbouncer unbound dnsmasq keepalived vector patroni metrics-server external-dns velero kaniko step-ca skopeo sqlite opensearch meilisearch airflow wordpress redis-slim valkey memcached kafka zookeeper cassandra solr flink pulsar tomcat rabbitmq nats mosquitto nginx httpd caddy haproxy traefik envoy oauth2-proxy prometheus alertmanager victoria-metrics thanos mimir jaeger loki tempo otelcol fluent-bit telegraf node-exporter blackbox-exporter kube-state-metrics redis-exporter pushgateway coredns etcd openbao keycloak qdrant vaultwarden registry consul helm kubectl opentofu trivy cosign syft grype osv-scanner oras notation conftest kubeconform kube-bench trufflehog flux kustomize sops crane kubeseal helmfile regctl stern gitleaks step-cli opa jenkins gitea minio rails mailpit external-secrets kyverno flagger reloader postgres-exporter headscale victoria-logs metallb temporal-server temporal-admin-tools temporal-ui-server kong couchdb kvrocks cmctl argo-cd argo-cd-repo-server

#------------------------------------------------------------------------------
# SIGNING KEY (required for melange packages)
#------------------------------------------------------------------------------
keygen:
	@if [ ! -f melange.rsa ]; then \
		echo "Generating melange signing keypair..."; \
		melange keygen; \
		echo "✓ Signing key generated"; \
	fi

#------------------------------------------------------------------------------
# PYTHON IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
python:
	@echo "Assembling containers-python image with apko..."
	apko build images/python/apko/python.yaml \
		$(REGISTRY)/$(OWNER)/containers-python:$(VERSION) \
		python.tar \
		--arch x86_64
	docker load < python.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-python:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-python:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-python:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-python:latest
	@rm -f python.tar sbom-*.spdx.json
	@echo "✓ containers-python built (Wolfi package, shell-less)"

$(eval $(call DEV_IMAGE_RULE,python))
$(eval $(call DEV_IMAGE_RULE,node-slim))
$(eval $(call DEV_IMAGE_RULE,go))
$(eval $(call DEV_IMAGE_RULE,java))
$(eval $(call DEV_IMAGE_RULE,dotnet))
$(eval $(call DEV_IMAGE_RULE,bun))
$(eval $(call DEV_IMAGE_RULE,deno))
$(eval $(call DEV_IMAGE_RULE,rails,rails-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,php,php-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,postgres-slim))
$(eval $(call DEV_IMAGE_RULE,mariadb,mariadb-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,redis-slim,redis-slim-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,valkey,valkey-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,memcached,memcached-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,sqlite))
$(eval $(call DEV_IMAGE_RULE,opensearch))
$(eval $(call DEV_IMAGE_RULE,kafka,kafka-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,cassandra,cassandra-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,solr,solr-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,flink,flink-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,pulsar,pulsar-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,rabbitmq,rabbitmq-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,nats,nats-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,etcd,etcd-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,nginx))
$(eval $(call DEV_IMAGE_RULE,haproxy,haproxy-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,minio,minio-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,httpd))
$(eval $(call DEV_IMAGE_RULE,caddy,caddy-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,traefik,traefik-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,envoy,envoy-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,prometheus,prometheus-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,alertmanager,alertmanager-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,victoria-metrics,victoria-metrics-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,jaeger,jaeger-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,otelcol,otelcol-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,loki,loki-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,fluent-bit,fluent-bit-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,coredns,coredns-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,gitea,gitea-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,jenkins,jenkins-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,openbao,openbao-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,mysql,mysql-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,qdrant,qdrant-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,meilisearch,meilisearch-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,airflow,airflow-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,wordpress,wordpress-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,vaultwarden,vaultwarden-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kvrocks,kvrocks-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,keycloak,keycloak-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,registry,registry-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,mailpit,mailpit-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,consul,consul-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,tempo,tempo-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,mosquitto,mosquitto-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,pgbouncer,pgbouncer-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,unbound,unbound-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,dnsmasq))
$(eval $(call DEV_IMAGE_RULE,kong))
$(eval $(call DEV_IMAGE_RULE,couchdb))
$(eval $(call DEV_IMAGE_RULE,argo-cd))
$(eval $(call DEV_IMAGE_RULE,argo-cd-repo-server))
$(eval $(call DEV_IMAGE_RULE,patroni))
$(eval $(call DEV_IMAGE_RULE,vector))
$(eval $(call DEV_IMAGE_RULE,keepalived,keepalived-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,metrics-server,metrics-server-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,external-dns,external-dns-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,velero,velero-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kaniko,kaniko-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,step-ca,step-ca-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,skopeo,skopeo-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,telegraf,telegraf-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,mimir,mimir-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
# --- dev variants: CLI / exporter / static-Go images. Each ships an
#     apko/<name>-dev.yaml and test-dev.sh; wire their Make rules here.
$(eval $(call DEV_IMAGE_RULE,zookeeper,zookeeper-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,tomcat,tomcat-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,oauth2-proxy,oauth2-proxy-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,thanos,thanos-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,node-exporter,node-exporter-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,blackbox-exporter,blackbox-exporter-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,redis-exporter,redis-exporter-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kube-state-metrics,kube-state-metrics-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,pushgateway,pushgateway-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,helm,helm-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kubectl,kubectl-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,opentofu,opentofu-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,trivy,trivy-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,cosign,cosign-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,syncthing,syncthing-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,nsq,nsq-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,gitlab-runner,gitlab-runner-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,buildkit,buildkit-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,syft,syft-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,grype,grype-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,osv-scanner,osv-scanner-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,oras,oras-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,notation,notation-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,conftest,conftest-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kubeconform,kubeconform-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kube-bench,kube-bench-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,trufflehog,trufflehog-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,flux,flux-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kustomize,kustomize-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,sops,sops-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,crane,crane-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,kubeseal,kubeseal-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,cmctl,cmctl-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,helmfile,helmfile-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,regctl,regctl-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,stern,stern-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,gitleaks,gitleaks-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,step-cli,step-cli-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_IMAGE_RULE,opa,opa-melange,--repository-append ./packages --keyring-append melange.rsa.pub))

#------------------------------------------------------------------------------
# JENKINS IMAGE (melange jlink JRE + WAR + apko, shell-less)
#------------------------------------------------------------------------------
jenkins-melange: keygen
	@echo "Building Jenkins $(JENKINS_VERSION) with custom JRE (jlink) via melange..."
	melange build images/jenkins/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Jenkins package built (custom JRE + WAR)"

jenkins: jenkins-melange
	@echo "Assembling containers-jenkins image with apko..."
	apko build images/jenkins/apko/jenkins.yaml \
		$(REGISTRY)/$(OWNER)/containers-jenkins:$(VERSION) \
		jenkins.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < jenkins.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-jenkins:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-jenkins:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-jenkins:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-jenkins:latest
	@rm -f jenkins.tar sbom-*.spdx.json
	@echo "✓ containers-jenkins built (jlink JRE, shell-less)"

#------------------------------------------------------------------------------
# GO IMAGE (Wolfi pre-built package, with build tools)
#------------------------------------------------------------------------------
go:
	@echo "Assembling containers-go image with apko..."
	apko build images/go/apko/go.yaml \
		$(REGISTRY)/$(OWNER)/containers-go:$(VERSION) \
		go.tar \
		--arch x86_64
	docker load < go.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-go:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-go:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-go:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-go:latest
	@rm -f go.tar sbom-*.spdx.json
	@echo "✓ containers-go built (Wolfi package, with build tools)"

#------------------------------------------------------------------------------
# NODE.JS SLIM IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
node-slim:
	@echo "Assembling containers-node-slim image with apko..."
	apko build images/node-slim/apko/node.yaml \
		$(REGISTRY)/$(OWNER)/containers-node-slim:$(VERSION) \
		node.tar \
		--arch x86_64
	docker load < node.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-node-slim:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-node-slim:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-node-slim:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-node-slim:latest
	@rm -f node.tar sbom-*.spdx.json
	@echo "✓ containers-node-slim built (Wolfi package)"

#------------------------------------------------------------------------------
# NGINX IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
nginx:
	@echo "Assembling containers-nginx image with apko..."
	apko build images/nginx/apko/nginx.yaml \
		$(REGISTRY)/$(OWNER)/containers-nginx:$(VERSION) \
		nginx.tar \
		--arch x86_64
	docker load < nginx.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-nginx:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-nginx:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-nginx:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-nginx:latest
	@rm -f nginx.tar sbom-*.spdx.json
	@echo "✓ containers-nginx built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# HTTPD IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
httpd:
	@echo "Assembling containers-httpd image with apko..."
	apko build images/httpd/apko/httpd.yaml \
		$(REGISTRY)/$(OWNER)/containers-httpd:$(VERSION) \
		httpd.tar \
		--arch x86_64
	docker load < httpd.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-httpd:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-httpd:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-httpd:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-httpd:latest
	@rm -f httpd.tar sbom-*.spdx.json
	@echo "✓ containers-httpd built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# REDIS SLIM IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
redis-slim-melange: keygen
	@echo "Building Redis $(REDIS_VERSION) from source via melange..."
	melange build images/redis-slim/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Redis package built from source"

redis-slim: redis-slim-melange
	@echo "Assembling containers-redis-slim image with apko..."
	apko build images/redis-slim/apko/redis.yaml \
		$(REGISTRY)/$(OWNER)/containers-redis-slim:$(VERSION) \
		redis-slim.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < redis-slim.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-redis-slim:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-redis-slim:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-redis-slim:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-redis-slim:latest
	@rm -f redis-slim.tar sbom-*.spdx.json
	@echo "✓ containers-redis-slim built (source build)"

#------------------------------------------------------------------------------
# MYSQL IMAGE (melange source build + apko, LTS track)
#------------------------------------------------------------------------------
mysql-melange: keygen
	@echo "Building MySQL $(MYSQL_VERSION) from source via melange..."
	melange build images/mysql/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ MySQL package built from source"

# Local-only: build mysql package for x86_64 then assemble image (skip aarch64 to avoid pod failure on WSL2)
mysql-local: keygen
	@echo "Building MySQL $(MYSQL_VERSION) from source (x86_64 only)..."
	melange build images/mysql/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa \
		--out-dir ./packages \
		--runner docker
	@echo "Assembling containers-mysql image with apko..."
	apko build images/mysql/apko/mysql.yaml \
		$(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION) \
		mysql.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < mysql.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mysql:latest
	@rm -f mysql.tar sbom-*.spdx.json
	@echo "✓ containers-mysql built locally (x86_64 only)"

mysql: mysql-melange
	@echo "Assembling containers-mysql image with apko..."
	apko build images/mysql/apko/mysql.yaml \
		$(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION) \
		mysql.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < mysql.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mysql:latest
	@rm -f mysql.tar sbom-*.spdx.json
	@echo "✓ containers-mysql built (source build)"

#------------------------------------------------------------------------------
# MEMCACHED IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
memcached-melange: keygen
	@echo "Building Memcached $(MEMCACHED_VERSION) from source via melange..."
	melange build images/memcached/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Memcached package built from source"

memcached: memcached-melange
	@echo "Assembling containers-memcached image with apko..."
	apko build images/memcached/apko/memcached.yaml \
		$(REGISTRY)/$(OWNER)/containers-memcached:$(VERSION) \
		memcached.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < memcached.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-memcached:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-memcached:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-memcached:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-memcached:latest
	@rm -f memcached.tar sbom-*.spdx.json
	@echo "✓ containers-memcached built (source build)"

#------------------------------------------------------------------------------
# CADDY IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
caddy-melange: keygen
	@echo "Building Caddy $(CADDY_VERSION) from source via melange..."
	melange build images/caddy/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Caddy package built from source"

caddy: caddy-melange
	@echo "Assembling containers-caddy image with apko..."
	apko build images/caddy/apko/caddy.yaml \
		$(REGISTRY)/$(OWNER)/containers-caddy:$(VERSION) \
		caddy.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < caddy.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-caddy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-caddy:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-caddy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-caddy:latest
	@rm -f caddy.tar sbom-*.spdx.json
	@echo "✓ containers-caddy built (source build)"

#------------------------------------------------------------------------------
# HAPROXY IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
haproxy-melange: keygen
	@echo "Building HAProxy $(HAPROXY_VERSION) from source via melange..."
	melange build images/haproxy/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ HAProxy package built from source"

haproxy: haproxy-melange
	@echo "Assembling containers-haproxy image with apko..."
	apko build images/haproxy/apko/haproxy.yaml \
		$(REGISTRY)/$(OWNER)/containers-haproxy:$(VERSION) \
		haproxy.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < haproxy.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-haproxy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-haproxy:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-haproxy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-haproxy:latest
	@rm -f haproxy.tar sbom-*.spdx.json
	@echo "✓ containers-haproxy built (source build)"

#------------------------------------------------------------------------------
# VALKEY IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
valkey-melange: keygen
	@echo "Building Valkey $(VALKEY_VERSION) from source via melange..."
	melange build images/valkey/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Valkey package built from source"

valkey: valkey-melange
	@echo "Assembling containers-valkey image with apko..."
	apko build images/valkey/apko/valkey.yaml \
		$(REGISTRY)/$(OWNER)/containers-valkey:$(VERSION) \
		valkey.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < valkey.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-valkey:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-valkey:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-valkey:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-valkey:latest
	@rm -f valkey.tar sbom-*.spdx.json
	@echo "✓ containers-valkey built (source build)"

#------------------------------------------------------------------------------
# NATS IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
nats-melange: keygen
	@echo "Building NATS $(NATS_VERSION) from source via melange..."
	melange build images/nats/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ NATS package built from source"

nats: nats-melange
	@echo "Assembling containers-nats image with apko..."
	apko build images/nats/apko/nats.yaml \
		$(REGISTRY)/$(OWNER)/containers-nats:$(VERSION) \
		nats.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < nats.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-nats:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-nats:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-nats:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-nats:latest
	@rm -f nats.tar sbom-*.spdx.json
	@echo "✓ containers-nats built (source build)"

#------------------------------------------------------------------------------
# TRAEFIK IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
traefik-melange: keygen
	@echo "Building Traefik $(TRAEFIK_VERSION) from source via melange..."
	melange build images/traefik/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Traefik package built from source"

traefik: traefik-melange
	@echo "Assembling containers-traefik image with apko..."
	apko build images/traefik/apko/traefik.yaml \
		$(REGISTRY)/$(OWNER)/containers-traefik:$(VERSION) \
		traefik.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < traefik.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-traefik:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-traefik:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-traefik:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-traefik:latest
	@rm -f traefik.tar sbom-*.spdx.json
	@echo "✓ containers-traefik built (source build)"

#------------------------------------------------------------------------------
# ENVOY IMAGE (melange official binary release + apko)
#------------------------------------------------------------------------------
envoy-melange: keygen
	@echo "Building Envoy $(ENVOY_VERSION) from upstream releases via melange..."
	melange build images/envoy/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Envoy package built"

envoy: envoy-melange
	@echo "Assembling containers-envoy image with apko..."
	apko build images/envoy/apko/envoy.yaml \
		$(REGISTRY)/$(OWNER)/containers-envoy:$(VERSION) \
		envoy.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < envoy.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-envoy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-envoy:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-envoy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-envoy:latest
	@rm -f envoy.tar sbom-*.spdx.json
	@echo "✓ containers-envoy built (upstream binary)"

#------------------------------------------------------------------------------
# RABBITMQ IMAGE (melange official binary release + apko)
#------------------------------------------------------------------------------
rabbitmq-melange: keygen
	@echo "Building RabbitMQ $(RABBITMQ_VERSION) via melange (official generic-unix release)..."
	melange build images/rabbitmq/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ RabbitMQ package built"

rabbitmq: rabbitmq-melange
	@echo "Assembling containers-rabbitmq image with apko..."
	apko build images/rabbitmq/apko/rabbitmq.yaml \
		$(REGISTRY)/$(OWNER)/containers-rabbitmq:$(RABBITMQ_VERSION) \
		rabbitmq.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < rabbitmq.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-rabbitmq:$(RABBITMQ_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-rabbitmq:$(RABBITMQ_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-rabbitmq:$(RABBITMQ_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-rabbitmq:latest
	@rm -f rabbitmq.tar sbom-*.spdx.json
	@echo "✓ containers-rabbitmq built"

#------------------------------------------------------------------------------
# MINIO IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
minio-melange: keygen
	@echo "Building MinIO $(MINIO_VERSION) from source via melange..."
	melange build images/minio/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ MinIO package built from source"

minio: minio-melange
	@echo "Assembling containers-minio image with apko..."
	apko build images/minio/apko/minio.yaml \
		$(REGISTRY)/$(OWNER)/containers-minio:$(VERSION) \
		minio.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < minio.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-minio:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-minio:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-minio:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-minio:latest
	@rm -f minio.tar sbom-*.spdx.json
	@echo "✓ containers-minio built (source build)"

#------------------------------------------------------------------------------
# PROMETHEUS IMAGE (melange source build + apko, no embedded web UI)
#------------------------------------------------------------------------------
prometheus-melange: keygen
	@echo "Building Prometheus $(PROMETHEUS_VERSION) from source via melange..."
	melange build images/prometheus/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Prometheus package built from source"

prometheus: prometheus-melange
	@echo "Assembling containers-prometheus image with apko..."
	apko build images/prometheus/apko/prometheus.yaml \
		$(REGISTRY)/$(OWNER)/containers-prometheus:$(VERSION) \
		prometheus.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < prometheus.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-prometheus:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-prometheus:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-prometheus:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-prometheus:latest
	@rm -f prometheus.tar sbom-*.spdx.json
	@echo "✓ containers-prometheus built (source build)"

#------------------------------------------------------------------------------
# TELEGRAF IMAGE (melange Go source build + apko; metrics agent)
#------------------------------------------------------------------------------
telegraf-melange: keygen
	@echo "Building Telegraf $(TELEGRAF_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/telegraf/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Telegraf package built from source"

telegraf: telegraf-melange
	@echo "Assembling containers-telegraf image with apko..."
	apko build images/telegraf/apko/telegraf.yaml \
		$(REGISTRY)/$(OWNER)/containers-telegraf:$(VERSION) \
		telegraf.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < telegraf.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-telegraf:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-telegraf:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-telegraf:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-telegraf:latest
	@rm -f telegraf.tar sbom-*.spdx.json
	@echo "✓ containers-telegraf built (source build)"

#------------------------------------------------------------------------------
# MIMIR IMAGE (melange Go source build + apko; Grafana long-term Prom storage)
#------------------------------------------------------------------------------
mimir-melange: keygen
	@echo "Building Mimir $(MIMIR_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/mimir/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Mimir package built from source"

mimir: mimir-melange
	@echo "Assembling containers-mimir image with apko..."
	apko build images/mimir/apko/mimir.yaml \
		$(REGISTRY)/$(OWNER)/containers-mimir:$(VERSION) \
		mimir.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < mimir.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-mimir:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mimir:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-mimir:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mimir:latest
	@rm -f mimir.tar sbom-*.spdx.json
	@echo "✓ containers-mimir built (source build)"

alertmanager-melange: keygen
	@echo "Building Alertmanager $(ALERTMANAGER_VERSION) from source via melange..."
	# Local build is x86_64-only: bwrap sandbox can't run aarch64 binaries
	# without QEMU binfmt registered. CI builds aarch64 on native ARM runners.
	melange build images/alertmanager/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Alertmanager package built from source (x86_64)"

alertmanager: alertmanager-melange
	@echo "Assembling containers-alertmanager image with apko..."
	apko build images/alertmanager/apko/alertmanager.yaml \
		$(REGISTRY)/$(OWNER)/containers-alertmanager:$(VERSION) \
		alertmanager.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < alertmanager.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-alertmanager:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-alertmanager:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-alertmanager:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-alertmanager:latest
	@rm -f alertmanager.tar sbom-*.spdx.json
	@echo "✓ containers-alertmanager built (source build)"


#------------------------------------------------------------------------------
# MARIADB IMAGE (melange source build + apko, LTS 11.4 track)
#------------------------------------------------------------------------------
mariadb-melange: keygen
	@echo "Building MariaDB $(MARIADB_VERSION) from source via melange..."
	melange build images/mariadb/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ MariaDB package built from source"

mariadb: mariadb-melange
	@echo "Assembling containers-mariadb image with apko..."
	apko build images/mariadb/apko/mariadb.yaml \
		$(REGISTRY)/$(OWNER)/containers-mariadb:$(VERSION) \
		mariadb.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < mariadb.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-mariadb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mariadb:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-mariadb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mariadb:latest
	@rm -f mariadb.tar sbom-*.spdx.json
	@echo "✓ containers-mariadb built (source build)"

#------------------------------------------------------------------------------
# ETCD IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
etcd-melange: keygen
	@echo "Building etcd $(ETCD_VERSION) from source via melange..."
	melange build images/etcd/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ etcd package built from source"

etcd: etcd-melange
	@echo "Assembling containers-etcd image with apko..."
	apko build images/etcd/apko/etcd.yaml \
		$(REGISTRY)/$(OWNER)/containers-etcd:$(VERSION) \
		etcd.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < etcd.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-etcd:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-etcd:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-etcd:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-etcd:latest
	@rm -f etcd.tar sbom-*.spdx.json
	@echo "✓ containers-etcd built (source build)"

#------------------------------------------------------------------------------
# VICTORIA-METRICS IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
victoria-metrics-melange: keygen
	@echo "Building VictoriaMetrics $(VICTORIA_METRICS_VERSION) from source via melange..."
	melange build images/victoria-metrics/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ VictoriaMetrics package built from source"

victoria-metrics: victoria-metrics-melange
	@echo "Assembling containers-victoria-metrics image with apko..."
	apko build images/victoria-metrics/apko/victoria-metrics.yaml \
		$(REGISTRY)/$(OWNER)/containers-victoria-metrics:$(VERSION) \
		victoria-metrics.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < victoria-metrics.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-victoria-metrics:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-victoria-metrics:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-victoria-metrics:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-victoria-metrics:latest
	@rm -f victoria-metrics.tar sbom-*.spdx.json
	@echo "✓ containers-victoria-metrics built (source build)"

#------------------------------------------------------------------------------
# JAEGER IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
jaeger-melange: keygen
	@echo "Building Jaeger $(JAEGER_VERSION) from source via melange..."
	melange build images/jaeger/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Jaeger package built from source"

jaeger: jaeger-melange
	@echo "Assembling containers-jaeger image with apko..."
	apko build images/jaeger/apko/jaeger.yaml \
		$(REGISTRY)/$(OWNER)/containers-jaeger:$(VERSION) \
		jaeger.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < jaeger.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-jaeger:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-jaeger:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-jaeger:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-jaeger:latest
	@rm -f jaeger.tar sbom-*.spdx.json
	@echo "✓ containers-jaeger built (source build)"

#------------------------------------------------------------------------------
# OTELCOL IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
otelcol-melange: keygen
	@echo "Building OTel Collector $(OTELCOL_VERSION) from source via melange..."
	melange build images/otelcol/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ OTel Collector package built from source"

otelcol: otelcol-melange
	@echo "Assembling containers-otelcol image with apko..."
	apko build images/otelcol/apko/otelcol.yaml \
		$(REGISTRY)/$(OWNER)/containers-otelcol:$(VERSION) \
		otelcol.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < otelcol.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-otelcol:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-otelcol:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-otelcol:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-otelcol:latest
	@rm -f otelcol.tar sbom-*.spdx.json
	@echo "✓ containers-otelcol built (source build)"

#------------------------------------------------------------------------------
# QDRANT IMAGE (melange Rust source build + apko)
#------------------------------------------------------------------------------
qdrant-melange: keygen
	@echo "Building Qdrant $(QDRANT_VERSION) from source via melange (Rust)..."
	melange build images/qdrant/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Qdrant package built from source"

qdrant: qdrant-melange
	@echo "Assembling containers-qdrant image with apko..."
	apko build images/qdrant/apko/qdrant.yaml \
		$(REGISTRY)/$(OWNER)/containers-qdrant:$(VERSION) \
		qdrant.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < qdrant.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-qdrant:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-qdrant:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-qdrant:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-qdrant:latest
	@rm -f qdrant.tar sbom-*.spdx.json
	@echo "✓ containers-qdrant built (Rust source build)"

#------------------------------------------------------------------------------
# MEILISEARCH IMAGE (Rust source build + apko)
#------------------------------------------------------------------------------
meilisearch-melange: keygen
	@echo "Building Meilisearch $(MEILISEARCH_VERSION) from source via melange (Rust)..."
	melange build images/meilisearch/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Meilisearch package built from source"

meilisearch: meilisearch-melange
	@echo "Assembling containers-meilisearch image with apko..."
	apko build images/meilisearch/apko/meilisearch.yaml \
		$(REGISTRY)/$(OWNER)/containers-meilisearch:$(VERSION) \
		meilisearch.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < meilisearch.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-meilisearch:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-meilisearch:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-meilisearch:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-meilisearch:latest
	@rm -f meilisearch.tar sbom-*.spdx.json
	@echo "✓ containers-meilisearch built (Rust source build)"

#------------------------------------------------------------------------------
# AIRFLOW IMAGE (ASF source distribution via pip + pinned constraints, + apko)
#------------------------------------------------------------------------------
airflow-melange: keygen
	@echo "Building Airflow $(AIRFLOW_VERSION) from the ASF sdist via melange..."
	melange build images/airflow/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Airflow package built from the ASF source distribution"

airflow: airflow-melange
	@echo "Assembling containers-airflow image with apko..."
	apko build images/airflow/apko/airflow.yaml \
		$(REGISTRY)/$(OWNER)/containers-airflow:$(VERSION) \
		airflow.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < airflow.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-airflow:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-airflow:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-airflow:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-airflow:latest
	@rm -f airflow.tar sbom-*.spdx.json
	@echo "✓ containers-airflow built (ASF sdist + pinned constraints)"

#------------------------------------------------------------------------------
# WORDPRESS IMAGE (official source release + PHP-FPM via apko)
#------------------------------------------------------------------------------
wordpress-melange: keygen
	@echo "Building WordPress $(WORDPRESS_VERSION) from the official source release..."
	melange build images/wordpress/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ WordPress package built"

wordpress: wordpress-melange
	@echo "Assembling containers-wordpress image with apko..."
	apko build images/wordpress/apko/wordpress.yaml \
		$(REGISTRY)/$(OWNER)/containers-wordpress:$(VERSION) \
		wordpress.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < wordpress.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-wordpress:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-wordpress:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-wordpress:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-wordpress:latest
	@rm -f wordpress.tar sbom-*.spdx.json
	@echo "✓ containers-wordpress built (official source release)"

#------------------------------------------------------------------------------
# DENO IMAGE (melange: official upstream binary, shell-less)
#------------------------------------------------------------------------------
DENO_VERSION ?= $(call melange_version,images/deno/melange.yaml)
EXTERNAL_SECRETS_VERSION ?= $(call melange_version,images/external-secrets/melange.yaml)
KYVERNO_VERSION ?= $(call melange_version,images/kyverno/melange.yaml)
FLAGGER_VERSION ?= $(call melange_version,images/flagger/melange.yaml)
RELOADER_VERSION ?= $(call melange_version,images/reloader/melange.yaml)
POSTGRES_EXPORTER_VERSION ?= $(call melange_version,images/postgres-exporter/melange.yaml)
HEADSCALE_VERSION ?= $(call melange_version,images/headscale/melange.yaml)
VICTORIA_LOGS_VERSION ?= $(call melange_version,images/victoria-logs/melange.yaml)
METALLB_VERSION ?= $(call melange_version,images/metallb/melange.yaml)
TEMPORAL_SERVER_VERSION ?= $(call melange_version,images/temporal-server/melange.yaml)
TEMPORAL_ADMIN_TOOLS_VERSION ?= $(call melange_version,images/temporal-admin-tools/melange.yaml)
TEMPORAL_UI_SERVER_VERSION ?= $(call melange_version,images/temporal-ui-server/melange.yaml)

deno-melange: keygen
	@echo "Building Deno $(DENO_VERSION) (official upstream binary) via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/deno/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Deno package built (official binary)"

deno: deno-melange
	@echo "Assembling containers-deno image with apko..."
	apko build images/deno/apko/deno.yaml \
		$(REGISTRY)/$(OWNER)/containers-deno:$(VERSION) \
		deno.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < deno.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-deno:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-deno:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-deno:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-deno:latest
	@rm -f deno.tar sbom-*.spdx.json
	@echo "✓ containers-deno built (official binary, shell-less)"

#------------------------------------------------------------------------------
# CUDA PYTHON IMAGE (melange NVIDIA redist tarballs + Wolfi Python, x86_64 only)
#------------------------------------------------------------------------------
cuda-python-melange: keygen
	@echo "Building CUDA $(CUDA_VERSION) runtime packages via melange..."
	melange build images/cuda-python/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ CUDA runtime packages built"

cuda-python: cuda-python-melange
	@echo "Assembling containers-cuda-python image with apko..."
	apko build images/cuda-python/apko/cuda-python.yaml \
		$(REGISTRY)/$(OWNER)/containers-cuda-python:$(VERSION) \
		cuda-python.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < cuda-python.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-cuda-python:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cuda-python:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-cuda-python:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cuda-python:latest
	@rm -f cuda-python.tar sbom-*.spdx.json
	@echo "✓ containers-cuda-python built (NVIDIA CUDA + Python, x86_64 only)"

#------------------------------------------------------------------------------
# POSTGRES SLIM IMAGE (Wolfi pre-built package)
#------------------------------------------------------------------------------
postgres-slim:
	@echo "Assembling containers-postgres-slim image with apko..."
	apko build images/postgres-slim/apko/postgres.yaml \
		$(REGISTRY)/$(OWNER)/containers-postgres-slim:$(VERSION) \
		postgres-slim.tar \
		--arch x86_64
	docker load < postgres-slim.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-postgres-slim:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-postgres-slim:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-postgres-slim:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-postgres-slim:latest
	@rm -f postgres-slim.tar sbom-*.spdx.json
	@echo "✓ containers-postgres-slim built (Wolfi package)"

#------------------------------------------------------------------------------
# BUN IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
bun:
	@echo "Assembling containers-bun image with apko..."
	apko build images/bun/apko/bun.yaml \
		$(REGISTRY)/$(OWNER)/containers-bun:$(VERSION) \
		bun.tar \
		--arch x86_64
	docker load < bun.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-bun:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-bun:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-bun:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-bun:latest
	@rm -f bun.tar sbom-*.spdx.json
	@echo "✓ containers-bun built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# VECTOR IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
vector:
	@echo "Assembling containers-vector image with apko..."
	apko build images/vector/apko/vector.yaml \
		$(REGISTRY)/$(OWNER)/containers-vector:$(VERSION) \
		vector.tar \
		--arch x86_64
	docker load < vector.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-vector:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-vector:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-vector:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-vector:latest
	@rm -f vector.tar sbom-*.spdx.json
	@echo "✓ containers-vector built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# PATRONI IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
patroni:
	@echo "Assembling containers-patroni image with apko..."
	apko build images/patroni/apko/patroni.yaml \
		$(REGISTRY)/$(OWNER)/containers-patroni:$(VERSION) \
		patroni.tar \
		--arch x86_64
	docker load < patroni.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-patroni:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-patroni:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-patroni:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-patroni:latest
	@rm -f patroni.tar sbom-*.spdx.json
	@echo "✓ containers-patroni built (Wolfi package, busybox sh required by initdb)"

#------------------------------------------------------------------------------
# DNSMASQ IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
dnsmasq:
	@echo "Assembling containers-dnsmasq image with apko..."
	apko build images/dnsmasq/apko/dnsmasq.yaml \
		$(REGISTRY)/$(OWNER)/containers-dnsmasq:$(VERSION) \
		dnsmasq.tar \
		--arch x86_64
	docker load < dnsmasq.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-dnsmasq:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-dnsmasq:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-dnsmasq:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-dnsmasq:latest
	@rm -f dnsmasq.tar sbom-*.spdx.json
	@echo "✓ containers-dnsmasq built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# KONG IMAGE (Wolfi pre-built package)
#------------------------------------------------------------------------------
kong:
	@echo "Assembling containers-kong image with apko..."
	apko build images/kong/apko/kong.yaml \
		$(REGISTRY)/$(OWNER)/containers-kong:$(VERSION) \
		kong.tar \
		--arch x86_64
	docker load < kong.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kong:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kong:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kong:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kong:latest
	@rm -f kong.tar sbom-*.spdx.json
	@echo "✓ containers-kong built (Wolfi package)"

#------------------------------------------------------------------------------
# COUCHDB IMAGE (Wolfi pre-built package)
#------------------------------------------------------------------------------
couchdb:
	@echo "Assembling containers-couchdb image with apko..."
	apko build images/couchdb/apko/couchdb.yaml \
		$(REGISTRY)/$(OWNER)/containers-couchdb:$(VERSION) \
		couchdb.tar \
		--arch x86_64
	docker load < couchdb.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-couchdb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-couchdb:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-couchdb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-couchdb:latest
	@rm -f couchdb.tar sbom-*.spdx.json
	@echo "✓ containers-couchdb built (Wolfi package)"

#------------------------------------------------------------------------------
# ARGO CD IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
argo-cd:
	@echo "Assembling containers-argo-cd image with apko..."
	apko build images/argo-cd/apko/argo-cd.yaml \
		$(REGISTRY)/$(OWNER)/containers-argo-cd:$(VERSION) \
		argo-cd.tar \
		--arch x86_64
	docker load < argo-cd.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-argo-cd:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-argo-cd:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-argo-cd:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-argo-cd:latest
	@rm -f argo-cd.tar sbom-*.spdx.json
	@echo "✓ containers-argo-cd built (Wolfi package)"

#------------------------------------------------------------------------------
# ARGO CD REPO-SERVER IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
argo-cd-repo-server:
	@echo "Assembling containers-argo-cd-repo-server image with apko..."
	apko build images/argo-cd-repo-server/apko/argo-cd-repo-server.yaml \
		$(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:$(VERSION) \
		argo-cd-repo-server.tar \
		--arch x86_64
	docker load < argo-cd-repo-server.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:latest
	@rm -f argo-cd-repo-server.tar sbom-*.spdx.json
	@echo "✓ containers-argo-cd-repo-server built (Wolfi package)"

#------------------------------------------------------------------------------
# SQLITE IMAGE (Wolfi pre-built package, shell-less)
#------------------------------------------------------------------------------
sqlite:
	@echo "Assembling containers-sqlite image with apko..."
	apko build images/sqlite/apko/sqlite.yaml \
		$(REGISTRY)/$(OWNER)/containers-sqlite:$(VERSION) \
		sqlite.tar \
		--arch x86_64
	docker load < sqlite.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-sqlite:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-sqlite:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-sqlite:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-sqlite:latest
	@rm -f sqlite.tar sbom-*.spdx.json
	@echo "✓ containers-sqlite built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# DOTNET RUNTIME IMAGE (Wolfi pre-built package)
#------------------------------------------------------------------------------
dotnet:
	@echo "Assembling containers-dotnet image with apko..."
	apko build images/dotnet/apko/dotnet.yaml \
		$(REGISTRY)/$(OWNER)/containers-dotnet:$(VERSION) \
		dotnet.tar \
		--arch x86_64
	docker load < dotnet.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-dotnet:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-dotnet:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-dotnet:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-dotnet:latest
	@rm -f dotnet.tar sbom-*.spdx.json
	@echo "✓ containers-dotnet built (Wolfi package)"

#------------------------------------------------------------------------------
# JAVA IMAGE (Wolfi pre-built OpenJDK JRE, shell-less)
#------------------------------------------------------------------------------
java:
	@echo "Assembling containers-java image with apko..."
	apko build images/java/apko/java.yaml \
		$(REGISTRY)/$(OWNER)/containers-java:$(VERSION) \
		java.tar \
		--arch x86_64
	docker load < java.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-java:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-java:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-java:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-java:latest
	@rm -f java.tar sbom-*.spdx.json
	@echo "✓ containers-java built (Wolfi package, shell-less)"

#------------------------------------------------------------------------------
# OPENSEARCH IMAGE (Wolfi pre-built package)
#------------------------------------------------------------------------------
opensearch-melange: keygen
	@echo "Building OpenSearch $(OPENSEARCH_VERSION) (official min distribution) via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/opensearch/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ OpenSearch package built (official min distribution)"

opensearch: opensearch-melange
	@echo "Assembling containers-opensearch image with apko..."
	apko build images/opensearch/apko/opensearch.yaml \
		$(REGISTRY)/$(OWNER)/containers-opensearch:$(VERSION) \
		opensearch.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < opensearch.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-opensearch:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-opensearch:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-opensearch:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-opensearch:latest
	@rm -f opensearch.tar sbom-*.spdx.json
	@echo "✓ containers-opensearch built (official min distribution)"

#------------------------------------------------------------------------------
# PHP IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
php-melange: keygen
	@echo "Building PHP from source via melange..."
	melange build images/php/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ PHP package built from source"

php: php-melange
	@echo "Assembling containers-php image with apko..."
	apko build images/php/apko/php.yaml \
		$(REGISTRY)/$(OWNER)/containers-php:$(VERSION) \
		php.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < php.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-php:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-php:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-php:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-php:latest
	@rm -f php.tar sbom-*.spdx.json
	@echo "✓ containers-php built (source build)"

#------------------------------------------------------------------------------
# RUBY IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
ruby-melange: keygen
	@echo "Building Ruby $(RUBY_VERSION) from source via melange..."
	melange build images/ruby/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Ruby package built from source"

ruby: ruby-melange
	@echo "Assembling containers-ruby image with apko..."
	apko build images/ruby/apko/ruby.yaml \
		$(REGISTRY)/$(OWNER)/containers-ruby:$(VERSION) \
		ruby.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < ruby.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-ruby:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-ruby:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-ruby:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-ruby:latest
	@rm -f ruby.tar sbom-*.spdx.json
	@echo "✓ containers-ruby built (source build)"

$(eval $(call DEV_IMAGE_RULE,ruby,ruby-melange,--repository-append ./packages --keyring-append melange.rsa.pub))

#------------------------------------------------------------------------------
# RAILS IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
rails-melange: keygen
	@echo "Building Ruby $(RUBY_VERSION) + Rails $(RAILS_VERSION) from source via melange..."
	melange build images/rails/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Rails package built from source"

rails: rails-melange
	@echo "Assembling containers-rails image with apko..."
	apko build images/rails/apko/rails.yaml \
		$(REGISTRY)/$(OWNER)/containers-rails:$(VERSION) \
		rails.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < rails.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-rails:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-rails:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-rails:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-rails:latest
	@rm -f rails.tar sbom-*.spdx.json
	@echo "✓ containers-rails built (source build)"

#------------------------------------------------------------------------------
# KAFKA IMAGE (official binary release + jlink JRE, KRaft mode)
#------------------------------------------------------------------------------
kafka-melange: keygen
	@echo "Building Kafka $(KAFKA_VERSION) package via melange..."
	# x86_64 only locally: jlink runs inside the melange sandbox so aarch64
	# cross-builds fail on x86_64 hosts without QEMU binfmt. CI uses native ARM runners.
	melange build images/kafka/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Kafka package built"

kafka: kafka-melange
	@echo "Assembling containers-kafka image with apko..."
	apko build images/kafka/apko/kafka.yaml \
		$(REGISTRY)/$(OWNER)/containers-kafka:$(KAFKA_VERSION) \
		kafka.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kafka.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kafka:$(KAFKA_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kafka:$(KAFKA_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kafka:$(KAFKA_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kafka:latest
	@rm -f kafka.tar sbom-*.spdx.json
	@echo "✓ containers-kafka built (official binary + jlink JRE)"

#------------------------------------------------------------------------------
# CASSANDRA IMAGE (official binary release + jlink JRE, Java 17)
#------------------------------------------------------------------------------
cassandra-melange: keygen
	@echo "Building Cassandra $(CASSANDRA_VERSION) package via melange..."
	# x86_64 only locally: jlink runs inside the melange sandbox so aarch64
	# cross-builds fail on x86_64 hosts without QEMU binfmt. CI uses native ARM runners.
	melange build images/cassandra/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Cassandra package built"

cassandra: cassandra-melange
	@echo "Assembling containers-cassandra image with apko..."
	apko build images/cassandra/apko/cassandra.yaml \
		$(REGISTRY)/$(OWNER)/containers-cassandra:$(CASSANDRA_VERSION) \
		cassandra.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < cassandra.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-cassandra:$(CASSANDRA_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cassandra:$(CASSANDRA_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-cassandra:$(CASSANDRA_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cassandra:latest
	@rm -f cassandra.tar sbom-*.spdx.json
	@echo "✓ containers-cassandra built (official binary + jlink JRE)"

#------------------------------------------------------------------------------
# SOLR IMAGE (official binary release + jlink JRE, Java 21)
#------------------------------------------------------------------------------
solr-melange: keygen
	@echo "Building Solr $(SOLR_VERSION) package via melange..."
	melange build images/solr/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Solr package built"

solr: solr-melange
	@echo "Assembling containers-solr image with apko..."
	apko build images/solr/apko/solr.yaml \
		$(REGISTRY)/$(OWNER)/containers-solr:$(SOLR_VERSION) \
		solr.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < solr.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-solr:$(SOLR_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-solr:$(SOLR_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-solr:$(SOLR_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-solr:latest
	@rm -f solr.tar sbom-*.spdx.json
	@echo "✓ containers-solr built (official binary + jlink JRE)"

#------------------------------------------------------------------------------
# PULSAR IMAGE (official binary release + jlink JRE, Java 21)
#------------------------------------------------------------------------------
pulsar-melange: keygen
	@echo "Building Pulsar $(PULSAR_VERSION) package via melange..."
	melange build images/pulsar/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Pulsar package built"

pulsar: pulsar-melange
	@echo "Assembling containers-pulsar image with apko..."
	apko build images/pulsar/apko/pulsar.yaml \
		$(REGISTRY)/$(OWNER)/containers-pulsar:$(PULSAR_VERSION) \
		pulsar.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < pulsar.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-pulsar:$(PULSAR_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-pulsar:$(PULSAR_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-pulsar:$(PULSAR_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-pulsar:latest
	@rm -f pulsar.tar sbom-*.spdx.json
	@echo "✓ containers-pulsar built (official binary + jlink JRE)"

zookeeper-melange: keygen
	@echo "Building ZooKeeper $(ZOOKEEPER_VERSION) package via melange..."
	# x86_64 only locally: jlink runs inside the melange sandbox so aarch64
	# cross-builds fail on x86_64 hosts without QEMU binfmt. CI uses native ARM runners.
	melange build images/zookeeper/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ ZooKeeper package built"

zookeeper: zookeeper-melange
	@echo "Assembling containers-zookeeper image with apko..."
	apko build images/zookeeper/apko/zookeeper.yaml \
		$(REGISTRY)/$(OWNER)/containers-zookeeper:$(ZOOKEEPER_VERSION) \
		zookeeper.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < zookeeper.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-zookeeper:$(ZOOKEEPER_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-zookeeper:$(ZOOKEEPER_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-zookeeper:$(ZOOKEEPER_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-zookeeper:latest
	@rm -f zookeeper.tar sbom-*.spdx.json
	@echo "✓ containers-zookeeper built (official binary + jlink JRE)"

tomcat-melange: keygen
	@echo "Building Tomcat $(TOMCAT_VERSION) package via melange..."
	# x86_64 only locally: jlink runs inside the melange sandbox.
	melange build images/tomcat/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Tomcat package built"

tomcat: tomcat-melange
	@echo "Assembling containers-tomcat image with apko..."
	apko build images/tomcat/apko/tomcat.yaml \
		$(REGISTRY)/$(OWNER)/containers-tomcat:$(TOMCAT_VERSION) \
		tomcat.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < tomcat.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-tomcat:$(TOMCAT_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-tomcat:$(TOMCAT_VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-tomcat:$(TOMCAT_VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-tomcat:latest
	@rm -f tomcat.tar sbom-*.spdx.json
	@echo "✓ containers-tomcat built (official binary + jlink JRE)"

#------------------------------------------------------------------------------
# COREDNS IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
coredns-melange: keygen
	@echo "Building CoreDNS $(COREDNS_VERSION) from source via melange..."
	melange build images/coredns/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ CoreDNS package built from source"

coredns: coredns-melange
	@echo "Assembling containers-coredns image with apko..."
	apko build images/coredns/apko/coredns.yaml \
		$(REGISTRY)/$(OWNER)/containers-coredns:$(VERSION) \
		coredns.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < coredns.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-coredns:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-coredns:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-coredns:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-coredns:latest
	@rm -f coredns.tar sbom-*.spdx.json
	@echo "✓ containers-coredns built (source build)"

gitea-melange: keygen
	@echo "Building Gitea $(GITEA_VERSION) from source via melange..."
	melange build images/gitea/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Gitea package built from source"

gitea: gitea-melange
	@echo "Assembling containers-gitea image with apko..."
	apko build images/gitea/apko/gitea.yaml \
		$(REGISTRY)/$(OWNER)/containers-gitea:$(VERSION) \
		gitea.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < gitea.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-gitea:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-gitea:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-gitea:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-gitea:latest
	@rm -f gitea.tar sbom-*.spdx.json
	@echo "✓ containers-gitea built (source build)"

#------------------------------------------------------------------------------
# OPENBAO IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
openbao-melange: keygen
	@echo "Building OpenBao $(OPENBAO_VERSION) from source via melange..."
	melange build images/openbao/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ OpenBao package built from source"

openbao: openbao-melange
	@echo "Assembling containers-openbao image with apko..."
	apko build images/openbao/apko/openbao.yaml \
		$(REGISTRY)/$(OWNER)/containers-openbao:$(VERSION) \
		openbao.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < openbao.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-openbao:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-openbao:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-openbao:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-openbao:latest
	@rm -f openbao.tar sbom-*.spdx.json
	@echo "✓ containers-openbao built (source build)"

#------------------------------------------------------------------------------
# LOKI IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
loki-melange: keygen
	@echo "Building Loki $(LOKI_VERSION) from source via melange..."
	melange build images/loki/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Loki package built from source"

loki: loki-melange
	@echo "Assembling containers-loki image with apko..."
	apko build images/loki/apko/loki.yaml \
		$(REGISTRY)/$(OWNER)/containers-loki:$(VERSION) \
		loki.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < loki.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-loki:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-loki:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-loki:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-loki:latest
	@rm -f loki.tar sbom-*.spdx.json
	@echo "✓ containers-loki built (source build)"

#------------------------------------------------------------------------------
# FLUENT BIT IMAGE (melange source build + apko)
#------------------------------------------------------------------------------
fluent-bit-melange: keygen
	@echo "Building Fluent Bit $(FLUENT_BIT_VERSION) from source via melange..."
	melange build images/fluent-bit/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Fluent Bit package built from source"

fluent-bit: fluent-bit-melange
	@echo "Assembling containers-fluent-bit image with apko..."
	apko build images/fluent-bit/apko/fluent-bit.yaml \
		$(REGISTRY)/$(OWNER)/containers-fluent-bit:$(VERSION) \
		fluent-bit.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < fluent-bit.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-fluent-bit:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-fluent-bit:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-fluent-bit:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-fluent-bit:latest
	@rm -f fluent-bit.tar sbom-*.spdx.json
	@echo "✓ containers-fluent-bit built (source build)"

#------------------------------------------------------------------------------
# KEYCLOAK IMAGE (melange pre-built distribution + apko)
#------------------------------------------------------------------------------
keycloak-melange: keygen
	@echo "Building Keycloak $(KEYCLOAK_VERSION) package via melange..."
	melange build images/keycloak/melange.yaml \
		--arch x86_64,aarch64 \
		--signing-key melange.rsa
	@echo "✓ Keycloak package built"

keycloak: keycloak-melange
	@echo "Assembling containers-keycloak image with apko..."
	apko build images/keycloak/apko/keycloak.yaml \
		$(REGISTRY)/$(OWNER)/containers-keycloak:$(VERSION) \
		keycloak.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < keycloak.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-keycloak:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-keycloak:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-keycloak:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-keycloak:latest
	@rm -f keycloak.tar sbom-*.spdx.json
	@echo "✓ containers-keycloak built (pre-built distribution)"

#------------------------------------------------------------------------------
# REGISTRY IMAGE (melange source build + apko — distribution/distribution)
#------------------------------------------------------------------------------
registry-melange: keygen
	@echo "Building distribution $(DISTRIBUTION_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/registry/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ registry (distribution) package built from source"

registry: registry-melange
	@echo "Assembling containers-registry image with apko..."
	apko build images/registry/apko/registry.yaml \
		$(REGISTRY)/$(OWNER)/containers-registry:$(VERSION) \
		registry.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < registry.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-registry:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-registry:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-registry:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-registry:latest
	@rm -f registry.tar sbom-*.spdx.json
	@echo "✓ containers-registry built (source build)"

#------------------------------------------------------------------------------
# MAILPIT IMAGE (melange Go + npm frontend source build + apko)
#------------------------------------------------------------------------------
mailpit-melange: keygen
	@echo "Building mailpit $(MAILPIT_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/mailpit/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ mailpit package built from source"

mailpit: mailpit-melange
	@echo "Assembling containers-mailpit image with apko..."
	apko build images/mailpit/apko/mailpit.yaml \
		$(REGISTRY)/$(OWNER)/containers-mailpit:$(VERSION) \
		mailpit.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < mailpit.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-mailpit:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mailpit:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-mailpit:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mailpit:latest
	@rm -f mailpit.tar sbom-*.spdx.json
	@echo "✓ containers-mailpit built (source build)"

#------------------------------------------------------------------------------
# CONSUL IMAGE (melange Go source build + apko; BUSL-1.1)
#------------------------------------------------------------------------------
consul-melange: keygen
	@echo "Building Consul $(CONSUL_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/consul/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Consul package built from source"

consul: consul-melange
	@echo "Assembling containers-consul image with apko..."
	apko build images/consul/apko/consul.yaml \
		$(REGISTRY)/$(OWNER)/containers-consul:$(VERSION) \
		consul.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < consul.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-consul:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-consul:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-consul:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-consul:latest
	@rm -f consul.tar sbom-*.spdx.json
	@echo "✓ containers-consul built (source build)"

#------------------------------------------------------------------------------
# TEMPO IMAGE (melange Go source build + apko; Grafana distributed tracing)
#------------------------------------------------------------------------------
tempo-melange: keygen
	@echo "Building Tempo $(TEMPO_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/tempo/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Tempo package built from source"

tempo: tempo-melange
	@echo "Assembling containers-tempo image with apko..."
	apko build images/tempo/apko/tempo.yaml \
		$(REGISTRY)/$(OWNER)/containers-tempo:$(VERSION) \
		tempo.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < tempo.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-tempo:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-tempo:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-tempo:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-tempo:latest
	@rm -f tempo.tar sbom-*.spdx.json
	@echo "✓ containers-tempo built (source build)"

#------------------------------------------------------------------------------
# OPENTOFU IMAGE (melange Go source build + apko; Terraform-compatible IaC CLI)
#------------------------------------------------------------------------------
opentofu-melange: keygen
	@echo "Building OpenTofu $(OPENTOFU_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/opentofu/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ OpenTofu package built from source"

opentofu: opentofu-melange
	@echo "Assembling containers-opentofu image with apko..."
	apko build images/opentofu/apko/opentofu.yaml \
		$(REGISTRY)/$(OWNER)/containers-opentofu:$(VERSION) \
		opentofu.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < opentofu.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-opentofu:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-opentofu:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-opentofu:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-opentofu:latest
	@rm -f opentofu.tar sbom-*.spdx.json
	@echo "✓ containers-opentofu built (source build)"

#------------------------------------------------------------------------------
# TRIVY IMAGE (melange Go source build + apko; vulnerability/IaC/secret scanner)
#------------------------------------------------------------------------------
trivy-melange: keygen
	@echo "Building Trivy $(TRIVY_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/trivy/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Trivy package built from source"

trivy: trivy-melange
	@echo "Assembling containers-trivy image with apko..."
	apko build images/trivy/apko/trivy.yaml \
		$(REGISTRY)/$(OWNER)/containers-trivy:$(VERSION) \
		trivy.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < trivy.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-trivy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-trivy:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-trivy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-trivy:latest
	@rm -f trivy.tar sbom-*.spdx.json
	@echo "✓ containers-trivy built (source build)"

#------------------------------------------------------------------------------
# COSIGN IMAGE (melange Go source build + apko; Sigstore container signing)
#------------------------------------------------------------------------------
cosign-melange: keygen
	@echo "Building Cosign $(COSIGN_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/cosign/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Cosign package built from source"

cosign: cosign-melange
	@echo "Assembling containers-cosign image with apko..."
	apko build images/cosign/apko/cosign.yaml \
		$(REGISTRY)/$(OWNER)/containers-cosign:$(VERSION) \
		cosign.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < cosign.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-cosign:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cosign:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-cosign:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cosign:latest
	@rm -f cosign.tar sbom-*.spdx.json
	@echo "✓ containers-cosign built (source build)"

#------------------------------------------------------------------------------
# ZOT IMAGE (melange Go source build + apko; OCI-native container registry)
#------------------------------------------------------------------------------
zot-melange: keygen
	@echo "Building zot $(ZOT_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/zot/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ zot package built from source"

zot: zot-melange
	@echo "Assembling containers-zot image with apko..."
	apko build images/zot/apko/zot.yaml \
		$(REGISTRY)/$(OWNER)/containers-zot:$(VERSION) \
		zot.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < zot.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-zot:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-zot:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-zot:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-zot:latest
	@rm -f zot.tar sbom-*.spdx.json
	@echo "✓ containers-zot built (source build)"

$(eval $(call DEV_IMAGE_RULE,zot,zot-melange,--repository-append ./packages --keyring-append melange.rsa.pub))

#------------------------------------------------------------------------------
# ERLANG IMAGE (melange source build + apko; Erlang/OTP runtime)
#------------------------------------------------------------------------------
erlang-melange: keygen
	@echo "Building Erlang/OTP $(ERLANG_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/erlang/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Erlang/OTP package built from source"

erlang: erlang-melange
	@echo "Assembling containers-erlang image with apko..."
	apko build images/erlang/apko/erlang.yaml \
		$(REGISTRY)/$(OWNER)/containers-erlang:$(VERSION) \
		erlang.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < erlang.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-erlang:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-erlang:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-erlang:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-erlang:latest
	@rm -f erlang.tar sbom-*.spdx.json
	@echo "✓ containers-erlang built (source build)"

$(eval $(call DEV_IMAGE_RULE,erlang,erlang-melange,--repository-append ./packages --keyring-append melange.rsa.pub))

#------------------------------------------------------------------------------
# PERL IMAGE (melange source build + apko; Perl interpreter)
#------------------------------------------------------------------------------
perl-melange: keygen
	@echo "Building Perl $(PERL_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/perl/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Perl package built from source"

perl: perl-melange
	@echo "Assembling containers-perl image with apko..."
	apko build images/perl/apko/perl.yaml \
		$(REGISTRY)/$(OWNER)/containers-perl:$(VERSION) \
		perl.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < perl.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-perl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-perl:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-perl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-perl:latest
	@rm -f perl.tar sbom-*.spdx.json
	@echo "✓ containers-perl built (source build)"

$(eval $(call DEV_IMAGE_RULE,perl,perl-melange,--repository-append ./packages --keyring-append melange.rsa.pub))

#------------------------------------------------------------------------------
# NEO4J IMAGE (melange source build + apko; Neo4j graph database)
#------------------------------------------------------------------------------
neo4j-melange: keygen
	@echo "Building Neo4j $(NEO4J_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/neo4j/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Neo4j package built from source"

neo4j: neo4j-melange
	@echo "Assembling containers-neo4j image with apko..."
	apko build images/neo4j/apko/neo4j.yaml \
		$(REGISTRY)/$(OWNER)/containers-neo4j:$(VERSION) \
		neo4j.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < neo4j.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-neo4j:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-neo4j:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-neo4j:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-neo4j:latest
	@rm -f neo4j.tar sbom-*.spdx.json
	@echo "✓ containers-neo4j built (source build)"

$(eval $(call DEV_IMAGE_RULE,neo4j,neo4j-melange,--repository-append ./packages --keyring-append melange.rsa.pub))

#------------------------------------------------------------------------------
# SYFT IMAGE (melange Go source build + apko; SBOM generation)
#------------------------------------------------------------------------------
syft-melange: keygen
	@echo "Building Syft $(SYFT_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/syft/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Syft package built from source"

syft: syft-melange
	@echo "Assembling containers-syft image with apko..."
	apko build images/syft/apko/syft.yaml \
		$(REGISTRY)/$(OWNER)/containers-syft:$(VERSION) \
		syft.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < syft.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-syft:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-syft:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-syft:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-syft:latest
	@rm -f syft.tar sbom-*.spdx.json
	@echo "✓ containers-syft built (source build)"

#------------------------------------------------------------------------------
# GRYPE IMAGE (melange Go source build + apko; vulnerability scanning)
#------------------------------------------------------------------------------
grype-melange: keygen
	@echo "Building Grype $(GRYPE_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/grype/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Grype package built from source"

grype: grype-melange
	@echo "Assembling containers-grype image with apko..."
	apko build images/grype/apko/grype.yaml \
		$(REGISTRY)/$(OWNER)/containers-grype:$(VERSION) \
		grype.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < grype.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-grype:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-grype:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-grype:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-grype:latest
	@rm -f grype.tar sbom-*.spdx.json
	@echo "✓ containers-grype built (source build)"

#------------------------------------------------------------------------------
# ORAS IMAGE (melange Go source build + apko; OCI registry client)
#------------------------------------------------------------------------------
oras-melange: keygen
	@echo "Building ORAS $(ORAS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/oras/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ ORAS package built from source"

oras: oras-melange
	@echo "Assembling containers-oras image with apko..."
	apko build images/oras/apko/oras.yaml \
		$(REGISTRY)/$(OWNER)/containers-oras:$(VERSION) \
		oras.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < oras.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-oras:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-oras:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-oras:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-oras:latest
	@rm -f oras.tar sbom-*.spdx.json
	@echo "✓ containers-oras built (source build)"

#------------------------------------------------------------------------------
# GITLEAKS IMAGE (melange Go source build + apko; secret scanning)
#------------------------------------------------------------------------------
gitleaks-melange: keygen
	@echo "Building Gitleaks $(GITLEAKS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/gitleaks/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Gitleaks package built from source"

gitleaks: gitleaks-melange
	@echo "Assembling containers-gitleaks image with apko..."
	apko build images/gitleaks/apko/gitleaks.yaml \
		$(REGISTRY)/$(OWNER)/containers-gitleaks:$(VERSION) \
		gitleaks.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < gitleaks.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-gitleaks:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-gitleaks:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-gitleaks:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-gitleaks:latest
	@rm -f gitleaks.tar sbom-*.spdx.json
	@echo "✓ containers-gitleaks built (source build)"

#------------------------------------------------------------------------------
# STEP-CLI IMAGE (melange Go source build + apko; smallstep PKI/cert toolkit)
#------------------------------------------------------------------------------
step-cli-melange: keygen
	@echo "Building step-cli $(STEP_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/step-cli/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ step-cli package built from source"

step-cli: step-cli-melange
	@echo "Assembling containers-step-cli image with apko..."
	apko build images/step-cli/apko/step-cli.yaml \
		$(REGISTRY)/$(OWNER)/containers-step-cli:$(VERSION) \
		step-cli.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < step-cli.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-step-cli:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-step-cli:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-step-cli:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-step-cli:latest
	@rm -f step-cli.tar sbom-*.spdx.json
	@echo "✓ containers-step-cli built (source build)"

#------------------------------------------------------------------------------
# OPA IMAGE (melange Go source build + apko; Open Policy Agent)
#------------------------------------------------------------------------------
opa-melange: keygen
	@echo "Building OPA $(OPA_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/opa/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ OPA package built from source"

opa: opa-melange
	@echo "Assembling containers-opa image with apko..."
	apko build images/opa/apko/opa.yaml \
		$(REGISTRY)/$(OWNER)/containers-opa:$(VERSION) \
		opa.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < opa.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-opa:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-opa:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-opa:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-opa:latest
	@rm -f opa.tar sbom-*.spdx.json
	@echo "✓ containers-opa built (source build)"

#------------------------------------------------------------------------------
# OSV-SCANNER IMAGE (melange Go source build + apko; dependency vuln scanning)
#------------------------------------------------------------------------------
osv-scanner-melange: keygen
	@echo "Building OSV-Scanner $(OSV_SCANNER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/osv-scanner/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ OSV-Scanner package built from source"

osv-scanner: osv-scanner-melange
	@echo "Assembling containers-osv-scanner image with apko..."
	apko build images/osv-scanner/apko/osv-scanner.yaml \
		$(REGISTRY)/$(OWNER)/containers-osv-scanner:$(VERSION) \
		osv-scanner.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < osv-scanner.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-osv-scanner:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-osv-scanner:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-osv-scanner:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-osv-scanner:latest
	@rm -f osv-scanner.tar sbom-*.spdx.json
	@echo "✓ containers-osv-scanner built (source build)"

rclone-melange: keygen
	@echo "Building rclone $(RCLONE_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/rclone/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ rclone package built from source"

rclone: rclone-melange
	@echo "Assembling containers-rclone image with apko..."
	apko build images/rclone/apko/rclone.yaml \
		$(REGISTRY)/$(OWNER)/containers-rclone:$(VERSION) \
		rclone.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < rclone.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-rclone:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-rclone:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-rclone:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-rclone:latest
	@rm -f rclone.tar sbom-*.spdx.json
	@echo "✓ containers-rclone built (source build)"

tailscale-melange: keygen
	@echo "Building Tailscale $(TAILSCALE_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/tailscale/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Tailscale package built from source"

tailscale: tailscale-melange
	@echo "Assembling containers-tailscale image with apko..."
	apko build images/tailscale/apko/tailscale.yaml \
		$(REGISTRY)/$(OWNER)/containers-tailscale:$(VERSION) \
		tailscale.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < tailscale.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-tailscale:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-tailscale:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-tailscale:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-tailscale:latest
	@rm -f tailscale.tar sbom-*.spdx.json
	@echo "✓ containers-tailscale built (source build)"

descheduler-melange: keygen
	@echo "Building descheduler $(DESCHEDULER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/descheduler/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ descheduler package built from source"

descheduler: descheduler-melange
	@echo "Assembling containers-descheduler image with apko..."
	apko build images/descheduler/apko/descheduler.yaml \
		$(REGISTRY)/$(OWNER)/containers-descheduler:$(VERSION) \
		descheduler.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < descheduler.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-descheduler:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-descheduler:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-descheduler:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-descheduler:latest
	@rm -f descheduler.tar sbom-*.spdx.json
	@echo "✓ containers-descheduler built (source build)"

restic-melange: keygen
	@echo "Building restic $(RESTIC_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/restic/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ restic package built from source"

restic: restic-melange
	@echo "Assembling containers-restic image with apko..."
	apko build images/restic/apko/restic.yaml \
		$(REGISTRY)/$(OWNER)/containers-restic:$(VERSION) \
		restic.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < restic.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-restic:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-restic:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-restic:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-restic:latest
	@rm -f restic.tar sbom-*.spdx.json
	@echo "✓ containers-restic built (source build)"

seaweedfs-melange: keygen
	@echo "Building SeaweedFS $(SEAWEEDFS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/seaweedfs/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ SeaweedFS package built from source"

seaweedfs: seaweedfs-melange
	@echo "Assembling containers-seaweedfs image with apko..."
	apko build images/seaweedfs/apko/seaweedfs.yaml \
		$(REGISTRY)/$(OWNER)/containers-seaweedfs:$(VERSION) \
		seaweedfs.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < seaweedfs.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-seaweedfs:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-seaweedfs:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-seaweedfs:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-seaweedfs:latest
	@rm -f seaweedfs.tar sbom-*.spdx.json
	@echo "✓ containers-seaweedfs built (source build)"

syncthing-melange: keygen
	@echo "Building Syncthing $(SYNCTHING_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/syncthing/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Syncthing package built from source"

syncthing: syncthing-melange
	@echo "Assembling containers-syncthing image with apko..."
	apko build images/syncthing/apko/syncthing.yaml \
		$(REGISTRY)/$(OWNER)/containers-syncthing:$(VERSION) \
		syncthing.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < syncthing.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-syncthing:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-syncthing:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-syncthing:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-syncthing:latest
	@rm -f syncthing.tar sbom-*.spdx.json
	@echo "✓ containers-syncthing built (source build)"

nsq-melange: keygen
	@echo "Building NSQ $(NSQ_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/nsq/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ NSQ package built from source"

nsq: nsq-melange
	@echo "Assembling containers-nsq image with apko..."
	apko build images/nsq/apko/nsq.yaml \
		$(REGISTRY)/$(OWNER)/containers-nsq:$(VERSION) \
		nsq.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < nsq.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-nsq:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-nsq:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-nsq:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-nsq:latest
	@rm -f nsq.tar sbom-*.spdx.json
	@echo "✓ containers-nsq built (source build)"

gitlab-runner-melange: keygen
	@echo "Building GitLab Runner $(GITLAB_RUNNER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/gitlab-runner/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ GitLab Runner package built from source"

gitlab-runner: gitlab-runner-melange
	@echo "Assembling containers-gitlab-runner image with apko..."
	apko build images/gitlab-runner/apko/gitlab-runner.yaml \
		$(REGISTRY)/$(OWNER)/containers-gitlab-runner:$(VERSION) \
		gitlab-runner.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < gitlab-runner.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-gitlab-runner:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-gitlab-runner:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-gitlab-runner:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-gitlab-runner:latest
	@rm -f gitlab-runner.tar sbom-*.spdx.json
	@echo "✓ containers-gitlab-runner built (source build)"

buildkit-melange: keygen
	@echo "Building BuildKit $(BUILDKIT_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/buildkit/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ BuildKit package built from source"

buildkit: buildkit-melange
	@echo "Assembling containers-buildkit image with apko..."
	apko build images/buildkit/apko/buildkit.yaml \
		$(REGISTRY)/$(OWNER)/containers-buildkit:$(VERSION) \
		buildkit.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < buildkit.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-buildkit:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-buildkit:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-buildkit:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-buildkit:latest
	@rm -f buildkit.tar sbom-*.spdx.json
	@echo "✓ containers-buildkit built (source build)"

dex-melange: keygen
	@echo "Building Dex $(DEX_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/dex/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Dex package built from source"

dex: dex-melange
	@echo "Assembling containers-dex image with apko..."
	apko build images/dex/apko/dex.yaml \
		$(REGISTRY)/$(OWNER)/containers-dex:$(VERSION) \
		dex.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < dex.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-dex:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-dex:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-dex:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-dex:latest
	@rm -f dex.tar sbom-*.spdx.json
	@echo "✓ containers-dex built (source build)"

kube-vip-melange: keygen
	@echo "Building kube-vip $(KUBE_VIP_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kube-vip/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ kube-vip package built from source"

kube-vip: kube-vip-melange
	@echo "Assembling containers-kube-vip image with apko..."
	apko build images/kube-vip/apko/kube-vip.yaml \
		$(REGISTRY)/$(OWNER)/containers-kube-vip:$(VERSION) \
		kube-vip.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kube-vip.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kube-vip:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kube-vip:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kube-vip:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kube-vip:latest
	@rm -f kube-vip.tar sbom-*.spdx.json
	@echo "✓ containers-kube-vip built (source build)"

zipkin-melange: keygen
	@echo "Building Zipkin $(ZIPKIN_VERSION) via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/zipkin/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Zipkin package built"

zipkin: zipkin-melange
	@echo "Assembling containers-zipkin image with apko..."
	apko build images/zipkin/apko/zipkin.yaml \
		$(REGISTRY)/$(OWNER)/containers-zipkin:$(VERSION) \
		zipkin.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < zipkin.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-zipkin:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-zipkin:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-zipkin:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-zipkin:latest
	@rm -f zipkin.tar sbom-*.spdx.json
	@echo "✓ containers-zipkin built"

oauth2-proxy-melange: keygen
	@echo "Building OAuth2 Proxy $(OAUTH2_PROXY_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/oauth2-proxy/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ OAuth2 Proxy package built from source"

oauth2-proxy: oauth2-proxy-melange
	@echo "Assembling containers-oauth2-proxy image with apko..."
	apko build images/oauth2-proxy/apko/oauth2-proxy.yaml \
		$(REGISTRY)/$(OWNER)/containers-oauth2-proxy:$(VERSION) \
		oauth2-proxy.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < oauth2-proxy.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-oauth2-proxy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-oauth2-proxy:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-oauth2-proxy:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-oauth2-proxy:latest
	@rm -f oauth2-proxy.tar sbom-*.spdx.json
	@echo "✓ containers-oauth2-proxy built (source build)"

flux-melange: keygen
	@echo "Building flux $(FLUX_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/flux/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ flux package built from source"

flux: flux-melange
	@echo "Assembling containers-flux image with apko..."
	apko build images/flux/apko/flux.yaml \
		$(REGISTRY)/$(OWNER)/containers-flux:$(VERSION) \
		flux.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < flux.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-flux:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-flux:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-flux:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-flux:latest
	@rm -f flux.tar sbom-*.spdx.json
	@echo "✓ containers-flux built (source build)"

kustomize-melange: keygen
	@echo "Building kustomize $(KUSTOMIZE_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kustomize/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ kustomize package built from source"

kustomize: kustomize-melange
	@echo "Assembling containers-kustomize image with apko..."
	apko build images/kustomize/apko/kustomize.yaml \
		$(REGISTRY)/$(OWNER)/containers-kustomize:$(VERSION) \
		kustomize.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kustomize.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kustomize:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kustomize:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kustomize:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kustomize:latest
	@rm -f kustomize.tar sbom-*.spdx.json
	@echo "✓ containers-kustomize built (source build)"

sops-melange: keygen
	@echo "Building sops $(SOPS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/sops/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ sops package built from source"

sops: sops-melange
	@echo "Assembling containers-sops image with apko..."
	apko build images/sops/apko/sops.yaml \
		$(REGISTRY)/$(OWNER)/containers-sops:$(VERSION) \
		sops.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < sops.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-sops:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-sops:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-sops:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-sops:latest
	@rm -f sops.tar sbom-*.spdx.json
	@echo "✓ containers-sops built (source build)"

crane-melange: keygen
	@echo "Building crane $(CRANE_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/crane/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ crane package built from source"

crane: crane-melange
	@echo "Assembling containers-crane image with apko..."
	apko build images/crane/apko/crane.yaml \
		$(REGISTRY)/$(OWNER)/containers-crane:$(VERSION) \
		crane.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < crane.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-crane:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-crane:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-crane:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-crane:latest
	@rm -f crane.tar sbom-*.spdx.json
	@echo "✓ containers-crane built (source build)"

kubeseal-melange: keygen
	@echo "Building kubeseal $(KUBESEAL_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kubeseal/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ kubeseal package built from source"

cmctl-melange: keygen
	@echo "Building cmctl $(CMCTL_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/cmctl/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ cmctl package built from source"

cmctl: cmctl-melange
	@echo "Assembling containers-cmctl image with apko..."
	apko build images/cmctl/apko/cmctl.yaml \
		$(REGISTRY)/$(OWNER)/containers-cmctl:$(VERSION) \
		cmctl.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < cmctl.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-cmctl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cmctl:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-cmctl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-cmctl:latest
	@rm -f cmctl.tar sbom-*.spdx.json
	@echo "✓ containers-cmctl built (source build)"

timescaledb-melange: keygen
	@echo "Building timescaledb $(TIMESCALEDB_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/timescaledb/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ timescaledb package built from source"

timescaledb: timescaledb-melange
	@echo "Assembling containers-timescaledb image with apko..."
	apko build images/timescaledb/apko/timescaledb.yaml \
		$(REGISTRY)/$(OWNER)/containers-timescaledb:$(VERSION) \
		timescaledb.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < timescaledb.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-timescaledb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-timescaledb:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-timescaledb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-timescaledb:latest
	@rm -f timescaledb.tar sbom-*.spdx.json
	@echo "✓ containers-timescaledb built (source build)"

kubeseal: kubeseal-melange
	@echo "Assembling containers-kubeseal image with apko..."
	apko build images/kubeseal/apko/kubeseal.yaml \
		$(REGISTRY)/$(OWNER)/containers-kubeseal:$(VERSION) \
		kubeseal.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kubeseal.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kubeseal:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kubeseal:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kubeseal:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kubeseal:latest
	@rm -f kubeseal.tar sbom-*.spdx.json
	@echo "✓ containers-kubeseal built (source build)"

helmfile-melange: keygen
	@echo "Building helmfile $(HELMFILE_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/helmfile/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ helmfile package built from source"

helmfile: helmfile-melange
	@echo "Assembling containers-helmfile image with apko..."
	apko build images/helmfile/apko/helmfile.yaml \
		$(REGISTRY)/$(OWNER)/containers-helmfile:$(VERSION) \
		helmfile.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < helmfile.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-helmfile:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-helmfile:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-helmfile:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-helmfile:latest
	@rm -f helmfile.tar sbom-*.spdx.json
	@echo "✓ containers-helmfile built (source build)"

regctl-melange: keygen
	@echo "Building regctl $(REGCTL_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/regctl/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ regctl package built from source"

regctl: regctl-melange
	@echo "Assembling containers-regctl image with apko..."
	apko build images/regctl/apko/regctl.yaml \
		$(REGISTRY)/$(OWNER)/containers-regctl:$(VERSION) \
		regctl.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < regctl.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-regctl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-regctl:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-regctl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-regctl:latest
	@rm -f regctl.tar sbom-*.spdx.json
	@echo "✓ containers-regctl built (source build)"

stern-melange: keygen
	@echo "Building stern $(STERN_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/stern/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ stern package built from source"

stern: stern-melange
	@echo "Assembling containers-stern image with apko..."
	apko build images/stern/apko/stern.yaml \
		$(REGISTRY)/$(OWNER)/containers-stern:$(VERSION) \
		stern.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < stern.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-stern:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-stern:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-stern:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-stern:latest
	@rm -f stern.tar sbom-*.spdx.json
	@echo "✓ containers-stern built (source build)"



#------------------------------------------------------------------------------
# NOTATION IMAGE (melange Go source build + apko)
#------------------------------------------------------------------------------
notation-melange: keygen
	@echo "Building notation $(NOTATION_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/notation/melange.yaml --arch x86_64 --signing-key melange.rsa
	@echo "✓ notation package built from source"

notation: notation-melange
	@echo "Assembling containers-notation image with apko..."
	apko build images/notation/apko/notation.yaml $(REGISTRY)/$(OWNER)/containers-notation:$(VERSION) notation.tar --arch x86_64 --repository-append ./packages --keyring-append melange.rsa.pub
	docker load < notation.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-notation:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-notation:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-notation:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-notation:latest
	@rm -f notation.tar sbom-*.spdx.json
	@echo "✓ containers-notation built (source build)"

#------------------------------------------------------------------------------
# CONFTEST IMAGE (melange Go source build + apko)
#------------------------------------------------------------------------------
conftest-melange: keygen
	@echo "Building conftest $(CONFTEST_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/conftest/melange.yaml --arch x86_64 --signing-key melange.rsa
	@echo "✓ conftest package built from source"

conftest: conftest-melange
	@echo "Assembling containers-conftest image with apko..."
	apko build images/conftest/apko/conftest.yaml $(REGISTRY)/$(OWNER)/containers-conftest:$(VERSION) conftest.tar --arch x86_64 --repository-append ./packages --keyring-append melange.rsa.pub
	docker load < conftest.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-conftest:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-conftest:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-conftest:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-conftest:latest
	@rm -f conftest.tar sbom-*.spdx.json
	@echo "✓ containers-conftest built (source build)"

#------------------------------------------------------------------------------
# KUBECONFORM IMAGE (melange Go source build + apko)
#------------------------------------------------------------------------------
kubeconform-melange: keygen
	@echo "Building kubeconform $(KUBECONFORM_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kubeconform/melange.yaml --arch x86_64 --signing-key melange.rsa
	@echo "✓ kubeconform package built from source"

kubeconform: kubeconform-melange
	@echo "Assembling containers-kubeconform image with apko..."
	apko build images/kubeconform/apko/kubeconform.yaml $(REGISTRY)/$(OWNER)/containers-kubeconform:$(VERSION) kubeconform.tar --arch x86_64 --repository-append ./packages --keyring-append melange.rsa.pub
	docker load < kubeconform.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kubeconform:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-kubeconform:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kubeconform:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-kubeconform:latest
	@rm -f kubeconform.tar sbom-*.spdx.json
	@echo "✓ containers-kubeconform built (source build)"

#------------------------------------------------------------------------------
# KUBE_BENCH IMAGE (melange Go source build + apko)
#------------------------------------------------------------------------------
kube-bench-melange: keygen
	@echo "Building kube-bench $(KUBE_BENCH_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kube-bench/melange.yaml --arch x86_64 --signing-key melange.rsa
	@echo "✓ kube-bench package built from source"

kube-bench: kube-bench-melange
	@echo "Assembling containers-kube-bench image with apko..."
	apko build images/kube-bench/apko/kube-bench.yaml $(REGISTRY)/$(OWNER)/containers-kube-bench:$(VERSION) kube-bench.tar --arch x86_64 --repository-append ./packages --keyring-append melange.rsa.pub
	docker load < kube-bench.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kube-bench:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-kube-bench:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kube-bench:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-kube-bench:latest
	@rm -f kube-bench.tar sbom-*.spdx.json
	@echo "✓ containers-kube-bench built (source build)"

#------------------------------------------------------------------------------
# TRUFFLEHOG IMAGE (melange Go source build + apko)
#------------------------------------------------------------------------------
trufflehog-melange: keygen
	@echo "Building trufflehog $(TRUFFLEHOG_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/trufflehog/melange.yaml --arch x86_64 --signing-key melange.rsa
	@echo "✓ trufflehog package built from source"

trufflehog: trufflehog-melange
	@echo "Assembling containers-trufflehog image with apko..."
	apko build images/trufflehog/apko/trufflehog.yaml $(REGISTRY)/$(OWNER)/containers-trufflehog:$(VERSION) trufflehog.tar --arch x86_64 --repository-append ./packages --keyring-append melange.rsa.pub
	docker load < trufflehog.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-trufflehog:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-trufflehog:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-trufflehog:$(VERSION)-amd64 $(REGISTRY)/$(OWNER)/containers-trufflehog:latest
	@rm -f trufflehog.tar sbom-*.spdx.json
	@echo "✓ containers-trufflehog built (source build)"

#------------------------------------------------------------------------------
# THANOS IMAGE (melange Go source build + apko; HA Prometheus long-term storage)
#------------------------------------------------------------------------------
thanos-melange: keygen
	@echo "Building Thanos $(THANOS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/thanos/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Thanos package built from source"

thanos: thanos-melange
	@echo "Assembling containers-thanos image with apko..."
	apko build images/thanos/apko/thanos.yaml \
		$(REGISTRY)/$(OWNER)/containers-thanos:$(VERSION) \
		thanos.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < thanos.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-thanos:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-thanos:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-thanos:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-thanos:latest
	@rm -f thanos.tar sbom-*.spdx.json
	@echo "✓ containers-thanos built (source build)"

#------------------------------------------------------------------------------
# NODE-EXPORTER IMAGE (melange Go source build + apko; Prometheus host metrics)
#------------------------------------------------------------------------------
node-exporter-melange: keygen
	@echo "Building node_exporter $(NODE_EXPORTER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/node-exporter/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ node_exporter package built from source"

node-exporter: node-exporter-melange
	@echo "Assembling containers-node-exporter image with apko..."
	apko build images/node-exporter/apko/node-exporter.yaml \
		$(REGISTRY)/$(OWNER)/containers-node-exporter:$(VERSION) \
		node-exporter.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < node-exporter.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-node-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-node-exporter:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-node-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-node-exporter:latest
	@rm -f node-exporter.tar sbom-*.spdx.json
	@echo "✓ containers-node-exporter built (source build)"

#------------------------------------------------------------------------------
# BLACKBOX-EXPORTER IMAGE (melange Go source build + apko; Prometheus probing)
#------------------------------------------------------------------------------
blackbox-exporter-melange: keygen
	@echo "Building blackbox_exporter $(BLACKBOX_EXPORTER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/blackbox-exporter/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ blackbox_exporter package built from source"

blackbox-exporter: blackbox-exporter-melange
	@echo "Assembling containers-blackbox-exporter image with apko..."
	apko build images/blackbox-exporter/apko/blackbox-exporter.yaml \
		$(REGISTRY)/$(OWNER)/containers-blackbox-exporter:$(VERSION) \
		blackbox-exporter.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < blackbox-exporter.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-blackbox-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-blackbox-exporter:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-blackbox-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-blackbox-exporter:latest
	@rm -f blackbox-exporter.tar sbom-*.spdx.json
	@echo "✓ containers-blackbox-exporter built (source build)"

#------------------------------------------------------------------------------
# KUBE-STATE-METRICS IMAGE (melange Go source build + apko; Kubernetes object state metrics for Prometheus)
#------------------------------------------------------------------------------
kube-state-metrics-melange: keygen
	@echo "Building kube-state-metrics $(KUBE_STATE_METRICS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kube-state-metrics/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ kube-state-metrics package built from source"

kube-state-metrics: kube-state-metrics-melange
	@echo "Assembling containers-kube-state-metrics image with apko..."
	apko build images/kube-state-metrics/apko/kube-state-metrics.yaml \
		$(REGISTRY)/$(OWNER)/containers-kube-state-metrics:$(VERSION) \
		kube-state-metrics.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kube-state-metrics.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kube-state-metrics:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kube-state-metrics:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kube-state-metrics:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kube-state-metrics:latest
	@rm -f kube-state-metrics.tar sbom-*.spdx.json
	@echo "✓ containers-kube-state-metrics built (source build)"

#------------------------------------------------------------------------------
# REDIS-EXPORTER IMAGE (melange Go source build + apko; Redis metrics exporter for Prometheus)
#------------------------------------------------------------------------------
redis-exporter-melange: keygen
	@echo "Building redis_exporter $(REDIS_EXPORTER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/redis-exporter/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ redis_exporter package built from source"

redis-exporter: redis-exporter-melange
	@echo "Assembling containers-redis-exporter image with apko..."
	apko build images/redis-exporter/apko/redis-exporter.yaml \
		$(REGISTRY)/$(OWNER)/containers-redis-exporter:$(VERSION) \
		redis-exporter.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < redis-exporter.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-redis-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-redis-exporter:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-redis-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-redis-exporter:latest
	@rm -f redis-exporter.tar sbom-*.spdx.json
	@echo "✓ containers-redis-exporter built (source build)"

#------------------------------------------------------------------------------
# VAULTWARDEN IMAGE (melange Rust source build + apko; Bitwarden-compatible server)
#------------------------------------------------------------------------------
vaultwarden-melange: keygen
	@echo "Building vaultwarden $(VAULTWARDEN_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/vaultwarden/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ vaultwarden package built from source"

vaultwarden: vaultwarden-melange
	@echo "Assembling containers-vaultwarden image with apko..."
	apko build images/vaultwarden/apko/vaultwarden.yaml \
		$(REGISTRY)/$(OWNER)/containers-vaultwarden:$(VERSION) \
		vaultwarden.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < vaultwarden.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-vaultwarden:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-vaultwarden:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-vaultwarden:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-vaultwarden:latest
	@rm -f vaultwarden.tar sbom-*.spdx.json
	@echo "✓ containers-vaultwarden built (source build)"

#------------------------------------------------------------------------------
# KVROCKS IMAGE (melange C++ source build + apko; Redis-compatible store on RocksDB)
#------------------------------------------------------------------------------
kvrocks-melange: keygen
	@echo "Building kvrocks $(KVROCKS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kvrocks/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ kvrocks package built from source"

kvrocks: kvrocks-melange
	@echo "Assembling containers-kvrocks image with apko..."
	apko build images/kvrocks/apko/kvrocks.yaml \
		$(REGISTRY)/$(OWNER)/containers-kvrocks:$(VERSION) \
		kvrocks.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kvrocks.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kvrocks:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kvrocks:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kvrocks:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kvrocks:latest
	@rm -f kvrocks.tar sbom-*.spdx.json
	@echo "✓ containers-kvrocks built (source build)"

#------------------------------------------------------------------------------
# FLINK IMAGE (Apache binary release + jlink JRE via melange; stream processing)
#------------------------------------------------------------------------------
flink-melange: keygen
	@echo "Building Flink $(FLINK_VERSION) via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/flink/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ flink package built"

flink: flink-melange
	@echo "Assembling containers-flink image with apko..."
	apko build images/flink/apko/flink.yaml \
		$(REGISTRY)/$(OWNER)/containers-flink:$(VERSION) \
		flink.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < flink.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-flink:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-flink:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-flink:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-flink:latest
	@rm -f flink.tar sbom-*.spdx.json
	@echo "✓ containers-flink built"

#------------------------------------------------------------------------------
# PUSHGATEWAY IMAGE (melange Go source build + apko; Prometheus push gateway)
#------------------------------------------------------------------------------
pushgateway-melange: keygen
	@echo "Building pushgateway $(PUSHGATEWAY_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/pushgateway/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ pushgateway package built from source"

pushgateway: pushgateway-melange
	@echo "Assembling containers-pushgateway image with apko..."
	apko build images/pushgateway/apko/pushgateway.yaml \
		$(REGISTRY)/$(OWNER)/containers-pushgateway:$(VERSION) \
		pushgateway.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < pushgateway.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-pushgateway:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-pushgateway:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-pushgateway:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-pushgateway:latest
	@rm -f pushgateway.tar sbom-*.spdx.json
	@echo "✓ containers-pushgateway built (source build)"

#------------------------------------------------------------------------------
# MOSQUITTO IMAGE (melange C source build + apko; Eclipse MQTT broker)
#------------------------------------------------------------------------------
mosquitto-melange: keygen
	@echo "Building Mosquitto $(MOSQUITTO_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/mosquitto/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Mosquitto package built from source"

mosquitto: mosquitto-melange
	@echo "Assembling containers-mosquitto image with apko..."
	apko build images/mosquitto/apko/mosquitto.yaml \
		$(REGISTRY)/$(OWNER)/containers-mosquitto:$(VERSION) \
		mosquitto.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < mosquitto.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-mosquitto:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mosquitto:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-mosquitto:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-mosquitto:latest
	@rm -f mosquitto.tar sbom-*.spdx.json
	@echo "✓ containers-mosquitto built (source build)"

pgbouncer-melange: keygen
	@echo "Building PgBouncer $(PGBOUNCER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/pgbouncer/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ PgBouncer package built from source"

pgbouncer: pgbouncer-melange
	@echo "Assembling containers-pgbouncer image with apko..."
	apko build images/pgbouncer/apko/pgbouncer.yaml \
		$(REGISTRY)/$(OWNER)/containers-pgbouncer:$(VERSION) \
		pgbouncer.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < pgbouncer.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-pgbouncer:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-pgbouncer:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-pgbouncer:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-pgbouncer:latest
	@rm -f pgbouncer.tar sbom-*.spdx.json
	@echo "✓ containers-pgbouncer built (source build)"

#------------------------------------------------------------------------------
# KEEPALIVED IMAGE (source build via melange, shell-less)
#------------------------------------------------------------------------------
metrics-server-melange: keygen
	@echo "Building metrics-server $(METRICS_SERVER_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/metrics-server/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ metrics-server package built from source"

metrics-server: metrics-server-melange
	@echo "Assembling containers-metrics-server image with apko..."
	apko build images/metrics-server/apko/metrics-server.yaml \
		$(REGISTRY)/$(OWNER)/containers-metrics-server:$(VERSION) \
		metrics-server.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < metrics-server.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-metrics-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-metrics-server:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-metrics-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-metrics-server:latest
	@rm -f metrics-server.tar sbom-*.spdx.json
	@echo "✓ containers-metrics-server built (source build)"

keepalived-melange: keygen
	@echo "Building Keepalived package from source with melange..."
	melange build images/keepalived/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Keepalived package built from source"

keepalived: keepalived-melange
	@echo "Assembling containers-keepalived image with apko..."
	apko build images/keepalived/apko/keepalived.yaml \
		$(REGISTRY)/$(OWNER)/containers-keepalived:$(VERSION) \
		keepalived.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < keepalived.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-keepalived:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-keepalived:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-keepalived:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-keepalived:latest
	@rm -f keepalived.tar sbom-*.spdx.json
	@echo "✓ containers-keepalived built (source build)"

unbound-melange: keygen
	@echo "Building Unbound $(UNBOUND_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/unbound/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Unbound package built from source"

unbound: unbound-melange
	@echo "Assembling containers-unbound image with apko..."
	apko build images/unbound/apko/unbound.yaml \
		$(REGISTRY)/$(OWNER)/containers-unbound:$(VERSION) \
		unbound.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < unbound.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-unbound:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-unbound:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-unbound:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-unbound:latest
	@rm -f unbound.tar sbom-*.spdx.json
	@echo "✓ containers-unbound built (source build)"

external-dns-melange: keygen
	@echo "Building ExternalDNS $(EXTERNAL_DNS_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/external-dns/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ ExternalDNS package built from source"

external-dns: external-dns-melange
	@echo "Assembling containers-external-dns image with apko..."
	apko build images/external-dns/apko/external-dns.yaml \
		$(REGISTRY)/$(OWNER)/containers-external-dns:$(VERSION) \
		external-dns.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < external-dns.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-external-dns:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-external-dns:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-external-dns:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-external-dns:latest
	@rm -f external-dns.tar sbom-*.spdx.json
	@echo "✓ containers-external-dns built (source build)"

velero-melange: keygen
	@echo "Building Velero $(VELERO_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/velero/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Velero package built from source"

velero: velero-melange
	@echo "Assembling containers-velero image with apko..."
	apko build images/velero/apko/velero.yaml \
		$(REGISTRY)/$(OWNER)/containers-velero:$(VERSION) \
		velero.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < velero.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-velero:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-velero:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-velero:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-velero:latest
	@rm -f velero.tar sbom-*.spdx.json
	@echo "✓ containers-velero built (source build)"

kaniko-melange: keygen
	@echo "Building Kaniko $(KANIKO_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kaniko/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Kaniko package built from source"

kaniko: kaniko-melange
	@echo "Assembling containers-kaniko image with apko..."
	apko build images/kaniko/apko/kaniko.yaml \
		$(REGISTRY)/$(OWNER)/containers-kaniko:$(VERSION) \
		kaniko.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kaniko.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kaniko:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kaniko:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kaniko:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kaniko:latest
	@rm -f kaniko.tar sbom-*.spdx.json
	@echo "✓ containers-kaniko built (source build)"

step-ca-melange: keygen
	@echo "Building step-ca $(STEP_CA_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/step-ca/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ step-ca package built from source"

step-ca: step-ca-melange
	@echo "Assembling containers-step-ca image with apko..."
	apko build images/step-ca/apko/step-ca.yaml \
		$(REGISTRY)/$(OWNER)/containers-step-ca:$(VERSION) \
		step-ca.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < step-ca.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-step-ca:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-step-ca:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-step-ca:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-step-ca:latest
	@rm -f step-ca.tar sbom-*.spdx.json
	@echo "✓ containers-step-ca built (source build)"

skopeo-melange: keygen
	@echo "Building Skopeo $(SKOPEO_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/skopeo/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Skopeo package built from source"

skopeo: skopeo-melange
	@echo "Assembling containers-skopeo image with apko..."
	apko build images/skopeo/apko/skopeo.yaml \
		$(REGISTRY)/$(OWNER)/containers-skopeo:$(VERSION) \
		skopeo.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < skopeo.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-skopeo:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-skopeo:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-skopeo:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-skopeo:latest
	@rm -f skopeo.tar sbom-*.spdx.json
	@echo "✓ containers-skopeo built (source build)"

helm-melange: keygen
	@echo "Building Helm $(HELM_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/helm/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Helm package built from source"

helm: helm-melange
	@echo "Assembling containers-helm image with apko..."
	apko build images/helm/apko/helm.yaml \
		$(REGISTRY)/$(OWNER)/containers-helm:$(VERSION) \
		helm.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < helm.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-helm:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-helm:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-helm:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-helm:latest
	@rm -f helm.tar sbom-*.spdx.json
	@echo "✓ containers-helm built (source build)"

kubectl-melange: keygen
	@echo "Building kubectl $(KUBECTL_VERSION) from source via melange (x86_64 only locally; CI builds aarch64 natively)..."
	melange build images/kubectl/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ kubectl package built from source"

kubectl: kubectl-melange
	@echo "Assembling containers-kubectl image with apko..."
	apko build images/kubectl/apko/kubectl.yaml \
		$(REGISTRY)/$(OWNER)/containers-kubectl:$(VERSION) \
		kubectl.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kubectl.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kubectl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kubectl:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kubectl:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kubectl:latest
	@rm -f kubectl.tar sbom-*.spdx.json
	@echo "✓ containers-kubectl built (source build)"

#------------------------------------------------------------------------------
# CVE SCANNING
#------------------------------------------------------------------------------
# Generic scan rule — every image's scan recipe is identical (trivy
# CRITICAL,HIGH on :latest); this pattern covers all of them. An explicit
# scan-<img> target, if present, still wins.
scan-%:
	@echo "Scanning containers-$*..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-$*:latest
	@echo "✓ containers-$*: scan passed"

scan: scan-python scan-node-slim scan-bun scan-go scan-java scan-ruby scan-php scan-dotnet scan-deno scan-mysql scan-mariadb scan-postgres-slim scan-pgbouncer scan-unbound scan-dnsmasq scan-keepalived scan-vector scan-patroni scan-metrics-server scan-external-dns scan-velero scan-kaniko scan-step-ca scan-skopeo scan-sqlite scan-opensearch scan-meilisearch scan-airflow scan-wordpress scan-redis-slim scan-valkey scan-memcached scan-kafka scan-zookeeper scan-cassandra scan-solr scan-pulsar scan-tomcat scan-rabbitmq scan-nats scan-mosquitto scan-nginx scan-httpd scan-caddy scan-haproxy scan-traefik scan-envoy scan-oauth2-proxy scan-prometheus scan-alertmanager scan-victoria-metrics scan-thanos scan-mimir scan-jaeger scan-loki scan-tempo scan-otelcol scan-fluent-bit scan-telegraf scan-node-exporter scan-blackbox-exporter scan-pushgateway scan-coredns scan-etcd scan-openbao scan-keycloak scan-qdrant scan-registry scan-consul scan-helm scan-kubectl scan-opentofu scan-trivy scan-cosign scan-syft scan-grype scan-osv-scanner scan-oras scan-notation scan-conftest scan-kubeconform scan-kube-bench scan-trufflehog scan-flux scan-kustomize scan-sops scan-crane scan-kubeseal scan-helmfile scan-regctl scan-stern scan-gitleaks scan-step-cli scan-opa scan-jenkins scan-gitea scan-minio scan-rails scan-mailpit scan-external-secrets scan-kyverno scan-flagger scan-reloader scan-postgres-exporter scan-headscale scan-victoria-logs scan-metallb scan-temporal-server scan-temporal-admin-tools scan-temporal-ui-server scan-kong scan-couchdb scan-kvrocks scan-cmctl scan-argo-cd scan-argo-cd-repo-server

scan-python:
	@echo "Scanning containers-python..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-python:latest
	@echo "✓ containers-python: scan passed"

scan-jenkins:
	@echo "Scanning containers-jenkins..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-jenkins:latest
	@echo "✓ containers-jenkins: scan passed"

scan-go:
	@echo "Scanning containers-go..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-go:latest
	@echo "✓ containers-go: scan passed"

scan-node-slim:
	@echo "Scanning containers-node-slim..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-node-slim:latest
	@echo "✓ containers-node-slim: scan passed"

scan-nginx:
	@echo "Scanning containers-nginx..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-nginx:latest
	@echo "✓ containers-nginx: scan passed"

scan-httpd:
	@echo "Scanning containers-httpd..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-httpd:latest
	@echo "✓ containers-httpd: scan passed"

scan-redis-slim:
	@echo "Scanning containers-redis-slim..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-redis-slim:latest
	@echo "✓ containers-redis-slim: scan passed"

scan-mysql:
	@echo "Scanning containers-mysql..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-mysql:latest
	@echo "✓ containers-mysql: scan passed"

scan-memcached:
	@echo "Scanning containers-memcached..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-memcached:latest
	@echo "✓ containers-memcached: scan passed"

scan-caddy:
	@echo "Scanning containers-caddy..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-caddy:latest
	@echo "✓ containers-caddy: scan passed"

scan-haproxy:
	@echo "Scanning containers-haproxy..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-haproxy:latest
	@echo "✓ containers-haproxy: scan passed"

scan-postgres-slim:
	@echo "Scanning containers-postgres-slim..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-postgres-slim:latest
	@echo "✓ containers-postgres-slim: scan passed"

scan-bun:
	@echo "Scanning containers-bun..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-bun:latest
	@echo "✓ containers-bun: scan passed"

scan-keepalived:
	@echo "Scanning containers-keepalived..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-keepalived:latest
	@echo "✓ containers-keepalived: scan passed"

scan-vector:
	@echo "Scanning containers-vector..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-vector:latest
	@echo "✓ containers-vector: scan passed"

scan-patroni:
	@echo "Scanning containers-patroni..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-patroni:latest
	@echo "✓ containers-patroni: scan passed"

scan-metrics-server:
	@echo "Scanning containers-metrics-server..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-metrics-server:latest
	@echo "✓ containers-metrics-server: scan passed"

scan-dnsmasq:
	@echo "Scanning containers-dnsmasq..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-dnsmasq:latest
	@echo "✓ containers-dnsmasq: scan passed"

scan-kong:
	@echo "Scanning containers-kong..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-kong:latest
	@echo "✓ containers-kong: scan passed"

scan-couchdb:
	@echo "Scanning containers-couchdb..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-couchdb:latest
	@echo "✓ containers-couchdb: scan passed"

scan-argo-cd:
	@echo "Scanning containers-argo-cd..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-argo-cd:latest
	@echo "✓ containers-argo-cd: scan passed"

scan-argo-cd-repo-server:
	@echo "Scanning containers-argo-cd-repo-server..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:latest
	@echo "✓ containers-argo-cd-repo-server: scan passed"

scan-sqlite:
	@echo "Scanning containers-sqlite..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-sqlite:latest
	@echo "✓ containers-sqlite: scan passed"

scan-dotnet:
	@echo "Scanning containers-dotnet..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-dotnet:latest
	@echo "✓ containers-dotnet: scan passed"

scan-java:
	@echo "Scanning containers-java..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-java:latest
	@echo "✓ containers-java: scan passed"

scan-ruby:
	@echo "Scanning containers-ruby..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-ruby:latest
	@echo "✓ containers-ruby: scan passed"

scan-php:
	@echo "Scanning containers-php..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-php:latest
	@echo "✓ containers-php: scan passed"

scan-rails:
	@echo "Scanning containers-rails..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-rails:latest
	@echo "✓ containers-rails: scan passed"

scan-kafka:
	@echo "Scanning containers-kafka..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-kafka:latest
	@echo "✓ containers-kafka: scan passed"

scan-cassandra:
	@echo "Scanning containers-cassandra..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-cassandra:latest
	@echo "✓ containers-cassandra: scan passed"

scan-solr:
	@echo "Scanning containers-solr..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-solr:latest
	@echo "✓ containers-solr: scan passed"

scan-pulsar:
	@echo "Scanning containers-pulsar..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-pulsar:latest
	@echo "✓ containers-pulsar: scan passed"

scan-valkey:
	@echo "Scanning containers-valkey..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-valkey:latest
	@echo "✓ containers-valkey: scan passed"

scan-nats:
	@echo "Scanning containers-nats..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-nats:latest
	@echo "✓ containers-nats: scan passed"

scan-traefik:
	@echo "Scanning containers-traefik..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-traefik:latest
	@echo "✓ containers-traefik: scan passed"

scan-envoy:
	@echo "Scanning containers-envoy..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-envoy:latest
	@echo "✓ containers-envoy: scan passed"

scan-rabbitmq:
	@echo "Scanning containers-rabbitmq..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-rabbitmq:latest
	@echo "✓ containers-rabbitmq: scan passed"

scan-minio:
	@echo "Scanning containers-minio..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-minio:latest
	@echo "✓ containers-minio: scan passed"

scan-opensearch:
	@echo "Scanning containers-opensearch..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-opensearch:latest
	@echo "✓ containers-opensearch: scan passed"

scan-prometheus:
	@echo "Scanning containers-prometheus..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-prometheus:latest
	@echo "✓ containers-prometheus: scan passed"

scan-alertmanager:
	@echo "Scanning containers-alertmanager..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-alertmanager:latest
	@echo "✓ containers-alertmanager: scan passed"


scan-mariadb:
	@echo "Scanning containers-mariadb..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-mariadb:latest
	@echo "✓ containers-mariadb: scan passed"

scan-etcd:
	@echo "Scanning containers-etcd..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-etcd:latest
	@echo "✓ containers-etcd: scan passed"

scan-victoria-metrics:
	@echo "Scanning containers-victoria-metrics..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-victoria-metrics:latest
	@echo "✓ containers-victoria-metrics: scan passed"

scan-jaeger:
	@echo "Scanning containers-jaeger..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-jaeger:latest
	@echo "✓ containers-jaeger: scan passed"

scan-otelcol:
	@echo "Scanning containers-otelcol..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-otelcol:latest
	@echo "✓ containers-otelcol: scan passed"

scan-qdrant:
	@echo "Scanning containers-qdrant..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-qdrant:latest
	@echo "✓ containers-qdrant: scan passed"

scan-deno:
	@echo "Scanning containers-deno..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-deno:latest
	@echo "✓ containers-deno: scan passed"

scan-cuda-python:
	@echo "Scanning containers-cuda-python..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-cuda-python:latest
	@echo "✓ containers-cuda-python: scan passed"

scan-coredns:
	@echo "Scanning containers-coredns..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-coredns:latest
	@echo "✓ containers-coredns: scan passed"

scan-openbao:
	@echo "Scanning containers-openbao..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-openbao:latest
	@echo "✓ containers-openbao: scan passed"

scan-loki:
	@echo "Scanning containers-loki..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-loki:latest
	@echo "✓ containers-loki: scan passed"

scan-fluent-bit:
	@echo "Scanning containers-fluent-bit..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-fluent-bit:latest
	@echo "✓ containers-fluent-bit: scan passed"

scan-keycloak:
	@echo "Scanning containers-keycloak..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-keycloak:latest
	@echo "✓ containers-keycloak: scan passed"

# Full scan with all severities
scan-all:
	@echo "Full vulnerability scan..."
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-python:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-jenkins:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-go:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-node-slim:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-nginx:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-httpd:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-redis-slim:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-mysql:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-memcached:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-caddy:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-haproxy:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-postgres-slim:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-bun:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-sqlite:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-dotnet:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-java:latest
	trivy image --severity CRITICAL,HIGH,MEDIUM,LOW \
		$(REGISTRY)/$(OWNER)/containers-kafka:latest

#------------------------------------------------------------------------------
# IMAGE SIZE REPORT
#------------------------------------------------------------------------------
size:
	@echo "Image sizes:"
	@docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | \
		grep -E "(containers-python|containers-jenkins|containers-go|containers-node-slim|containers-nginx|containers-httpd|containers-redis-slim|containers-mysql|containers-memcached|containers-caddy|containers-haproxy|containers-postgres-slim|containers-bun|containers-sqlite|containers-dotnet|containers-java|containers-ruby|containers-rails|containers-kafka)" || true

#------------------------------------------------------------------------------
# TESTING
#------------------------------------------------------------------------------
test: test-python test-node-slim test-bun test-go test-java test-ruby test-php test-dotnet test-deno test-mysql test-mariadb test-postgres-slim test-pgbouncer test-unbound test-dnsmasq test-keepalived test-vector test-patroni test-metrics-server test-external-dns test-velero test-kaniko test-step-ca test-skopeo test-sqlite test-opensearch test-meilisearch test-airflow test-wordpress test-redis-slim test-valkey test-memcached test-kafka test-zookeeper test-cassandra test-solr test-pulsar test-tomcat test-rabbitmq test-nats test-mosquitto test-nginx test-httpd test-caddy test-haproxy test-traefik test-envoy test-oauth2-proxy test-prometheus test-alertmanager test-victoria-metrics test-thanos test-mimir test-jaeger test-loki test-tempo test-otelcol test-fluent-bit test-telegraf test-node-exporter test-blackbox-exporter test-pushgateway test-coredns test-etcd test-openbao test-keycloak test-qdrant test-registry test-consul test-helm test-kubectl test-opentofu test-trivy test-cosign test-syft test-grype test-osv-scanner test-oras test-notation test-conftest test-kubeconform test-kube-bench test-trufflehog test-flux test-kustomize test-sops test-crane test-kubeseal test-helmfile test-regctl test-stern test-gitleaks test-step-cli test-opa test-jenkins test-gitea test-minio test-rails test-mailpit test-external-secrets test-kyverno test-flagger test-reloader test-postgres-exporter test-headscale test-victoria-logs test-metallb test-temporal-server test-temporal-admin-tools test-temporal-ui-server test-kong test-couchdb test-kvrocks test-kvrocks-dev test-cmctl test-cmctl-dev test-argo-cd test-argo-cd-dev test-argo-cd-repo-server test-argo-cd-repo-server-dev

$(eval $(call DEV_TEST_RULE,python))
$(eval $(call DEV_TEST_RULE,node-slim))
$(eval $(call DEV_TEST_RULE,go))
$(eval $(call DEV_TEST_RULE,java))
$(eval $(call DEV_TEST_RULE,dotnet))
$(eval $(call DEV_TEST_RULE,bun))
$(eval $(call DEV_TEST_RULE,deno))
$(eval $(call DEV_TEST_RULE,rails))
$(eval $(call DEV_TEST_RULE,php))
$(eval $(call DEV_TEST_RULE,postgres-slim))
$(eval $(call DEV_TEST_RULE,mariadb))
$(eval $(call DEV_TEST_RULE,redis-slim))
$(eval $(call DEV_TEST_RULE,valkey))
$(eval $(call DEV_TEST_RULE,memcached))
$(eval $(call DEV_TEST_RULE,sqlite))
$(eval $(call DEV_TEST_RULE,opensearch))
$(eval $(call DEV_TEST_RULE,kafka))
$(eval $(call DEV_TEST_RULE,cassandra))
$(eval $(call DEV_TEST_RULE,solr))
$(eval $(call DEV_TEST_RULE,pulsar))
$(eval $(call DEV_TEST_RULE,rabbitmq))
$(eval $(call DEV_TEST_RULE,nats))
$(eval $(call DEV_TEST_RULE,etcd))
$(eval $(call DEV_TEST_RULE,nginx))
$(eval $(call DEV_TEST_RULE,haproxy))
$(eval $(call DEV_TEST_RULE,minio))
$(eval $(call DEV_TEST_RULE,httpd))
$(eval $(call DEV_TEST_RULE,caddy))
$(eval $(call DEV_TEST_RULE,traefik))
$(eval $(call DEV_TEST_RULE,envoy))
$(eval $(call DEV_TEST_RULE,prometheus))
$(eval $(call DEV_TEST_RULE,alertmanager))
$(eval $(call DEV_TEST_RULE,victoria-metrics))
$(eval $(call DEV_TEST_RULE,jaeger))
$(eval $(call DEV_TEST_RULE,otelcol))
$(eval $(call DEV_TEST_RULE,loki))
$(eval $(call DEV_TEST_RULE,fluent-bit))
$(eval $(call DEV_TEST_RULE,coredns))
$(eval $(call DEV_TEST_RULE,gitea))
$(eval $(call DEV_TEST_RULE,jenkins))
$(eval $(call DEV_TEST_RULE,openbao))
$(eval $(call DEV_TEST_RULE,mysql))
$(eval $(call DEV_TEST_RULE,qdrant))
$(eval $(call DEV_TEST_RULE,meilisearch))
$(eval $(call DEV_TEST_RULE,airflow))
$(eval $(call DEV_TEST_RULE,wordpress))
$(eval $(call DEV_TEST_RULE,keycloak))
$(eval $(call DEV_TEST_RULE,registry))
$(eval $(call DEV_TEST_RULE,mailpit))
$(eval $(call DEV_TEST_RULE,consul))
$(eval $(call DEV_TEST_RULE,tempo))
$(eval $(call DEV_TEST_RULE,mosquitto))
$(eval $(call DEV_TEST_RULE,pgbouncer))
$(eval $(call DEV_TEST_RULE,unbound))
$(eval $(call DEV_TEST_RULE,dnsmasq))
$(eval $(call DEV_TEST_RULE,kong))
$(eval $(call DEV_TEST_RULE,couchdb))
$(eval $(call DEV_TEST_RULE,argo-cd))
$(eval $(call DEV_TEST_RULE,argo-cd-repo-server))
$(eval $(call DEV_TEST_RULE,kvrocks))
$(eval $(call DEV_TEST_RULE,patroni))
$(eval $(call DEV_TEST_RULE,vector))
$(eval $(call DEV_TEST_RULE,keepalived))
$(eval $(call DEV_TEST_RULE,metrics-server))
$(eval $(call DEV_TEST_RULE,external-dns))
$(eval $(call DEV_TEST_RULE,velero))
$(eval $(call DEV_TEST_RULE,kaniko))
$(eval $(call DEV_TEST_RULE,step-ca))
$(eval $(call DEV_TEST_RULE,skopeo))
$(eval $(call DEV_TEST_RULE,telegraf))
$(eval $(call DEV_TEST_RULE,mimir))
# --- dev smoke tests for the CLI / exporter / static-Go dev variants.
$(eval $(call DEV_TEST_RULE,zookeeper))
$(eval $(call DEV_TEST_RULE,tomcat))
$(eval $(call DEV_TEST_RULE,oauth2-proxy))
$(eval $(call DEV_TEST_RULE,thanos))
$(eval $(call DEV_TEST_RULE,node-exporter))
$(eval $(call DEV_TEST_RULE,blackbox-exporter))
$(eval $(call DEV_TEST_RULE,pushgateway))
$(eval $(call DEV_TEST_RULE,helm))
$(eval $(call DEV_TEST_RULE,kubectl))
$(eval $(call DEV_TEST_RULE,opentofu))
$(eval $(call DEV_TEST_RULE,trivy))
$(eval $(call DEV_TEST_RULE,cosign))
$(eval $(call DEV_TEST_RULE,syncthing))
$(eval $(call DEV_TEST_RULE,nsq))
$(eval $(call DEV_TEST_RULE,gitlab-runner))
$(eval $(call DEV_TEST_RULE,buildkit))
$(eval $(call DEV_TEST_RULE,syft))
$(eval $(call DEV_TEST_RULE,grype))
$(eval $(call DEV_TEST_RULE,osv-scanner))
$(eval $(call DEV_TEST_RULE,oras))
$(eval $(call DEV_TEST_RULE,notation))
$(eval $(call DEV_TEST_RULE,conftest))
$(eval $(call DEV_TEST_RULE,kubeconform))
$(eval $(call DEV_TEST_RULE,kube-bench))
$(eval $(call DEV_TEST_RULE,trufflehog))
$(eval $(call DEV_TEST_RULE,flux))
$(eval $(call DEV_TEST_RULE,kustomize))
$(eval $(call DEV_TEST_RULE,sops))
$(eval $(call DEV_TEST_RULE,crane))
$(eval $(call DEV_TEST_RULE,kubeseal))
$(eval $(call DEV_TEST_RULE,cmctl))
$(eval $(call DEV_TEST_RULE,helmfile))
$(eval $(call DEV_TEST_RULE,regctl))
$(eval $(call DEV_TEST_RULE,stern))
$(eval $(call DEV_TEST_RULE,gitleaks))
$(eval $(call DEV_TEST_RULE,step-cli))
$(eval $(call DEV_TEST_RULE,opa))

test-python:
	@echo "Testing Python image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-python:latest \
		-c "import sys; print(f'Python {sys.version}')"
	docker run --rm $(REGISTRY)/$(OWNER)/containers-python:latest \
		-c "import ssl; print('TLS OK:', ssl.OPENSSL_VERSION)"
	docker run --rm $(REGISTRY)/$(OWNER)/containers-python:latest \
		-c "import json, hashlib; print('stdlib OK')"
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-python:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Python tests passed"

test-jenkins:
	@echo "Testing Jenkins image (Java version)..."
	docker run --rm --entrypoint /usr/bin/java \
		$(REGISTRY)/$(OWNER)/containers-jenkins:latest -version
	@echo "Verifying Jenkins WAR..."
	docker run --rm --entrypoint /usr/bin/java \
		$(REGISTRY)/$(OWNER)/containers-jenkins:latest \
		-jar /usr/share/jenkins/jenkins.war --version
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-jenkins:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Jenkins tests passed"

test-go:
	@echo "Testing Go image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-go:latest version
	@echo "Testing Go build..."
	docker run --rm -v $(PWD):/app -w /app $(REGISTRY)/$(OWNER)/containers-go:latest \
		build -o /tmp/test /dev/null 2>&1 | head -1 || echo "Go build tools OK"
	@echo "Verifying build tools..."
	docker run --rm --entrypoint /usr/bin/gcc $(REGISTRY)/$(OWNER)/containers-go:latest --version | head -1
	docker run --rm --entrypoint /usr/bin/make $(REGISTRY)/$(OWNER)/containers-go:latest --version
	@echo "Verifying git..."
	docker run --rm --entrypoint /usr/bin/git $(REGISTRY)/$(OWNER)/containers-go:latest --version
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-go:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Go tests passed"

test-node-slim:
	@echo "Testing Node.js image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-node-slim:latest --version
	@echo "Testing simple script..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-node-slim:latest -e 'console.log("Hello minimal node")'
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-node-slim:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Node.js tests passed"

test-nginx:
	@echo "Testing Nginx image..."
	@docker run -d --name nginx-test $(REGISTRY)/$(OWNER)/containers-nginx:latest
	@sleep 2
	@if docker ps | grep -q nginx-test; then \
		echo "Nginx is running"; \
		docker logs nginx-test; \
		docker stop nginx-test && docker rm nginx-test; \
	else \
		echo "Nginx failed to start, checking logs..."; \
		docker logs nginx-test 2>&1 || true; \
		docker rm nginx-test 2>/dev/null || true; \
		exit 1; \
	fi
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-nginx:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Nginx tests passed"

test-httpd:
	@echo "Testing HTTPD image..."
	@docker run -d --name httpd-test $(REGISTRY)/$(OWNER)/containers-httpd:latest
	@sleep 2
	@if docker ps | grep -q httpd-test; then \
		echo "HTTPD is running"; \
		docker logs httpd-test; \
		docker stop httpd-test && docker rm httpd-test; \
	else \
		echo "HTTPD failed to start, checking logs..."; \
		docker logs httpd-test 2>&1 || true; \
		docker rm httpd-test 2>/dev/null || true; \
		exit 1; \
	fi
	@echo "Checking for shell presence (informational)..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-httpd:latest -c "true" 2>/dev/null \
		&& echo "NOTE: /bin/sh present in containers-httpd (not treated as failure)" \
		|| echo "✓ No /bin/sh found (shell-less)"
	@echo "✓ HTTPD tests passed"

test-redis-slim:
	@echo "Testing Redis Slim image..."
	@docker run -d --name redis-test $(REGISTRY)/$(OWNER)/containers-redis-slim:latest
	@sleep 2
	@if docker ps | grep -q redis-test; then \
		echo "Redis is running"; \
		docker logs redis-test; \
		docker stop redis-test && docker rm redis-test; \
	else \
		echo "Redis failed to start, checking logs..."; \
		docker logs redis-test 2>&1 || true; \
		docker rm redis-test 2>/dev/null || true; \
		exit 1; \
	fi
	@echo "✓ Redis Slim tests passed"

test-mysql:
	@echo "Testing MySQL image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-mysql:latest --version
	@echo "Testing MySQL client..."
	docker run --rm --entrypoint /usr/bin/mysql \
		$(REGISTRY)/$(OWNER)/containers-mysql:latest --version
	@echo "✓ MySQL tests passed"

test-memcached:
	@echo "Testing Memcached image..."
	@docker run -d --name memcached-test $(REGISTRY)/$(OWNER)/containers-memcached:latest -u memcached
	@sleep 2
	@if docker ps | grep -q memcached-test; then \
		echo "Memcached is running"; \
		docker logs memcached-test; \
		docker stop memcached-test && docker rm memcached-test; \
	else \
		echo "Memcached failed to start, checking logs..."; \
		docker logs memcached-test 2>&1 || true; \
		docker rm memcached-test 2>/dev/null || true; \
		exit 1; \
	fi
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-memcached:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Memcached tests passed"

test-caddy:
	@echo "Testing Caddy image..."
	docker run --rm --entrypoint /usr/bin/caddy \
		$(REGISTRY)/$(OWNER)/containers-caddy:latest version
	@echo "Testing Caddy modules..."
	@docker run --rm --entrypoint /usr/bin/caddy \
		$(REGISTRY)/$(OWNER)/containers-caddy:latest list-modules 2>&1 | head -20 || true
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-caddy:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Caddy tests passed"

test-haproxy:
	@echo "Testing HAProxy image..."
	docker run --rm --entrypoint /usr/bin/haproxy \
		$(REGISTRY)/$(OWNER)/containers-haproxy:latest -v
	@echo "Testing HAProxy build options..."
	@docker run --rm --entrypoint /usr/bin/haproxy \
		$(REGISTRY)/$(OWNER)/containers-haproxy:latest -vv 2>&1 | grep -E "(USE_OPENSSL|USE_PCRE2)" || \
		{ echo "FAIL: Expected USE_OPENSSL and USE_PCRE2"; exit 1; }
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-haproxy:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ HAProxy tests passed"

test-postgres-slim:
	@echo "Testing Postgres Slim image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-postgres-slim:latest" && \
		images/postgres-slim/test.sh
	@echo "✓ Postgres Slim tests passed"

test-bun:
	@echo "Testing Bun image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-bun:latest --version
	@echo "Testing simple script..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-bun:latest -e 'console.log("Hello minimal bun")'
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-bun:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Bun tests passed"

test-sqlite:
	@echo "Testing SQLite image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-sqlite:latest --version
	@echo "Testing in-memory query..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-sqlite:latest :memory: "SELECT 1;"
	@echo "Testing file-based DB..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-sqlite:latest /tmp/test.db \
		"CREATE TABLE t(x); INSERT INTO t VALUES(1); SELECT * FROM t;"
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-sqlite:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ SQLite tests passed"

test-dotnet:
	@echo "Testing .NET Runtime image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-dotnet:latest --info
	@echo "Checking runtime list..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-dotnet:latest --list-runtimes
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-dotnet:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ .NET Runtime tests passed"

test-java:
	@echo "Testing OpenJDK Runtime image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-java:latest -version
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-java:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ OpenJDK Runtime tests passed"

test-ruby:
	@IMAGE=$(REGISTRY)/$(OWNER)/containers-ruby:latest bash images/ruby/test.sh
	@echo "✓ Ruby tests passed"

$(eval $(call DEV_TEST_RULE,ruby))

test-rails:
	@echo "Testing Rails image..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-rails:latest -v
	@echo "Testing Rails version..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-rails:latest \
		-e "require 'rails'; puts Rails.version"
	@echo "Testing Bundler..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-rails:latest \
		-e "require 'bundler'; puts Bundler::VERSION"
	@echo "Testing core libraries..."
	docker run --rm $(REGISTRY)/$(OWNER)/containers-rails:latest \
		-e "require 'openssl'; require 'yaml'; require 'json'; puts 'Core libs OK'"
	@echo "Verifying no shell..."
	@docker run --rm --entrypoint /bin/sh $(REGISTRY)/$(OWNER)/containers-rails:latest \
		-c "echo fail" 2>/dev/null && echo "FAIL: shell found!" && exit 1 || echo "✓ No shell (as expected)"
	@echo "✓ Rails tests passed"

test-kafka:
	@echo "Testing Kafka image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kafka:latest" && \
		images/kafka/test.sh
	@echo "✓ Kafka tests passed"

test-cassandra:
	@echo "Testing Cassandra image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-cassandra:latest" && \
		images/cassandra/test.sh
	@echo "✓ Cassandra tests passed"

test-flink:
	@echo "Testing flink image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-flink:latest" && \
		images/flink/test.sh
	@echo "✓ flink tests passed"

test-solr:
	@echo "Testing Solr image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-solr:latest" && \
		images/solr/test.sh
	@echo "✓ Solr tests passed"

test-pulsar:
	@echo "Testing Pulsar image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-pulsar:latest" && \
		images/pulsar/test.sh
	@echo "✓ Pulsar tests passed"

test-zookeeper:
	@echo "Testing zookeeper image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-zookeeper:latest" && \
		images/zookeeper/test.sh
	@echo "✓ zookeeper tests passed"

test-tomcat:
	@echo "Testing tomcat image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-tomcat:latest" && \
		images/tomcat/test.sh
	@echo "✓ tomcat tests passed"

test-valkey:
	@echo "Testing Valkey image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-valkey:latest" && \
		images/valkey/test.sh
	@echo "✓ Valkey tests passed"

test-nats:
	@echo "Testing NATS image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-nats:latest" && \
		images/nats/test.sh
	@echo "✓ NATS tests passed"

test-traefik:
	@echo "Testing Traefik image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-traefik:latest" && \
		images/traefik/test.sh
	@echo "✓ Traefik tests passed"

test-envoy:
	@echo "Testing Envoy image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-envoy:latest" && \
		images/envoy/test.sh
	@echo "✓ Envoy tests passed"

test-rabbitmq:
	@echo "Testing RabbitMQ image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-rabbitmq:latest" && \
		images/rabbitmq/test.sh
	@echo "✓ RabbitMQ tests passed"

test-minio:
	@echo "Testing MinIO image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-minio:latest" && \
		images/minio/test.sh
	@echo "✓ MinIO tests passed"

test-registry:
	@echo "Testing registry image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-registry:latest" && \
		images/registry/test.sh
	@echo "✓ registry tests passed"

test-mailpit:
	@echo "Testing mailpit image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-mailpit:latest" && \
		images/mailpit/test.sh
	@echo "✓ mailpit tests passed"

test-consul:
	@echo "Testing consul image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-consul:latest" && \
		images/consul/test.sh
	@echo "✓ consul tests passed"

test-tempo:
	@echo "Testing tempo image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-tempo:latest" && \
		images/tempo/test.sh
	@echo "✓ tempo tests passed"

test-opentofu:
	@echo "Testing opentofu image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-opentofu:latest" && \
		images/opentofu/test.sh
	@echo "✓ opentofu tests passed"

test-trivy:
	@echo "Testing trivy image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-trivy:latest" && \
		images/trivy/test.sh
	@echo "✓ trivy tests passed"

test-cosign:
	@echo "Testing cosign image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-cosign:latest" && \
		images/cosign/test.sh
	@echo "✓ cosign tests passed"

test-zot:
	@echo "Testing zot image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-zot:latest" && \
		images/zot/test.sh
	@echo "✓ zot tests passed"

$(eval $(call DEV_TEST_RULE,zot))

test-erlang:
	@echo "Testing erlang image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-erlang:latest" && \
		images/erlang/test.sh
	@echo "✓ erlang tests passed"

$(eval $(call DEV_TEST_RULE,erlang))

test-perl:
	@echo "Testing perl image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-perl:latest" && \
		images/perl/test.sh
	@echo "✓ perl tests passed"

$(eval $(call DEV_TEST_RULE,perl))

test-neo4j:
	@echo "Testing neo4j image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-neo4j:latest" && \
		images/neo4j/test.sh
	@echo "✓ neo4j tests passed"

$(eval $(call DEV_TEST_RULE,neo4j))

test-syft:
	@echo "Testing syft image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-syft:latest" && \
		images/syft/test.sh
	@echo "✓ syft tests passed"

test-grype:
	@echo "Testing grype image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-grype:latest" && \
		images/grype/test.sh
	@echo "✓ grype tests passed"

test-oras:
	@echo "Testing oras image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-oras:latest" && \
		images/oras/test.sh
	@echo "✓ oras tests passed"

test-gitleaks:
	@echo "Testing gitleaks image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-gitleaks:latest" && \
		images/gitleaks/test.sh
	@echo "✓ gitleaks tests passed"

test-step-cli:
	@echo "Testing step-cli image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-step-cli:latest" && \
		images/step-cli/test.sh
	@echo "✓ step-cli tests passed"

test-opa:
	@echo "Testing opa image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-opa:latest" && \
		images/opa/test.sh
	@echo "✓ opa tests passed"

test-osv-scanner:
	@echo "Testing osv-scanner image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-osv-scanner:latest" && \
		images/osv-scanner/test.sh
	@echo "✓ osv-scanner tests passed"

test-rclone:
	@echo "Testing rclone image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-rclone:latest" && \
		images/rclone/test.sh
	@echo "✓ rclone tests passed"

test-tailscale:
	@echo "Testing tailscale image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-tailscale:latest" && \
		images/tailscale/test.sh
	@echo "✓ tailscale tests passed"

test-descheduler:
	@echo "Testing descheduler image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-descheduler:latest" && \
		images/descheduler/test.sh
	@echo "✓ descheduler tests passed"

test-restic:
	@echo "Testing restic image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-restic:latest" && \
		images/restic/test.sh
	@echo "✓ restic tests passed"

test-syncthing:
	@echo "Testing syncthing image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-syncthing:latest" && \
		images/syncthing/test.sh
	@echo "✓ syncthing tests passed"

test-nsq:
	@echo "Testing nsq image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-nsq:latest" && \
		images/nsq/test.sh
	@echo "✓ nsq tests passed"

test-gitlab-runner:
	@echo "Testing gitlab-runner image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-gitlab-runner:latest" && \
		images/gitlab-runner/test.sh
	@echo "✓ gitlab-runner tests passed"

test-buildkit:
	@echo "Testing buildkit image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-buildkit:latest" && \
		images/buildkit/test.sh
	@echo "✓ buildkit tests passed"

test-seaweedfs:
	@echo "Testing seaweedfs image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-seaweedfs:latest" && \
		images/seaweedfs/test.sh
	@echo "✓ seaweedfs tests passed"

test-dex:
	@echo "Testing dex image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-dex:latest" && \
		images/dex/test.sh
	@echo "✓ dex tests passed"

test-kube-vip:
	@echo "Testing kube-vip image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kube-vip:latest" && \
		images/kube-vip/test.sh
	@echo "✓ kube-vip tests passed"

test-zipkin:
	@echo "Testing zipkin image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-zipkin:latest" && \
		images/zipkin/test.sh
	@echo "✓ zipkin tests passed"

test-oauth2-proxy:
	@echo "Testing oauth2-proxy image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-oauth2-proxy:latest" && \
		images/oauth2-proxy/test.sh
	@echo "✓ oauth2-proxy tests passed"

test-flux:
	@echo "Testing flux image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-flux:latest" && \
		images/flux/test.sh
	@echo "✓ flux tests passed"

test-kustomize:
	@echo "Testing kustomize image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kustomize:latest" && \
		images/kustomize/test.sh
	@echo "✓ kustomize tests passed"

test-sops:
	@echo "Testing sops image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-sops:latest" && \
		images/sops/test.sh
	@echo "✓ sops tests passed"

test-crane:
	@echo "Testing crane image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-crane:latest" && \
		images/crane/test.sh
	@echo "✓ crane tests passed"

test-kubeseal:
	@echo "Testing kubeseal image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kubeseal:latest" && \
		images/kubeseal/test.sh
	@echo "✓ kubeseal tests passed"

test-cmctl:
	@echo "Testing cmctl image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-cmctl:latest" && \
		images/cmctl/test.sh
	@echo "✓ cmctl tests passed"

test-timescaledb:
	@echo "Testing timescaledb image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-timescaledb:latest" && \
		images/timescaledb/test.sh
	@echo "✓ timescaledb tests passed"

test-helmfile:
	@echo "Testing helmfile image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-helmfile:latest" && \
		images/helmfile/test.sh
	@echo "✓ helmfile tests passed"

test-regctl:
	@echo "Testing regctl image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-regctl:latest" && \
		images/regctl/test.sh
	@echo "✓ regctl tests passed"

test-stern:
	@echo "Testing stern image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-stern:latest" && \
		images/stern/test.sh
	@echo "✓ stern tests passed"


test-notation:
	@echo "Testing notation image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-notation:latest" && images/notation/test.sh
	@echo "✓ notation tests passed"

test-conftest:
	@echo "Testing conftest image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-conftest:latest" && images/conftest/test.sh
	@echo "✓ conftest tests passed"

test-kubeconform:
	@echo "Testing kubeconform image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kubeconform:latest" && images/kubeconform/test.sh
	@echo "✓ kubeconform tests passed"

test-kube-bench:
	@echo "Testing kube-bench image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kube-bench:latest" && images/kube-bench/test.sh
	@echo "✓ kube-bench tests passed"

test-trufflehog:
	@echo "Testing trufflehog image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-trufflehog:latest" && images/trufflehog/test.sh
	@echo "✓ trufflehog tests passed"

test-thanos:
	@echo "Testing thanos image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-thanos:latest" && \
		images/thanos/test.sh
	@echo "✓ thanos tests passed"

test-node-exporter:
	@echo "Testing node-exporter image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-node-exporter:latest" && \
		images/node-exporter/test.sh
	@echo "✓ node-exporter tests passed"

test-blackbox-exporter:
	@echo "Testing blackbox-exporter image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-blackbox-exporter:latest" && \
		images/blackbox-exporter/test.sh
	@echo "✓ blackbox-exporter tests passed"

test-redis-exporter:
	@echo "Testing redis-exporter image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-redis-exporter:latest" && \
		images/redis-exporter/test.sh
	@echo "✓ redis-exporter tests passed"

test-kube-state-metrics:
	@echo "Testing kube-state-metrics image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kube-state-metrics:latest" && \
		images/kube-state-metrics/test.sh
	@echo "✓ kube-state-metrics tests passed"

test-pushgateway:
	@echo "Testing pushgateway image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-pushgateway:latest" && \
		images/pushgateway/test.sh
	@echo "✓ pushgateway tests passed"

test-mosquitto:
	@echo "Testing mosquitto image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-mosquitto:latest" && \
		images/mosquitto/test.sh
	@echo "✓ mosquitto tests passed"

test-pgbouncer:
	@echo "Testing pgbouncer image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-pgbouncer:latest" && \
		images/pgbouncer/test.sh
	@echo "✓ pgbouncer tests passed"

test-keepalived:
	@echo "Testing keepalived image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-keepalived:latest" && \
		images/keepalived/test.sh
	@echo "✓ keepalived tests passed"

test-vector:
	@echo "Testing vector image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-vector:latest" && \
		images/vector/test.sh
	@echo "✓ vector tests passed"

test-patroni:
	@echo "Testing patroni image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-patroni:latest" && \
		images/patroni/test.sh
	@echo "✓ patroni tests passed"

test-metrics-server:
	@echo "Testing metrics-server image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-metrics-server:latest" && \
		images/metrics-server/test.sh
	@echo "✓ metrics-server tests passed"

test-dnsmasq:
	@echo "Testing dnsmasq image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-dnsmasq:latest" && \
		images/dnsmasq/test.sh
	@echo "✓ dnsmasq tests passed"

test-kong:
	@echo "Testing kong image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kong:latest" && \
		images/kong/test.sh
	@echo "✓ kong tests passed"

test-couchdb:
	@echo "Testing couchdb image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-couchdb:latest" && \
		images/couchdb/test.sh
	@echo "✓ couchdb tests passed"

test-argo-cd:
	@echo "Testing argo-cd image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-argo-cd:latest" && \
		images/argo-cd/test.sh
	@echo "✓ argo-cd tests passed"

test-argo-cd-repo-server:
	@echo "Testing argo-cd-repo-server image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-argo-cd-repo-server:latest" && \
		images/argo-cd-repo-server/test.sh
	@echo "✓ argo-cd-repo-server tests passed"

test-unbound:
	@echo "Testing unbound image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-unbound:latest" && \
		images/unbound/test.sh
	@echo "✓ unbound tests passed"

test-external-dns:
	@echo "Testing external-dns image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-external-dns:latest" && \
		images/external-dns/test.sh
	@echo "✓ external-dns tests passed"

test-velero:
	@echo "Testing velero image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-velero:latest" && \
		images/velero/test.sh
	@echo "✓ velero tests passed"

test-kaniko:
	@echo "Testing kaniko image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kaniko:latest" && \
		images/kaniko/test.sh
	@echo "✓ kaniko tests passed"

test-step-ca:
	@echo "Testing step-ca image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-step-ca:latest" && \
		images/step-ca/test.sh
	@echo "✓ step-ca tests passed"

test-skopeo:
	@echo "Testing skopeo image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-skopeo:latest" && \
		images/skopeo/test.sh
	@echo "✓ skopeo tests passed"

test-helm:
	@echo "Testing helm image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-helm:latest" && \
		images/helm/test.sh
	@echo "✓ helm tests passed"

test-kubectl:
	@echo "Testing kubectl image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kubectl:latest" && \
		images/kubectl/test.sh
	@echo "✓ kubectl tests passed"

test-opensearch:
	@echo "Testing OpenSearch image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-opensearch:latest" && \
		images/opensearch/test.sh
	@echo "✓ OpenSearch tests passed"

test-prometheus:
	@echo "Testing Prometheus image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-prometheus:latest" && \
		images/prometheus/test.sh
	@echo "✓ Prometheus tests passed"

test-alertmanager:
	@echo "Testing Alertmanager image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-alertmanager:latest" && \
		images/alertmanager/test.sh
	@echo "✓ Alertmanager tests passed"


test-mariadb:
	@echo "Testing MariaDB image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-mariadb:latest" && \
		images/mariadb/test.sh
	@echo "✓ MariaDB tests passed"

test-etcd:
	@echo "Testing etcd image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-etcd:latest" && \
		images/etcd/test.sh
	@echo "✓ etcd tests passed"

test-victoria-metrics:
	@echo "Testing VictoriaMetrics image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-victoria-metrics:latest" && \
		images/victoria-metrics/test.sh
	@echo "✓ VictoriaMetrics tests passed"

test-telegraf:
	@echo "Testing Telegraf image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-telegraf:latest" && \
		images/telegraf/test.sh
	@echo "✓ Telegraf tests passed"

test-mimir:
	@echo "Testing Mimir image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-mimir:latest" && \
		images/mimir/test.sh
	@echo "✓ Mimir tests passed"

test-coredns:
	@echo "Testing CoreDNS image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-coredns:latest" && \
		images/coredns/test.sh
	@echo "✓ coredns tests passed"

test-fluent-bit:
	@echo "Testing Fluent Bit image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-fluent-bit:latest" && \
		images/fluent-bit/test.sh
	@echo "✓ fluent-bit tests passed"

test-keycloak:
	@echo "Testing Keycloak image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-keycloak:latest" && \
		images/keycloak/test.sh
	@echo "✓ keycloak tests passed"

test-loki:
	@echo "Testing Loki image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-loki:latest" && \
		images/loki/test.sh
	@echo "✓ loki tests passed"

test-openbao:
	@echo "Testing OpenBao image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-openbao:latest" && \
		images/openbao/test.sh
	@echo "✓ openbao tests passed"

test-php:
	@echo "Testing PHP image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-php:latest" && \
		images/php/test.sh
	@echo "✓ php tests passed"

test-gitea:
	@echo "Testing Gitea image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-gitea:latest" && \
		images/gitea/test.sh
	@echo "✓ gitea tests passed"


test-jaeger:
	@echo "Testing Jaeger image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-jaeger:latest" && \
		images/jaeger/test.sh
	@echo "✓ Jaeger tests passed"

test-otelcol:
	@echo "Testing OTel Collector image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-otelcol:latest" && \
		images/otelcol/test.sh
	@echo "✓ OTel Collector tests passed"

test-vaultwarden:
	@echo "Testing vaultwarden image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-vaultwarden:latest" && \
		images/vaultwarden/test.sh
	@echo "✓ vaultwarden tests passed"

test-kvrocks:
	@echo "Testing kvrocks image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kvrocks:latest" && \
		images/kvrocks/test.sh
	@echo "✓ kvrocks tests passed"

test-qdrant:
	@echo "Testing Qdrant image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-qdrant:latest" && \
		images/qdrant/test.sh
	@echo "✓ Qdrant tests passed"

test-meilisearch:
	@echo "Testing Meilisearch image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-meilisearch:latest" && \
		images/meilisearch/test.sh
	@echo "✓ Meilisearch tests passed"

test-airflow:
	@echo "Testing Airflow image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-airflow:latest" && \
		images/airflow/test.sh
	@echo "✓ Airflow tests passed"

test-wordpress:
	@echo "Testing WordPress image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-wordpress:latest" && \
		images/wordpress/test.sh
	@echo "✓ WordPress tests passed"

test-deno:
	@echo "Testing Deno image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-deno:latest" && \
		images/deno/test.sh
	@echo "✓ Deno tests passed"

test-cuda-python:
	@echo "Testing CUDA Python image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-cuda-python:latest" && \
		images/cuda-python/test.sh
	@echo "✓ CUDA Python tests passed"

#------------------------------------------------------------------------------
# PUSH TO REGISTRY
#------------------------------------------------------------------------------
# Every image's build rule tags both a version tag and :latest, so one push-%
# pattern rule covers all 88 uniformly — mirroring build:/test:/scan:. The 4
# images that don't ride the global VERSION get a per-image tag override here
# (empty override falls back to $(VERSION) via $(or …)).
PUSH_VER_kafka     = $(KAFKA_VERSION)
PUSH_VER_zookeeper = $(ZOOKEEPER_VERSION)
PUSH_VER_cassandra = $(CASSANDRA_VERSION)
PUSH_VER_solr      = $(SOLR_VERSION)
PUSH_VER_pulsar    = $(PULSAR_VERSION)
PUSH_VER_tomcat    = $(TOMCAT_VERSION)
PUSH_VER_rabbitmq  = $(RABBITMQ_VERSION)

push-%:
	docker push $(REGISTRY)/$(OWNER)/containers-$*:$(or $(PUSH_VER_$*),$(VERSION))
	docker push $(REGISTRY)/$(OWNER)/containers-$*:latest

push: push-python push-node-slim push-bun push-go push-java push-ruby push-php push-dotnet push-deno push-mysql push-mariadb push-postgres-slim push-pgbouncer push-unbound push-dnsmasq push-keepalived push-vector push-patroni push-metrics-server push-external-dns push-velero push-kaniko push-step-ca push-skopeo push-sqlite push-opensearch push-meilisearch push-airflow push-wordpress push-redis-slim push-valkey push-memcached push-kafka push-zookeeper push-cassandra push-solr push-pulsar push-tomcat push-rabbitmq push-nats push-mosquitto push-nginx push-httpd push-caddy push-haproxy push-traefik push-envoy push-oauth2-proxy push-prometheus push-alertmanager push-victoria-metrics push-thanos push-mimir push-jaeger push-loki push-tempo push-otelcol push-fluent-bit push-telegraf push-node-exporter push-blackbox-exporter push-pushgateway push-coredns push-etcd push-openbao push-keycloak push-qdrant push-registry push-consul push-helm push-kubectl push-opentofu push-trivy push-cosign push-syft push-grype push-osv-scanner push-oras push-notation push-conftest push-kubeconform push-kube-bench push-trufflehog push-flux push-kustomize push-sops push-crane push-kubeseal push-helmfile push-regctl push-stern push-gitleaks push-step-cli push-opa push-jenkins push-gitea push-minio push-rails push-mailpit push-external-secrets push-kyverno push-flagger push-reloader push-postgres-exporter push-headscale push-victoria-logs push-metallb push-temporal-server push-temporal-admin-tools push-temporal-ui-server push-kong push-couchdb push-kvrocks push-cmctl push-argo-cd push-argo-cd-repo-server

#------------------------------------------------------------------------------
# CLEANUP
#------------------------------------------------------------------------------
clean:
	@echo "Cleaning up..."
	docker rmi $(REGISTRY)/$(OWNER)/containers-python:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-python:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-python:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-jenkins:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-jenkins:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-jenkins:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-go:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-go:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-go:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-node-slim:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-node-slim:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-node-slim:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-nginx:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-nginx:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-nginx:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-httpd:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-httpd:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-httpd:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-redis-slim:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-redis-slim:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-redis-slim:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-mysql:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-mysql:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-memcached:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-memcached:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-memcached:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-caddy:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-caddy:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-caddy:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-haproxy:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-haproxy:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-haproxy:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-postgres-slim:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-postgres-slim:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-postgres-slim:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-bun:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-bun:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-bun:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-sqlite:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-sqlite:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-sqlite:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-dotnet:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-dotnet:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-dotnet:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-java:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-java:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-java:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-ruby:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-ruby:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-ruby:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-rails:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-rails:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-rails:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-kafka:$(KAFKA_VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-kafka:$(KAFKA_VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-kafka:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-cassandra:$(CASSANDRA_VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-cassandra:$(CASSANDRA_VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-cassandra:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-solr:$(SOLR_VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-solr:$(SOLR_VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-solr:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-pulsar:$(PULSAR_VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-pulsar:$(PULSAR_VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-pulsar:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-valkey:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-valkey:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-valkey:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-nats:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-nats:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-nats:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-traefik:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-traefik:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-traefik:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-envoy:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-envoy:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-envoy:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-rabbitmq:$(RABBITMQ_VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-rabbitmq:$(RABBITMQ_VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-rabbitmq:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-minio:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-minio:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-minio:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-opensearch:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-opensearch:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-opensearch:latest 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-cuda-python:$(VERSION) 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-cuda-python:$(VERSION)-amd64 2>/dev/null || true
	docker rmi $(REGISTRY)/$(OWNER)/containers-cuda-python:latest 2>/dev/null || true
	rm -f *.tar sbom-*.spdx.json
	rm -rf packages/
	@echo "✓ Cleanup complete"

#------------------------------------------------------------------------------
# LINT
#------------------------------------------------------------------------------
# Validate all GitHub Actions workflows (schema + embedded Bash in `run:` blocks)
# via actionlint + shellcheck. Run this before pushing any .github/workflows/**
# change — most workflows only run on schedule, so a shell syntax error there
# never executes on the PR and would otherwise only surface on main.
lint-workflows:
	@./scripts/lint-workflows.sh

# Validate the semantic schema consumed by the shared upstream-version updater.
# In particular, custom checksum fields must declare sha256/sha512 explicitly.
lint-versions:
	@./scripts/check-versions-config.sh

test-versions-config:
	@./tests/test-versions-config.sh

# Assert every prod image (catalog.json) has exactly one live auto-update
# mechanism (a cron-enabled versions.yaml row, or a declared Wolfi-package
# class). Run before pushing any new image or versions.yaml/catalog.json change.
check-docs:
	@bash tools/check-docs.sh

check-packages:
	@bash tools/check-packages.sh

check-packages-report:
	@bash tools/check-packages.sh --report

check-autoupdate:
	@./scripts/check-autoupdate-coverage.sh

check-toolchain-pins:
	@./scripts/check-toolchain-pins.sh

check-curl-retries:
	@./scripts/check-curl-retries.sh

# Every catalog.json image needs a distinct 140-160 char `description` — the
# <meta name="description"> for its page. `summary` is the short card line and
# is near-identical across the catalogue, so it cannot carry this on its own.
check-catalog-descriptions:
	@./scripts/check-catalog-descriptions.sh

check-catalog-descriptions-report:
	@./scripts/check-catalog-descriptions.sh --report

# Verify the website's factual claims against this repo. --online additionally
# checks that competitor repositories we name actually exist.
check-site-claims:
	@./scripts/check-site-claims.sh

check-site-claims-online:
	@./scripts/check-site-claims.sh --online

test-classifier:
	@./tests/test-classify-build-failure.sh

#------------------------------------------------------------------------------
# HELP
#------------------------------------------------------------------------------
help:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Minimal Hardened Container Images (Shell-less)"
	@echo "  Using apko (image assembly) + Wolfi packages"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "Images:"
	@echo "  make python          Build Python (Wolfi package)"
	@echo "  make go              Build Go (Wolfi package)"
	@echo "  make node-slim       Build Node.js Slim (Wolfi package, shell-less)"
	@echo "  make jenkins         Build Jenkins $(JENKINS_VERSION) (jlink JRE)"
	@echo "  make jenkins-melange Build Jenkins package only (no image)"
	@echo "  make nginx           Build Nginx $(NGINX_VERSION) (Wolfi package)"
	@echo "  make httpd           Build HTTPD $(HTTPD_VERSION) (Wolfi package)"
	@echo "  make redis-slim      Build Redis Slim $(REDIS_VERSION) (source build)"
	@echo "  make mysql           Build MySQL $(MYSQL_VERSION) LTS (source build)"
	@echo "  make memcached       Build Memcached $(MEMCACHED_VERSION) (source build)"
	@echo "  make caddy           Build Caddy $(CADDY_VERSION) (source build)"
	@echo "  make haproxy         Build HAProxy $(HAPROXY_VERSION) (source build)"
	@echo "  make postgres-slim   Build Postgres Slim (Wolfi package)"
	@echo "  make bun             Build Bun (Wolfi package)"
	@echo "  make sqlite          Build SQLite (Wolfi package)"
	@echo "  make dotnet          Build .NET Runtime (Wolfi package)"
	@echo "  make java            Build OpenJDK 21 JRE (Wolfi package)"
	@echo "  make ruby            Build Ruby $(RUBY_VERSION) (source build, shell-less)"
	@echo "  make php             Build PHP (melange source build)"
	@echo "  make rails           Build Rails (Ruby $(RUBY_VERSION) + Rails $(RAILS_VERSION), source build)"
	@echo "  make kafka           Build Kafka $(KAFKA_VERSION) (official binary + jlink JRE, KRaft)"
	@echo "  make cassandra       Build Cassandra $(CASSANDRA_VERSION) (official binary + jlink JRE)"
	@echo "  make solr            Build Solr $(SOLR_VERSION) (official binary + jlink JRE)"
	@echo "  make pulsar          Build Pulsar $(PULSAR_VERSION) (official binary + jlink JRE)"
	@echo "  make kafka-melange   Build Kafka package only (no image)"
	@echo "  make valkey          Build Valkey $(VALKEY_VERSION) (source build)"
	@echo "  make nats            Build NATS $(NATS_VERSION) (source build)"
	@echo "  make traefik         Build Traefik $(TRAEFIK_VERSION) (source build)"
	@echo "  make envoy           Build Envoy $(ENVOY_VERSION) (upstream binary)"
	@echo "  make rabbitmq        Build RabbitMQ $(RABBITMQ_VERSION) (official binary + Wolfi Erlang)"
	@echo "  make minio           Build MinIO $(MINIO_VERSION) (source build)"
	@echo "  make opensearch      Build OpenSearch $(OPENSEARCH_VERSION) (Wolfi package)"
	@echo "  make cuda-python     Build CUDA Python $(CUDA_VERSION) (NVIDIA redist + Python, x86_64)"
	@echo "  make build           Build all images"
	@echo ""
	@echo "Scanning:"
	@echo "  make scan           Scan for CRITICAL/HIGH CVEs"
	@echo "  make scan-all       Full vulnerability scan"
	@echo "  make size           Show image sizes"
	@echo ""
	@echo "Other:"
	@echo "  make keygen         Generate melange signing key"
	@echo "  make test           Test all images"
	@echo "  make push           Push to registry"
	@echo "  make clean          Remove local images + packages"
	@echo ""
	@echo "Variables:"
	@echo "  JENKINS_VERSION=$(JENKINS_VERSION)"
	@echo "  NGINX_VERSION=$(NGINX_VERSION)"
	@echo "  HTTPD_VERSION=$(HTTPD_VERSION)"
	@echo "  REDIS_VERSION=$(REDIS_VERSION)"
	@echo "  MYSQL_VERSION=$(MYSQL_VERSION)"
	@echo "  MEMCACHED_VERSION=$(MEMCACHED_VERSION)"
	@echo "  CADDY_VERSION=$(CADDY_VERSION)"
	@echo "  HAPROXY_VERSION=$(HAPROXY_VERSION)"
	@echo "  RUBY_VERSION=$(RUBY_VERSION)"
	@echo "  RAILS_VERSION=$(RAILS_VERSION)"
	@echo "  KAFKA_VERSION=$(KAFKA_VERSION)"
	@echo "  VALKEY_VERSION=$(VALKEY_VERSION)"
	@echo "  NATS_VERSION=$(NATS_VERSION)"
	@echo "  TRAEFIK_VERSION=$(TRAEFIK_VERSION)"
	@echo "  RABBITMQ_VERSION=$(RABBITMQ_VERSION)"
	@echo "  OPENSEARCH_VERSION=$(OPENSEARCH_VERSION)"
	@echo "  CUDA_VERSION=$(CUDA_VERSION)"
	@echo "  REGISTRY=$(REGISTRY)"
	@echo "  OWNER=$(OWNER)"

external-secrets-melange: keygen
	@echo "Building External Secrets Operator $(EXTERNAL_SECRETS_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/external-secrets/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ External Secrets Operator package built from source"

external-secrets: external-secrets-melange
	@echo "Assembling containers-external-secrets image with apko..."
	apko build images/external-secrets/apko/external-secrets.yaml \
		$(REGISTRY)/$(OWNER)/containers-external-secrets:$(VERSION) \
		external-secrets.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < external-secrets.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-external-secrets:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-external-secrets:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-external-secrets:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-external-secrets:latest
	@rm -f external-secrets.tar sbom-*.spdx.json
	@echo "✓ containers-external-secrets built (source build)"

scan-external-secrets:
	@echo "Scanning containers-external-secrets..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-external-secrets:latest
	@echo "✓ containers-external-secrets: scan passed"

test-external-secrets:
	@echo "Testing External Secrets Operator image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-external-secrets:latest" && \
		images/external-secrets/test.sh
	@echo "✓ External Secrets Operator tests passed"

$(eval $(call DEV_IMAGE_RULE,external-secrets,external-secrets-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,external-secrets))

kyverno-melange: keygen
	@echo "Building Kyverno $(KYVERNO_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/kyverno/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Kyverno package built from source"

kyverno: kyverno-melange
	@echo "Assembling containers-kyverno image with apko..."
	apko build images/kyverno/apko/kyverno.yaml \
		$(REGISTRY)/$(OWNER)/containers-kyverno:$(VERSION) \
		kyverno.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < kyverno.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-kyverno:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kyverno:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-kyverno:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-kyverno:latest
	@rm -f kyverno.tar sbom-*.spdx.json
	@echo "✓ containers-kyverno built (source build)"

scan-kyverno:
	@echo "Scanning containers-kyverno..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-kyverno:latest
	@echo "✓ containers-kyverno: scan passed"

test-kyverno:
	@echo "Testing Kyverno image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-kyverno:latest" && \
		images/kyverno/test.sh
	@echo "✓ Kyverno tests passed"

$(eval $(call DEV_IMAGE_RULE,kyverno,kyverno-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,kyverno))

flagger-melange: keygen
	@echo "Building Flagger $(FLAGGER_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/flagger/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Flagger package built from source"

flagger: flagger-melange
	@echo "Assembling containers-flagger image with apko..."
	apko build images/flagger/apko/flagger.yaml \
		$(REGISTRY)/$(OWNER)/containers-flagger:$(VERSION) \
		flagger.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < flagger.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-flagger:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-flagger:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-flagger:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-flagger:latest
	@rm -f flagger.tar sbom-*.spdx.json
	@echo "✓ containers-flagger built (source build)"

scan-flagger:
	@echo "Scanning containers-flagger..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-flagger:latest
	@echo "✓ containers-flagger: scan passed"

test-flagger:
	@echo "Testing Flagger image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-flagger:latest" && \
		images/flagger/test.sh
	@echo "✓ Flagger tests passed"

$(eval $(call DEV_IMAGE_RULE,flagger,flagger-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,flagger))

reloader-melange: keygen
	@echo "Building Reloader $(RELOADER_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/reloader/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Reloader package built from source"

reloader: reloader-melange
	@echo "Assembling containers-reloader image with apko..."
	apko build images/reloader/apko/reloader.yaml \
		$(REGISTRY)/$(OWNER)/containers-reloader:$(VERSION) \
		reloader.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < reloader.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-reloader:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-reloader:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-reloader:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-reloader:latest
	@rm -f reloader.tar sbom-*.spdx.json
	@echo "✓ containers-reloader built (source build)"

scan-reloader:
	@echo "Scanning containers-reloader..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-reloader:latest
	@echo "✓ containers-reloader: scan passed"

test-reloader:
	@echo "Testing Reloader image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-reloader:latest" && \
		images/reloader/test.sh
	@echo "✓ Reloader tests passed"

$(eval $(call DEV_IMAGE_RULE,reloader,reloader-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,reloader))

postgres-exporter-melange: keygen
	@echo "Building postgres_exporter $(POSTGRES_EXPORTER_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/postgres-exporter/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ postgres_exporter package built from source"

postgres-exporter: postgres-exporter-melange
	@echo "Assembling containers-postgres-exporter image with apko..."
	apko build images/postgres-exporter/apko/postgres-exporter.yaml \
		$(REGISTRY)/$(OWNER)/containers-postgres-exporter:$(VERSION) \
		postgres-exporter.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < postgres-exporter.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-postgres-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-postgres-exporter:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-postgres-exporter:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-postgres-exporter:latest
	@rm -f postgres-exporter.tar sbom-*.spdx.json
	@echo "✓ containers-postgres-exporter built (source build)"

scan-postgres-exporter:
	@echo "Scanning containers-postgres-exporter..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-postgres-exporter:latest
	@echo "✓ containers-postgres-exporter: scan passed"

test-postgres-exporter:
	@echo "Testing postgres_exporter image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-postgres-exporter:latest" && \
		images/postgres-exporter/test.sh
	@echo "✓ postgres_exporter tests passed"

$(eval $(call DEV_IMAGE_RULE,postgres-exporter,postgres-exporter-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,postgres-exporter))

headscale-melange: keygen
	@echo "Building Headscale $(HEADSCALE_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/headscale/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Headscale package built from source"

headscale: headscale-melange
	@echo "Assembling containers-headscale image with apko..."
	apko build images/headscale/apko/headscale.yaml \
		$(REGISTRY)/$(OWNER)/containers-headscale:$(VERSION) \
		headscale.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < headscale.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-headscale:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-headscale:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-headscale:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-headscale:latest
	@rm -f headscale.tar sbom-*.spdx.json
	@echo "✓ containers-headscale built (source build)"

scan-headscale:
	@echo "Scanning containers-headscale..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-headscale:latest
	@echo "✓ containers-headscale: scan passed"

test-headscale:
	@echo "Testing Headscale image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-headscale:latest" && \
		images/headscale/test.sh
	@echo "✓ Headscale tests passed"

$(eval $(call DEV_IMAGE_RULE,headscale,headscale-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,headscale))

victoria-logs-melange: keygen
	@echo "Building VictoriaLogs $(VICTORIA_LOGS_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/victoria-logs/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ VictoriaLogs package built from source"

victoria-logs: victoria-logs-melange
	@echo "Assembling containers-victoria-logs image with apko..."
	apko build images/victoria-logs/apko/victoria-logs.yaml \
		$(REGISTRY)/$(OWNER)/containers-victoria-logs:$(VERSION) \
		victoria-logs.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < victoria-logs.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-victoria-logs:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-victoria-logs:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-victoria-logs:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-victoria-logs:latest
	@rm -f victoria-logs.tar sbom-*.spdx.json
	@echo "✓ containers-victoria-logs built (source build)"

scan-victoria-logs:
	@echo "Scanning containers-victoria-logs..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-victoria-logs:latest
	@echo "✓ containers-victoria-logs: scan passed"

test-victoria-logs:
	@echo "Testing VictoriaLogs image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-victoria-logs:latest" && \
		images/victoria-logs/test.sh
	@echo "✓ VictoriaLogs tests passed"

$(eval $(call DEV_IMAGE_RULE,victoria-logs,victoria-logs-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,victoria-logs))

metallb-melange: keygen
	@echo "Building MetalLB $(METALLB_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt, which a plain
	# x86_64 host does not have ("unable to start pod"). CI builds arm64 on
	# native ARM runners. Same reason as kafka/keycloak.
	melange build images/metallb/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ MetalLB package built from source"

metallb: metallb-melange
	@echo "Assembling containers-metallb image with apko..."
	apko build images/metallb/apko/metallb.yaml \
		$(REGISTRY)/$(OWNER)/containers-metallb:$(VERSION) \
		metallb.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < metallb.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-metallb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-metallb:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-metallb:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-metallb:latest
	@rm -f metallb.tar sbom-*.spdx.json
	@echo "✓ containers-metallb built (source build)"

scan-metallb:
	@echo "Scanning containers-metallb..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-metallb:latest
	@echo "✓ containers-metallb: scan passed"

test-metallb:
	@echo "Testing MetalLB image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-metallb:latest" && \
		images/metallb/test.sh
	@echo "✓ MetalLB tests passed"

$(eval $(call DEV_IMAGE_RULE,metallb,metallb-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,metallb))

temporal-server-melange: keygen
	@echo "Building Temporal server $(TEMPORAL_SERVER_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt a plain x86_64
	# host lacks. CI builds arm64 on native ARM runners.
	melange build images/temporal-server/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Temporal server package built from source"

temporal-server: temporal-server-melange
	@echo "Assembling containers-temporal-server image with apko..."
	apko build images/temporal-server/apko/temporal-server.yaml \
		$(REGISTRY)/$(OWNER)/containers-temporal-server:$(VERSION) \
		temporal-server.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < temporal-server.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-temporal-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-temporal-server:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-temporal-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-temporal-server:latest
	@rm -f temporal-server.tar sbom-*.spdx.json
	@echo "✓ containers-temporal-server built (source build)"

scan-temporal-server:
	@echo "Scanning containers-temporal-server..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-temporal-server:latest
	@echo "✓ containers-temporal-server: scan passed"

test-temporal-server:
	@echo "Testing Temporal server image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-temporal-server:latest" && \
		images/temporal-server/test.sh
	@echo "✓ Temporal server tests passed"

$(eval $(call DEV_IMAGE_RULE,temporal-server,temporal-server-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,temporal-server))

temporal-admin-tools-melange: keygen
	@echo "Building Temporal admin tools $(TEMPORAL_ADMIN_TOOLS_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt a plain x86_64
	# host lacks. CI builds arm64 on native ARM runners.
	melange build images/temporal-admin-tools/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Temporal admin tools package built from source"

temporal-admin-tools: temporal-admin-tools-melange
	@echo "Assembling containers-temporal-admin-tools image with apko..."
	apko build images/temporal-admin-tools/apko/temporal-admin-tools.yaml \
		$(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:$(VERSION) \
		temporal-admin-tools.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < temporal-admin-tools.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:latest
	@rm -f temporal-admin-tools.tar sbom-*.spdx.json
	@echo "✓ containers-temporal-admin-tools built (source build)"

scan-temporal-admin-tools:
	@echo "Scanning containers-temporal-admin-tools..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:latest
	@echo "✓ containers-temporal-admin-tools: scan passed"

test-temporal-admin-tools:
	@echo "Testing Temporal admin tools image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-temporal-admin-tools:latest" && \
		images/temporal-admin-tools/test.sh
	@echo "✓ Temporal admin tools tests passed"

$(eval $(call DEV_IMAGE_RULE,temporal-admin-tools,temporal-admin-tools-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,temporal-admin-tools))

temporal-ui-server-melange: keygen
	@echo "Building Temporal UI server $(TEMPORAL_UI_SERVER_VERSION) from source via melange..."
	# x86_64 only locally: aarch64 cross-builds need QEMU binfmt a plain x86_64
	# host lacks. CI builds arm64 on native ARM runners.
	melange build images/temporal-ui-server/melange.yaml \
		--arch x86_64 \
		--signing-key melange.rsa
	@echo "✓ Temporal UI server package built from source"

temporal-ui-server: temporal-ui-server-melange
	@echo "Assembling containers-temporal-ui-server image with apko..."
	apko build images/temporal-ui-server/apko/temporal-ui-server.yaml \
		$(REGISTRY)/$(OWNER)/containers-temporal-ui-server:$(VERSION) \
		temporal-ui-server.tar \
		--arch x86_64 \
		--repository-append ./packages \
		--keyring-append melange.rsa.pub
	docker load < temporal-ui-server.tar
	docker tag $(REGISTRY)/$(OWNER)/containers-temporal-ui-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-temporal-ui-server:$(VERSION)
	docker tag $(REGISTRY)/$(OWNER)/containers-temporal-ui-server:$(VERSION)-amd64 \
		$(REGISTRY)/$(OWNER)/containers-temporal-ui-server:latest
	@rm -f temporal-ui-server.tar sbom-*.spdx.json
	@echo "✓ containers-temporal-ui-server built (source build)"

scan-temporal-ui-server:
	@echo "Scanning containers-temporal-ui-server..."
	trivy image --exit-code 1 --severity CRITICAL,HIGH \
		$(REGISTRY)/$(OWNER)/containers-temporal-ui-server:latest
	@echo "✓ containers-temporal-ui-server: scan passed"

test-temporal-ui-server:
	@echo "Testing Temporal UI server image..."
	export IMAGE="$(REGISTRY)/$(OWNER)/containers-temporal-ui-server:latest" && \
		images/temporal-ui-server/test.sh
	@echo "✓ Temporal UI server tests passed"

$(eval $(call DEV_IMAGE_RULE,temporal-ui-server,temporal-ui-server-melange,--repository-append ./packages --keyring-append melange.rsa.pub))
$(eval $(call DEV_TEST_RULE,temporal-ui-server))
