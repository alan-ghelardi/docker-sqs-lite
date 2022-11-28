#!/usr/bin/env bash

set -euo pipefail

SQS_HOST="0.0.0.0"
SQS_PORT=3000

create_queues() {
    wait-for-it -q $SQS_HOST:$SQS_PORT --timeout=10

    IFS=',' read -ra queues <<< ${QUEUE_NAMES:-''}
    if [ ! -z ${queues-} ]; then
        for queue in "${queues[@]}"; do
            aws sqs create-queue --queue-name="$queue" \
                --attributes '{"FifoQueue":"true"}' \
                --region=us-east-1 \
                --endpoint=http://localhost:$SQS_PORT
        done
    fi
}

create_queues & sqslite --host $SQS_HOST --port $SQS_PORT
