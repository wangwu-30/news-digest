#!/bin/bash
# News Fetcher - 6551 API

TOKEN="${OPENNEWS_TOKEN:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNzl5aUJ0ZXphTm5hQkE0N2dRTURDR0s0dkVqdEJtWEVia25yVm8zRUY1elkiLCJub25jZSI6ImIwMTM2YjgyLWRkYmQtNGQ5Yy04MGVlLTk3ZTZhYWUyODRjYyIsImlhdCI6MTc3MjE2OTg3NywianRpIjoiZmNiYjBhODYtNjc4Yy00MWUzLWJkNGYtYjBiNDM0YWEwOTFhIn0.yf23ixX0jcKjPtValaj2bV7XF2ueuvZYwb01hq3wMzU}"
API_URL="https://ai.6551.io/open/news_search"
OUTPUT_DIR="/Users/wangwu/workspace/news-digest/output"
DISCORD_WEBHOOK="${DISCORD_WEBHOOK}"

mkdir -p "$OUTPUT_DIR"

# 抓取高评分新闻 (score >= 60)
fetch_news() {
  curl -s -X POST "$API_URL" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "limit": 50,
      "page": 1,
      "engineTypes": {"news": ["Twitter", "Bloomberg", "Reuters"]}
    }' | jq '[.data[] | select(.aiRating.score >= 60)]'
}

# 解析并推送
main() {
  echo "Fetching news..."
  NEWS=$(fetch_news)
  
  # 保存到 latest.json
  echo "$NEWS" > "$OUTPUT_DIR/latest.json"
  
  # 统计
  COUNT=$(echo "$NEWS" | jq 'length')
  echo "Found $COUNT high-score news"
  
  # 推送到 Discord (如果有 webhook)
  if [ -n "$DISCORD_WEBHOOK" ]; then
    # 取 Top 3 推送
    TOP3=$(echo "$NEWS" | jq -r '.[:3] | .[] | "[\(.aiRating.score)分] \(.text[0:100])... \n来源: \(.newsType)\n"')
    
    curl -s -X POST "$DISCORD_WEBHOOK" \
      -H "Content-Type: application/json" \
      -d "{\"content\": \"📰 新闻速递 (Top $COUNT)\n\n$TOP3\"}"
  fi
}

main
