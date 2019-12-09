GO := go
NAME := lioss
VERSION := 1.0.0

all: test build

setup: update_version
	git submodule update --init

update_version:
	@for i in README.md docs/content/_index.md; do
		sed -e 's!Version-[-09.]*-yellowgreen!Version-${VERSION}-yellowgreen!g' -e 's!v[0-9.]*!tag/v${VERSION}!g' $$i > a ; mv a $$i
	done
	@mv 's/const VERSION = .*/const VERSION = "${VERSION}"/g' cmd/lioss/main.go > a ; mv a /cmd/lioss/main.go
	@echo "Replace version to \"${VERSION}\""

test: setup
	$(GO) test -covermode=count -coverprofile=coverage.out $$(go list ./...)

build: test
	$(GO) build -o $(NAME) -v cmd/$(NAME)/main.go

clean:
	$(GO) clean
	rm -rf $(NAME)
