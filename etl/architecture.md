# ETL Pipeline
## Architecture
``` mermaid
---
title: Pyoniverse ETL Pipeline
---
graph TD;
    %% Flow
    Start((Start));
    End((End));
    Backup[Database Backup];
    BackupResult{Backup Done};
    BackupStorage[(BackupStorage)];
    Crawling[Crawl Data];
    CrawlingResult{Crawling Done};
    CrawlingStorage[(CrawlingStorage)];
    TransformCrawling[Transform Crawled Data];
    TransformCrawlingResult{Transform Done};
    TransformCrawlingStorage[(TransformCrawlingStorage)];
    TransformCrawlingResultMessage[/Upserted Data Message/];
    LoadData[Load & Update DB];
    LoadDataResult{Update Done};

    %% IO
    Current[/Current Date/];
    NoticeFailure[/Notice failed reasons/];
    NoticeSuccess[/Notice success/]


    Start --> Current;
    Current --> Backup --> BackupResult;
    BackupResult -->|success| BackupStorage;
    BackupResult -->|fail| NoticeFailure;

    BackupResult -->|success| Crawling --> CrawlingResult;
    CrawlingResult -->|success| CrawlingStorage;
    CrawlingResult -->|fail| NoticeFailure;

    Current & BackupStorage & CrawlingStorage --> TransformCrawling --> TransformCrawlingResult;
    TransformCrawlingResult -->|success| TransformCrawlingStorage & TransformCrawlingResultMessage;
    TransformCrawlingResult -->|fail| NoticeFailure;

    TransformCrawlingStorage & TransformCrawlingResultMessage --> LoadData --> LoadDataResult;
    LoadDataResult -->|success| NoticeSuccess;
    LoadDataResult -->|fail| NoticeFailure;

    NoticeFailure & NoticeSuccess --> End;
```
### 아키텍처 구조
- 파이프라인 아키텍처
- `Backup`, `Crawling`, `Transform`, `Load`가 Filter를 구성한다.
- 각 필터의 동작은 이전 단계 필터의 성공 여부에 따라 결정된다.
- 각 필터는 별도로 배포되어 관리된다.

### 아키텍처 특성
- `유지보수성 - 디버깅`: 파이프라인 실행 도중 발생한 오류는 캡쳐되어 확인할 수 있다.
- `유지보수성 - 디자인`: 각 필터는 적잘한 구조로 설계되어 새로운 기능의 확장이 용이해야 한다.
- `신장성`: 각 필터는 이벤트를 기반으로 연결되기 때문에 새로운 필터를 손쉽게 도입할 수 있다.
- `테스트용이성`: 각 필터는 이전 단계와 관계없이 정해진 Input, Output 형식을 갖고 있기 때문에 독립적인 테스트가 가능하다.
- `성능 - 메모리`: 각 필터는 4GB 이하의 램 용량으로 동작 가해야 한다.
- `성능 - 시간`: 파이프라인이 동작을 완료하는 시간은 3시간 이하여야 한다.
- `내구성 - DB`: 한번에 모든 데이터를 업데이트하지 않고, 업데이트 내역을 잘라서 업데이트한다. 이것을 위해 `Load` 필터는 메시지를 수신하여 역할을 수행한다.
### 아키텍처 결정
- 필터간 실행 순서는 이전 필터의 이벤트 종료 메시지를 기반으로 동작한다.
- BackupStorage는 DB를 제외한 외부 저장소를 이용해야 한다.
- 파이프라인은 스케쥴링되어 실행되어야 한다.
- 각 필터는 자신의 Input이 정의되어야 하며 연결되는 다른 필터의 Input에 Output을 맞춰야 한다.
- 통합 테스트는 반드시 작성되어야 한다.
### 설계 원칙
- 순환복잡도는 10이하여야 한다.
- 순환의존성은 없어야 한다.
- WMC(클래스의 평균 메서드 수)는 20이하여야 한다.
- 각 모듈에 대한 단위 테스트가 정의되어야 한다.
- 단위 테스트는 경계값 테스트를 포함해야 한다.