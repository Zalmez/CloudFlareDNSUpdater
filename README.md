# CloudFlareDNSUpdater
A powershell script to update dns entries

With windows you can use the task scheduler to run this automatically - note you may have to check your GPO policies to run this or sign the script

```
- Open Task Scheduler
- Right click and click "Create Basic Task"
- Give it a name & a description
- set how often you'd like the script to trigger
- Click next with the "Start a program" option picked
- find where you have your powershell instance installed, by default on windows it should be under "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
- By the "Add arguments" box write the following: -File "YourPath/CloudFlareDNSUpdater/cloudflare dns updater.ps1"
```
