# News Digest Project

每小时抓取 6551 新闻，筛选高评分推送到 Discord，生成每日 Top10。

## 文件结构

- `fetch.sh` - 新闻抓取脚本
- `daily.sh` - 每日 Top10 生成
- `config.json` - 配置文件
- `output/` - 输出目录
  - `latest.json` - 最新高评分新闻
  - `daily-YYYY-MM-DD.json` - 每日汇总

## 环境变量

- `OPENNEWS_TOKEN` - 6551 API Token

## 使用

```bash
./fetch.sh        # 抓取新闻
./daily.sh        # 生成每日 Top10
```
