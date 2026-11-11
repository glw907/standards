# Build System

Reference for the `go-conventions` skill. Read it before writing or changing a Makefile, a gate, or
the lint config.

Makefile with these targets:

```makefile
BINARY := tool-name

build:   go build -o $(BINARY) ./cmd/tool-name
test:    go test ./...
vet:     go vet ./...
lint:    golangci-lint run ./...
install: go install ./cmd/tool-name
check:   vet lint test
clean:   rm -f $(BINARY)
```

`make check` is the gate before committing, and every step in it
gates. A check either gates or does not exist. Never guard a step
with `command -v tool || echo "skipping"`: that turns a missing or
misconfigured tool into a green build, and the gate then decays
silently for months. If a tool is required, let its absence fail
loudly. If reproducible tool versions matter, pin them in a
separate `tools/go.mod` and invoke them with `go run -C tools`,
which keeps the product module's dependency graph clean.

No code generation and no CGO. No build tags in product code; a
test-only tag (for example `perf`) is allowed when the gate runs `go vet`
and the tests under that tag too, so the tagged files do not rot.

The lint config (`.golangci.yml`, linters, and the v2 schema traps) is in
[linting.md](linting.md).
