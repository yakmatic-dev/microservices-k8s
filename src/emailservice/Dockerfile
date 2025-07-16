FROM --platform=$BUILDPLATFORM python:3.9-alpine AS base

FROM base AS builder

RUN apk update \
    && apk add --no-cache g++ linux-headers \
    && rm -rf /var/cache/apk/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

FROM base
ENV PYTHONUNBUFFERED=1
ENV ENABLE_PROFILER=1

RUN apk update \
    && apk add --no-cache libstdc++ \
    && rm -rf /var/cache/apk/*

WORKDIR /email_server

# Copy installed packages
COPY --from=builder /install /usr/local

# Copy app code
COPY . .

EXPOSE 8080

ENTRYPOINT ["python", "email_server.py"]

