# builder

FROM golang:1.24 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o  parcel_app .

# production

FROM scratch

WORKDIR /app

COPY --from=builder /app/parcel_app ./

COPY tracker.db ./

CMD ["./parcel_app"]

