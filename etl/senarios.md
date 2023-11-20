# ETL Pipeline
## Senarios
### 주단위 파이프라인 동작 시나리오
1. 매주 화요일 AM 03:00에 DB Backup 실행
2. Backup 종료 후 Crawling 실행
3. Crawling 종료 후 Transform 실행
4. Transform 종료 후 Load로 메시지 보내기
5. Load 종료 및 파이프라인 종료