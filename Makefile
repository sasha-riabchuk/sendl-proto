GEN_DIR := gen/go/platform

.PHONY: gen
gen:
	mkdir -p $(GEN_DIR)
	protoc \
	  --proto_path=platform \
	  --go_out=$(GEN_DIR) --go_opt=paths=source_relative \
	  --go-grpc_out=$(GEN_DIR) --go-grpc_opt=paths=source_relative \
	  platform/*.proto
