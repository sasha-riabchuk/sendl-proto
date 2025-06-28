.PHONY: generate clean

generate:
	@echo "Generating protobuf files..."
	@protoc \
		--proto_path=. \
		--go_out=gen/go \
		--go-grpc_out=gen/go \
		media/media.proto platform/platform.proto

clean:
	@echo "Cleaning generated files..."
	@rm -rf gen/go/media/*.pb.go gen/go/platform/*.pb.go
