#!/usr/bin/env bash
set -euo pipefail

# Read env
if [ -z "${SUPABASE_URL:-}" ]; then
  echo "SUPABASE_URL is not set"; exit 1
fi
if [ -z "${SUPABASE_KEY:-}" ]; then
  echo "SUPABASE_KEY is not set"; exit 1
fi

# Normalise URL (remove trailing slash)
URL="${SUPABASE_URL%/}/functions/v1/process-battles"

AUTH_HEADER="Authorization: Bearer ${SUPABASE_KEY}"
CONTENT="Content-Type: application/json"

attempt=0
max_attempts=3
sleep_seconds=3

while [ $attempt -lt $max_attempts ]; do
  attempt=$((attempt+1))
  echo "Attempt $attempt to call $URL"
  resp=$(curl -sS -w "\n%{http_code}" -X POST "$URL" -H "$AUTH_HEADER" -H "$CONTENT" -d '{}' --fail 2>curl_err.log) || true
  body=$(echo "$resp" | sed '$d' || true)
  code=$(echo "$resp" | tail -n1 || true)

  if [ -s curl_err.log ]; then
    echo "curl stderr (short):"
    head -n 5 curl_err.log || true
  fi

  echo "HTTP status: ${code:-000}"
  echo "Response body (truncated to 1000 chars):"
  echo "${body}" | head -c 1000 || true
  echo

  if [ "${code}" = "200" ] || [ "${code}" = "204" ] || [ "${code}" = "202" ]; then
    echo "Invocation succeeded on attempt $attempt"
    rm -f curl_err.log
    exit 0
  fi

  if [ $attempt -lt $max_attempts ]; then
    echo "Invocation failed; retrying after ${sleep_seconds}s..."
    sleep $sleep_seconds
    sleep_seconds=$((sleep_seconds * 2))
  else
    echo "Invocation failed after $max_attempts attempts"
    echo "Last curl stderr (full):"
    cat curl_err.log || true
    rm -f curl_err.log
    exit 1
  fi
done
