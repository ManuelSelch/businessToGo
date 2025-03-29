```mermaid
graph TD;
    KimaiUI-->KimaiCore;
    KimaiServices-->KimaiCore;
    KimaiApp-->KimaiCore;
    KimaiApp-->KimaiUI;
    KimaiApp-->KimaiServices;
    KimaiCoreTests-->KimaiCore;
    KimaiCoreTests-->KimaiApp;
```