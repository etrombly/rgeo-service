FROM rustlang/rust:nightly-alpine as build

WORKDIR /usr/src/rgeo-service
RUN apk add --no-cache musl-dev
COPY . .
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM scratch

COPY --from=build //usr/src/rgeo-service/target/x86_64-unknown-linux-musl/release/rgeo-service /
EXPOSE 8000/tcp
CMD ["/rgeo-service"]