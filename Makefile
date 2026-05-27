# set version in main.go for `go install` and build binary
build:
	$(eval VERSION := $(shell git describe --tags HEAD 2>/dev/null || echo unknown))
	$(shell sed -E -i '' -e "s/^var version = \"[A-Za-z0-9\.-_]+\"/var version = \"$(VERSION)\"/" main.go)
	go build -o bin/scmpuff -mod=readonly -ldflags "-X main.version=$(VERSION)"

# assumes standard ~/go/bin directory
install: build
	cp bin/scmpuff ~/go/bin/

# run unit tests
test:
	go test -short ./...

# run lint tests
lint:
	golangci-lint run

# run integration tests (testscript harness)
integration:
	go test ./internal/cmd -run TestScripts

# package as if for distribution
package:
	goreleaser release --clean --skip publish,homebrew

# clean temp files
clean:
	@:

# remove all build artifacts
clobber:
	rm -rf ./dist
	rm -f bin/scmpuff

.PHONY: build install test integration lint package clean clobber
