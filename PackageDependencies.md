mermaid
graph TD;

subgraph Boarding
    BoardingApp-->BoardingCore;
    BoardingUI-->BoardingCore;
    BoardingTests-->BoardingApp;
end

subgraph Debug
end

subgraph Integration
    IntegrationApp-->IntegrationCore;
end

subgraph Intro
    IntroTests-->Intro;
end

subgraph Kimai
    KimaiUI-->KimaiCore;
    KimaiServices-->KimaiCore;
    KimaiApp-->KimaiCore;
    KimaiApp-->KimaiUI;
    KimaiApp-->KimaiServices;
    KimaiCoreTests-->KimaiCore;
    KimaiCoreTests-->KimaiApp;
end

subgraph Login
    LoginUI-->LoginCore;
    LoginServices-->LoginCore;
    LoginApp-->LoginCore;
    LoginApp-->LoginServices;
    LoginApp-->LoginUI;
    CoreTests-->LoginCore;
    UITests-->LoginUI;
end

