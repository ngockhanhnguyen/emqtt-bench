REBAR ?= $(CURDIR)/rebar3

.PHONY: all
all: release

.PHONY: release
release: compile
	$(REBAR) as emqtt_bench tar
	@$(CURDIR)/scripts/rename-package.sh

.PHONY: pre-release
pre-release: compile
	$(REBAR) as emqtt_bench release

.PHONY: compile
compile: $(REBAR)
	$(REBAR) compile

.PHONY: clean
clean: distclean

.PHONY: distclean
distclean:
	@rm -rf _build erl_crash.dump rebar3.crashdump rebar.lock emqtt_bench

.PHONY: xref
xref: compile
	$(REBAR) xref

.PHONY: docker
docker:
	@docker build --no-cache -t emqtt_bench:$$(git describe --tags --always) .

.PHONY: ensure-rebar3
ensure-rebar3:
	$(CURDIR)/scripts/ensure-rebar3.sh

$(REBAR): ensure-rebar3
