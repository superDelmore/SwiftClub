FROM vapor/swift:5.0
WORKDIR /app
ADD . ./
RUN swift package clean
RUN swift build -c release
RUN mkdir /app/bin
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8977
ENTRYPOINT ./bin/release/Run serve -e prod -b 0.0.0.0
