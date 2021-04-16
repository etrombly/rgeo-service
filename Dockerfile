FROM rustlang/rust:nightly-alpine as prereq
RUN apk add --no-cache musl-dev

FROM prereq as planner
WORKDIR /app
RUN cargo install cargo-chef 
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM prereq as cacher
WORKDIR /app
RUN cargo install cargo-chef 
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json

FROM prereq as builder
WORKDIR /app
COPY . .
COPY --from=cacher /app/target target
COPY --from=cacher $CARGO_HOME $CARGO_HOME
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/rgeo-service /
EXPOSE 8000/tcp
CMD ["/rgeo-service"]