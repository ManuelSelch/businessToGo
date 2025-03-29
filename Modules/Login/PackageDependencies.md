```mermaid
graph TD;
    LoginUI-->LoginCore;
    LoginServices-->LoginCore;
    LoginApp-->LoginCore;
    LoginApp-->LoginServices;
    LoginApp-->LoginUI;
    CoreTests-->LoginCore;
    UITests-->LoginUI;
```