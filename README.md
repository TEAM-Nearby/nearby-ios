# Nearby
> 따로, 또 함께하는 여행

**가까운 여행자와 부담없이 한 끼를 함께할 수 있도록 연결하는, 혼자 여행자를 위한 실시간 식사 동행 서비스**

<br>

## Architecture
> MVVM + Coordinator + DI Container
<img width="800" alt="architecture" src="https://github.com/user-attachments/assets/7768b126-9566-4c90-91a6-333bd2bc2812" />


<br>
<br>

## Tech Stack & Library
| Category | Library / Framework | Version | Description |
| :--- | :--- | :--- | :--- |
| Native | **Swift Concurrency** | `Swift 5.5+` | `async/await`, `Task` 기반의 비동기 처리 |
| Native | **Combine** | `iOS 13+` | 가독성 높은 데이터 바인딩 및 비동기 이벤트 스트림 관리 |
| Native | **Logger** | `iOS 14+` | 시스템 표준 프레임워크 기반의 효율적인 디버깅 로그 출력 |
| SPM | **Alamofire** | `5.12.0` | HTTP 네트워크 통신 구조화 및 API 요청/응답 관리 |
| SPM | **GoogleMaps** | `10.15.0` | 위치 기반 정보 제공 및 구글 맵 UI 연동 |
| SPM | **KakaoOpenSDK** | `2.28.0` | 카카오 계정 로그인 및 유저 프로필 연동 |
| SPM | **Kingfisher** | `8.10.0` | 웹 이미지 비동기 다운로드 및 메모리/디스크 캐싱 |
| SPM | **SnapKit** | `6.0.0` | Auto Layout 제약 조건 최적화 및 레이아웃 구현 |
| SPM | **Then** | `3.0.0` | 간결한 선언형 컴포넌트 초기화 및 코드 가독성 향상 |

<br>

## Git Flow
[우아한 형제들 Git Flow](https://techblog.woowahan.com/2553/)를 기반으로 진행합니다. 

- `Issue = 1 PR` 원칙을 준수합니다.
- `리드 승인 + 최소 팀원 1명의 승인`을 모두 받아야만 develop 브랜치로 Merge 할 수 있습니다.
```
작업 브랜치 최신화 방법은 다음과 같습니다.

git checkout develop
git pull origin develop
git checkout [작업-브랜치]
git merge develop
```
<br>

## Convention
기본적으로 [스타일쉐어 Swift 가이드](https://github.com/StyleShare/swift-style-guide)를 기반으로 진행하며, 일부 규칙은 SwiftLint를 활용해 Xcode 내에서 강제 컨벤션으로 관리합니다.


### Prefix
| Prefix | 사용 |
|-----------|------|
| `feat` | 새로운 기능 구현 |
| `fix` | 버그나 오류 해결 |
| `chore` | 코드 수정, 내부 파일 수정, 애매한 것들이나 잡일 |
| `design` | 디자인 시보정 |
| `add` | 에셋 추가 |
| `del` | 사용하지 않는 코드 삭제 |
| `docs` | README나 WIKI 등의 문서 개정 |
| `refactor` | 전면 수정 |
| `setting` | 라이브러리 추가, 프로젝트 설정 관련 |
| `merge` | 작업 브랜치를 develop 브랜치로 merge |

### Branch
`Prefix/#이슈번호`
```
feat/#1
```

### Commit Message
`[Prefix] #이슈번호 작업`

```
[feat] #1 메인 UI 구현
[merge] #1 메인 UI 구현
```
<br>

## Foldering 
```![Uploading architecture.svg…]()<img width="16776" height="11340" alt="architecture" src="https://github.com/user-attachments/assets/d35d5de1-a74c-4b13-b658-fc077cc515b1" />
Nearby
│
├── App                                
│   ├── AppDelegate.swift              
│   ├── SceneDelegate.swift            
│   ├── AppCoordinator.swift           
│   └── AppDIContainer.swift           
│
├── Core 
│   ├── Config                       
│   ├── Logger                            
│   └── Error                                 
│
├── Resource 
│   ├── Assets.xcassets 
│   ├── Fonts
│   └── Info.plist
│
├── Data        
│   ├── Network                       
│   ├── API                            
│   ├── DTO                           
│   └── Repository                     
│
└── Presentation      
    ├── Common                         
    │
    └── Feature
        ├── Coordinator                
        ├── ViewController            
        └── ViewModel

```
