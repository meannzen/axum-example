
FROM lukemathwalker/cargo-chef:latest-rust-1.78.0 as chef
WORKDIR /app
RUN apt update && apt install lld clang -y && rm -rf /var/lib/apt/lists/*

FROM chef as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /app/recipe.json recipe.json
COPY . .
RUN cargo build --release --bin example

FROM debian:bookworm-slim AS runtime
WORKDIR /app
COPY --from=builder /app/target/release/example example
RUN chmod +x /app/example # Ensures the binary is executable
EXPOSE 8080
ENTRYPOINT ["/app/example"] # Uses absolute path
