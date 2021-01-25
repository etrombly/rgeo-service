FROM rustlang/rust:nightly-alpine as build

WORKDIR /usr/src
RUN apk add --no-cache musl-dev git
RUN git clone https://github.com/etrombly/rgeo-service.git
WORKDIR /usr/src/rgeo-service
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM scratch

COPY --from=build //usr/src/rgeo-service/target/x86_64-unknown-linux-musl/release/rgeo-service /
EXPOSE 8000/tcp
CMD ["/rgeo-service"]