BIN_FOLDER:=$(CURDIR)/bin

PROTOC = PATH="$$PATH:$(BIN_FOLDER)" protoc

.PHONY: bin-deps
bin-deps:
	$(info Installing binary dependencies...)

	GOBIN=$(BIN_FOLDER) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
	GOBIN=$(BIN_FOLDER) go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0

GEN_OUT_PATH:=$(CURDIR)/gen/go

.PHONY: protoc-generate
protoc-generate:
	protoc \
	  -I proto/sso/v1 \
	  --plugin=protoc-gen-go=$(BIN_FOLDER)/protoc-gen-go \
		--go_out $(GEN_OUT_PATH)\
		--go_opt paths=source_relative \
	  --plugin=protoc-gen-go-grpc=$(BIN_FOLDER)/protoc-gen-go-grpc \
		--go-grpc_out $(GEN_OUT_PATH)\
		--go-grpc_opt paths=source_relative \
	  proto/sso/v1/sso.proto
	go mod tidy
