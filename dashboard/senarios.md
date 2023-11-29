# Dashboard
## Senarios
### 데이터 마이그레이션 시나리오
> Migration은 Dashboard -> Service부터 진행된다
1. Source(RDB/DocumentDB)에서 Tmp Storage로 데이터 백업
2. Migrator가 Tmp Storage에서 데이터를 가져와 Dest(DocumentDB/RDB)에 맞는 형식으로 변환
3. Desc(DocumentDB/RDB)에 데이터 업데이트  
### 대시보드 데이터 업데이트 시나리오
1. Admin 로그인
2. 데이터 수정 및 반영 
3. 다음 마이그레이션 시간(1/day)에 **데이터 마이그레이션 시나리오** 동작