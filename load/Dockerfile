FROM golang:1.13-alpine

WORKDIR /bench

ENV GO111MODULE=on

RUN go get github.com/tsenart/vegeta@v12.7.0

RUN go get github.com/rs/jplot@1.1.0

RUN go get github.com/rs/jaggr@1.0.0

COPY ./attack.sh .

CMD ["./attack.sh"]
