#!/bin/bash
# Build static site

OUTPUT_DIR="/Users/wangwu/workspace/news-digest/output"
SITE_DIR="/Users/wangwu/workspace/news-digest/site"
DATE=$(date +%Y-%m-%d)

mkdir -p "$SITE_DIR"

# Copy latest data
cp "$OUTPUT_DIR/latest.json" "$SITE_DIR/"

# Copy index.html
cp /Users/wangwu/workspace/news-digest/index.html "$SITE_DIR/"

echo "Built to $SITE_DIR"
